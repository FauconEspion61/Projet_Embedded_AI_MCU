/**
  ******************************************************************************
  * @file    mlp_mnist_projet_data_params.h
  * @author  AST Embedded Analytics Research Platform
  * @date    2026-10-09T10:04:06+0200
  * @brief   AI Tool Automatic Code Generator for Embedded NN computing
  ******************************************************************************
  * Copyright (c) 2026 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  ******************************************************************************
  */

#ifndef MLP_MNIST_PROJET_DATA_PARAMS_H
#define MLP_MNIST_PROJET_DATA_PARAMS_H

#include "ai_platform.h"

/*
#define AI_MLP_MNIST_PROJET_DATA_WEIGHTS_PARAMS \
  (AI_HANDLE_PTR(&ai_mlp_mnist_projet_data_weights_params[1]))
*/

#define AI_MLP_MNIST_PROJET_DATA_CONFIG               (NULL)


#define AI_MLP_MNIST_PROJET_DATA_ACTIVATIONS_SIZES \
  { 5184, }
#define AI_MLP_MNIST_PROJET_DATA_ACTIVATIONS_SIZE     (5184)
#define AI_MLP_MNIST_PROJET_DATA_ACTIVATIONS_COUNT    (1)
#define AI_MLP_MNIST_PROJET_DATA_ACTIVATION_1_SIZE    (5184)



#define AI_MLP_MNIST_PROJET_DATA_WEIGHTS_SIZES \
  { 322024, }
#define AI_MLP_MNIST_PROJET_DATA_WEIGHTS_SIZE         (322024)
#define AI_MLP_MNIST_PROJET_DATA_WEIGHTS_COUNT        (1)
#define AI_MLP_MNIST_PROJET_DATA_WEIGHT_1_SIZE        (322024)



#define AI_MLP_MNIST_PROJET_DATA_ACTIVATIONS_TABLE_GET() \
  (&g_mlp_mnist_projet_activations_table[1])

extern ai_handle g_mlp_mnist_projet_activations_table[1 + 2];



#define AI_MLP_MNIST_PROJET_DATA_WEIGHTS_TABLE_GET() \
  (&g_mlp_mnist_projet_weights_table[1])

extern ai_handle g_mlp_mnist_projet_weights_table[1 + 2];


#endif    /* MLP_MNIST_PROJET_DATA_PARAMS_H */
