/*
 * aifes_app.c
 *
 *  Created on: 9 oct. 2026
 *      Author: foltz
 */


#include "main.h"
#include <stdint.h>
#include <stdlib.h>
#include "aifes_q7_fnn.h"      /* UNIQUEMENT dans ce fichier : le header contient des definitions */

extern UART_HandleTypeDef huart2;

#define SYNC_BYTE  0xAB
#define ACK_BYTE   0xCD
#define TX_TIMEOUT 1000

static float input_data[INPUTS];     /* 784 floats = 3136 octets */
static float output_data[OUTPUTS];   /* 10 probabilites */

void AIfES_Init(void)
{
  if (aifes_q7_fnn_create_model() != 0)
  {
    Error_Handler();
  }
}

static void AIfES_Synchronize(void)
{
  uint8_t rx = 0;
  uint8_t ack[2] = {ACK_BYTE, 0};

  while (rx != SYNC_BYTE)
  {
    HAL_UART_Receive(&huart2, &rx, 1, HAL_MAX_DELAY);
  }
  HAL_UART_Transmit(&huart2, ack, sizeof(ack), TX_TIMEOUT);
}

void AIfES_Process(void)
{
  uint8_t result[OUTPUTS];

  AIfES_Synchronize();

  for (;;)
  {
    if (HAL_UART_Receive(&huart2, (uint8_t *)input_data, sizeof(input_data), HAL_MAX_DELAY) != HAL_OK)
    {
      continue;
    }

    aifes_q7_fnn_inference(input_data, output_data);

    for (int i = 0; i < OUTPUTS; i++)
    {
      result[i] = (uint8_t)(output_data[i] * 255.0f);
    }
    HAL_UART_Transmit(&huart2, result, sizeof(result), TX_TIMEOUT);
  }
}
