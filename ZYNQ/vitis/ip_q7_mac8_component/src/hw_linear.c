
#include <string.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xaxidma.h"
#include "ip_q7_mac8.h"
#include "board_io.h"

#include "../basic/default/aimath/aimath_q7_default.h"

#define IP_BASE   XPAR_IP_Q7_MAC8_0_BASEADDR
#define MAX_M     512

static XAxiDma dma;                                            // le DMA
static uint64_t res_buf[MAX_M] __attribute__((aligned(64)));   // résultats : 1 mot de 64 bits par neurone
static int8_t   w_pool[576*1024] __attribute__((aligned(64))); // copie alignée des poids des 5 couches
static uint32_t w_used = 0;

static const int8_t *w_src[5];    // adresse d'origine des poids de chaque couche
static int8_t       *w_dst[5];    // sa copie alignée
static int           w_n = 0;


int hw_linear_init(void)
{
    XAxiDma_Config *cfg = XAxiDma_LookupConfig(XPAR_XAXIDMA_0_BASEADDR);
    if (cfg == NULL) return -1;
    if (XAxiDma_CfgInitialize(&dma, cfg) != XST_SUCCESS) return -2;
    XAxiDma_IntrDisable(&dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
    return 0;
}


void hw_linear32_bt(const aitensor_t *a, const aitensor_t *b, const aitensor_t *c, aitensor_t *result){
    uint16_t i, j, k;
	int32_t sum, acc; // 16-bit accumulator
	uint16_t a_shift = ((aimath_q7_params_t *) a->tensor_params)->shift;
	uint16_t b_shift = ((aimath_q7_params_t *) b->tensor_params)->shift;
	uint16_t c_shift = ((aimath_q31_params_t *) c->tensor_params)->shift;
	uint16_t result_shift = ((aimath_q7_params_t *) result->tensor_params)->shift;

	int8_t z_a = ((aimath_q7_params_t *) a->tensor_params)->zero_point;
	int8_t z_b = ((aimath_q7_params_t *) b->tensor_params)->zero_point;
	int8_t z_result = ((aimath_q7_params_t *) result->tensor_params)->zero_point;

	// Output scaling factor M = (S_1 * S_2) / S_3
	uint16_t output_shift = a_shift + b_shift - result_shift;

	int8_t *a_data = (int8_t *) a->data;
	int8_t *b_data = (int8_t *) b->data;
	int32_t *c_data;
	if(c != 0) c_data = (int32_t *) c->data;
		int8_t *result_data = (int8_t *) result->data;

		int8_t *w_hw = NULL;
	for (int n = 0; n < w_n; n++)
		if (w_src[n] == b_data) w_hw = w_dst[n];

	if (w_hw == NULL) {                                  // première fois pour cette couche
		uint32_t bytes = b->shape[0] * b->shape[1];
		w_used = (w_used + 63) & ~63u;                   // départ aligné sur 64 octets
		w_hw = &w_pool[w_used];
		memcpy(w_hw, b_data, bytes);
		Xil_DCacheFlushRange((UINTPTR)w_hw, bytes);      // une seule fois : les poids ne changent plus
		w_src[w_n] = b_data;  w_dst[w_n] = w_hw;  w_n++;
		w_used += bytes;
}


	for(i = 0; i < a->shape[0]; i++)
	{
		uint32_t N = a->shape[1], M = b->shape[0];

		// 1) activations -> registres
		int32_t sum_a = 0;
		for (k = 0; k < N; k += 4) {
			uint32_t mot = (uint8_t)a_data[i*N+k]
						| ((uint8_t)a_data[i*N+k+1] << 8)
						| ((uint8_t)a_data[i*N+k+2] << 16)
						| ((uint32_t)(uint8_t)a_data[i*N+k+3] << 24);
			IP_Q7_MAC8_mWriteReg(IP_BASE, 0x20 + k, mot);
			sum_a += a_data[i*N+k] + a_data[i*N+k+1] + a_data[i*N+k+2] + a_data[i*N+k+3];
		}

		// 2) configuration
		IP_Q7_MAC8_mWriteReg(IP_BASE, 0x04, N / 8);
		IP_Q7_MAC8_mWriteReg(IP_BASE, 0x08, M);

		// 3) DMA : d'abord les résultats (S2MM), puis les poids (MM2S)
		Xil_DCacheInvalidateRange((UINTPTR)res_buf, M * 8);
		if(XAxiDma_SimpleTransfer(&dma, (UINTPTR)res_buf, M * 8, XAXIDMA_DEVICE_TO_DMA) != XST_SUCCESS) {
			LOG("ERREUR : transfer DEVISE_TO_DMA");
		}
		if(XAxiDma_SimpleTransfer(&dma, (UINTPTR)w_hw,    M * N, XAXIDMA_DMA_TO_DEVICE) != XST_SUCCESS) {
			LOG("ERREUR : transfer DMA_TI_DEVICE");
		}
		
		// 4) démarrage : 0 puis 1 pour créer un front montant
		IP_Q7_MAC8_mWriteReg(IP_BASE, 0x00, 0);
		IP_Q7_MAC8_mWriteReg(IP_BASE, 0x00, 1);

		// 5) attente de la fin des deux transferts
		uint32_t t = 0;
		while ((XAxiDma_Busy(&dma, XAXIDMA_DEVICE_TO_DMA) || XAxiDma_Busy(&dma, XAXIDMA_DMA_TO_DEVICE)) && ++t < 50000000) ;
		if (t >= 50000000) { LOG("ERREUR : dma busy\r\n"); }
		Xil_DCacheInvalidateRange((UINTPTR)res_buf, M * 8);
		
		for(j = 0; j < b->shape[0]; j++)
		{
			uint64_t r = res_buf[j];
			sum = (int32_t)(r & 0xFFFFFFFF);          // le produit scalaire (32 bits de poids faible)
			acc = (int32_t)(r >> 32);                 // Σw (32 bits de poids fort), pour la correction z_a

			if (z_a != 0) sum -= z_a * acc;
			if (z_b != 0) sum -= z_b * sum_a;
			if (z_a != 0 && z_b != 0) sum += N * z_a * z_b;
			if (c != 0) sum += c_data[j];

			result_data[i*M + j] = (int8_t)((sum >> output_shift) + (int16_t) z_result);
			/*
			sum = 0;
			for(k = 0; k < a->shape[1]; k++)
			{
				// uint32 += uint8 * uint8
				sum += (int32_t) a_data[i*a->shape[1] + k] * (int32_t) b_data[j*b->shape[1] + k];
			}
			// Add the zero point correction terms if zero point != 0
			if(z_a != 0){
				// a_2 = sum(q_{2,jk}) from j=1 to N
				acc = 0;
				for(k = 0; k < a->shape[1]; k++){
					acc += (int32_t) b_data[j*b->shape[1] + k];
				}
				sum -= z_a * acc;
			}
			if(z_b != 0){
				// a_1 = sum(q_{1,ij}) from j=1 to N
				acc = 0;
				for(k = 0; k < a->shape[1]; k++){
					acc += (int32_t) a_data[i*a->shape[1] + k];
				}
				sum -= z_b * acc;
			}
			if(z_a != 0 && z_b != 0){
				// N * Z_1 * Z_2
				sum += a->shape[1] * z_a * z_b;
			}
			if(c != 0){
				// Bias add
				sum += c_data[j];
			}

			result_data[i*b->shape[0] + j] = (int8_t)((sum >> output_shift) + (int16_t) z_result);*/
		}
	}
	return;
}