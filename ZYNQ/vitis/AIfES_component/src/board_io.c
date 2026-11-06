#include "board_io.h"
#include "xparameters.h"
#include "xuartps_hw.h"
#include "xiltimer.h"          /* XTime, XTime_GetTime (BSP en flot SDT) */
#include "xtimer_config.h"     /* COUNTS_PER_SECOND */

/* UART1 (MIO 48-49) : c'est aussi celle de xil_printf, donc le port USB-UART de la ZedBoard. */
#define UART_BASE XPAR_XUARTPS_0_BASEADDR

uint32_t time_now_us(void)
{
    XTime t;
    XTime_GetTime(&t);
    return (uint32_t)((t * 1000000ULL) / COUNTS_PER_SECOND);
}

int uart_rx_pending(void)
{
    return XUartPs_IsReceiveData(UART_BASE) ? 1 : 0;
}

int uart_getc_timeout(uint32_t timeout_us)
{
    uint32_t start = time_now_us();

    while (!XUartPs_IsReceiveData(UART_BASE)) {
        if (timeout_us != UART_WAIT_FOREVER && (uint32_t)(time_now_us() - start) >= timeout_us)
            return -1;
    }
    return (int)XUartPs_RecvByte(UART_BASE);
}

void uart_putc(uint8_t byte)
{
    XUartPs_SendByte(UART_BASE, byte);
}
