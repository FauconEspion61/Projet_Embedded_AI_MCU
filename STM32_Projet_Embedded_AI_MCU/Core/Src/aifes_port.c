/* Core/Src/aifes_port.c
 * Fonctions d'affichage exigees par AIfES (cf. aifes_config.h).
 * Volontairement vides : USART2 transporte le protocole binaire vers le PC
 * (synchro 0xAB/0xCD, floats en entree, octets en sortie). Du texte sur cette
 * liaison le corromprait. */
#include "aifes_config.h"

#ifdef AIDEBUG_ENABLE_PRINTING

int aifes_print(const char *string)                         { (void)string; return 0; }
int aifes_print_int(const char *format, int var)            { (void)format; (void)var; return 0; }
int aifes_print_uint(const char *format, unsigned int var)  { (void)format; (void)var; return 0; }
int aifes_print_long_int(const char *format, long int var)  { (void)format; (void)var; return 0; }
int aifes_print_float(const char *format, float var)        { (void)format; (void)var; return 0; }

int (*aiprint)(const char *string)                          = aifes_print;
int (*aiprint_int)(const char *format, int var)             = aifes_print_int;
int (*aiprint_uint)(const char *format, unsigned int var)   = aifes_print_uint;
int (*aiprint_long_int)(const char *format, long int var)   = aifes_print_long_int;
int (*aiprint_float)(const char *format, float var)         = aifes_print_float;

#endif
