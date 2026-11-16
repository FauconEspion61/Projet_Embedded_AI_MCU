/* Entrees/sorties de la carte : liaison serie binaire (en scrutation) et horloge.
 * Isole tout ce qui depend du Zynq, pour que main.c reste independant du materiel. */
#ifndef BOARD_IO_H
#define BOARD_IO_H

#include <stdint.h>
#include "xil_printf.h"

#define LOG xil_printf                 /* console texte, sur la meme UART (UART1) */
#define UART_WAIT_FOREVER 0xFFFFFFFFu

int      uart_getc_timeout(uint32_t timeout_us);   /* octet recu (0..255), ou -1 si le delai est ecoule */
int      uart_rx_pending(void);                     /* 1 s'il y a deja un octet a lire */
void     uart_putc(uint8_t byte);
uint32_t time_now_us(void);                         /* microsecondes, modulo 2^32 */

#endif
