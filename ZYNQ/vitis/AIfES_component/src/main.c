/* AIfES Q7 sur le Cortex-A9 de la ZedBoard : inference d'images recues par l'UART.
 *
 * Protocole (le meme que sur le STM32, plus le temps d'inference) :
 *   PC -> carte : 0xAB                       demande de synchronisation
 *   carte -> PC : 0xCD 0x00                  acquittement
 *   puis, pour chaque image :
 *   PC -> carte : 784 float32 little-endian  (3136 octets), pretraites comme a l'entrainement : (pixel/255) - 0.5
 *   carte -> PC : 10 octets                  probabilite de chaque classe x 255 (tronquee)
 *                 4 octets                   temps d'inference en microsecondes, little-endian
 *
 * Si la carte ne recoit plus rien pendant 0,5 s, elle revient en attente de synchronisation.
 * Apres la synchronisation, elle n'ecrit plus de texte : tout octet inattendu casserait le flux binaire.
 */
#include <stdint.h>
#include "board_io.h"
#include "aifes_q7_fnn.h"      /* uniquement ici : ce header contient des definitions */

#define SYNC_BYTE        0xAB
#define ACK_BYTE         0xCD
#define IMAGE_BYTES      (INPUTS * sizeof(float))
#define IDLE_TIMEOUT_US  500000u

static float input_data[INPUTS];     /* 784 float32 = 3136 octets */
static float output_data[OUTPUTS];

/* Attend l'octet 0xAB du PC et lui repond 0xCD 0x00. */
static void wait_for_sync(void)
{
    for (;;) {
        if (uart_getc_timeout(UART_WAIT_FOREVER) != SYNC_BYTE)
            continue;
        /* Jeter les 0xAB envoyes en double pendant l'attente : le PC n'envoie rien d'autre
         * tant qu'il n'a pas recu notre acquittement. */
        while (uart_rx_pending())
            (void)uart_getc_timeout(0);
        uart_putc(ACK_BYTE);
        uart_putc(0x00);
        return;
    }
}

/* Recoit une image directement dans input_data (le float32 du PC est deja au format de la carte :
 * les deux sont little-endian). Renvoie 0 si OK, -1 si le delai d'inactivite est depasse. */
static int receive_image(void)
{
    uint8_t *dst = (uint8_t *)input_data;

    for (uint32_t i = 0; i < IMAGE_BYTES; i++) {
        int c = uart_getc_timeout(IDLE_TIMEOUT_US);
        if (c < 0)
            return -1;
        dst[i] = (uint8_t)c;
    }
    return 0;
}

static uint8_t probability_to_byte(float p)
{
    float v = p * 255.0f;

    if (v < 0.0f)   v = 0.0f;
    if (v > 255.0f) v = 255.0f;
    return (uint8_t)v;
}

static void send_result(uint32_t inference_us)
{
    for (int k = 0; k < OUTPUTS; k++)
        uart_putc(probability_to_byte(output_data[k]));
    for (int b = 0; b < 4; b++)
        uart_putc((uint8_t)(inference_us >> (8 * b)));
}

int main(void)
{
    LOG("\r\n=== AIfES Q7 sur Cortex-A9 ===\r\n");

    if (aifes_q7_fnn_create_model() != 0) {
        LOG("ERREUR : aifes_q7_fnn_create_model a echoue\r\n");
        return -1;
    }
    LOG("\r\nPret : en attente du PC sur l'UART (synchro 0xAB, 115200 bauds).\r\n");

    for (;;) {
        wait_for_sync();
        while (receive_image() == 0) {
            uint32_t t0 = time_now_us();
            aifes_q7_fnn_inference(input_data, output_data);
            send_result(time_now_us() - t0);
        }
        /* delai depasse : le PC est parti ou s'est desynchronise -> on se resynchronise */
    }
}
