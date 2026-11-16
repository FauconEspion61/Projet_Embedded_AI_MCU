/* Port d'AIfES pour le Zynq : les messages d'AIfES partent sur l'UART de la
 * console (xil_printf). xil_printf ne gere pas %f : les floats sont affiches
 * en entier, multiplies par 1000. */
#include "aifes_config.h"
#include "xil_printf.h"

#ifdef AIDEBUG_ENABLE_PRINTING

int aifes_print(const char *string)                        { xil_printf("%s", string); return 0; }
int aifes_print_int(const char *format, int var)           { xil_printf(format, var); return 0; }
int aifes_print_uint(const char *format, unsigned int var) { xil_printf(format, var); return 0; }
int aifes_print_long_int(const char *format, long int var) { xil_printf(format, var); return 0; }
int aifes_print_float(const char *format, float var)       { (void)format; xil_printf("%d", (int)(var * 1000.0f)); return 0; }

int (*aiprint)(const char *string)                         = aifes_print;
int (*aiprint_int)(const char *format, int var)            = aifes_print_int;
int (*aiprint_uint)(const char *format, unsigned int var)  = aifes_print_uint;
int (*aiprint_long_int)(const char *format, long int var)  = aifes_print_long_int;
int (*aiprint_float)(const char *format, float var)        = aifes_print_float;

#endif
