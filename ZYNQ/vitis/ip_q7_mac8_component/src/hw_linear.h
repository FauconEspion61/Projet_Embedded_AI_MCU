#ifndef HW_LINEAR_H
#define HW_LINEAR_H

#include <stdint.h>
#include <math.h>
#include <stdlib.h>

#include "../basic/base/aimath/aimath_q7.h"
#include "../basic/base/aimath/aimath_q31.h" 

void hw_linear32_bt(const aitensor_t *a, const aitensor_t *b, const aitensor_t *c, aitensor_t *result);
int hw_linear_init(void);

#endif