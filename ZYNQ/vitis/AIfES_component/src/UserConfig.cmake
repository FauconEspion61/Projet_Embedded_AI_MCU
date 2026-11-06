# Copyright (C) 2023-2025 Advanced Micro Devices, Inc.  All rights reserved.
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.16)
enable_language(C ASM CXX)

###    USER SETTINGS  START    ###
# Below settings can be customized
# User needs to edit it manually as per their needs.
###    DO NOT ADD OR REMOVE VARIABLES FROM THIS SECTION    ###
# -----------------------------------------
# Add any compiler definitions, they will be added as extra definitions
# Example : Adding VERBOSE=1 will pass -DVERBOSE=1 to the compiler.
set(USER_COMPILE_DEFINITIONS
"AIDEBUG_ENABLE_PRINTING"
)

# Undefine any previously specified compiler definitions, either built in or provided with a -D option
# Example : Adding MY_SYMBOL will pass -UMY_SYMBOL to the compiler.
set(USER_UNDEFINED_SYMBOLS
"__clang__"
)


# Add any directories below, they will be added as extra include directories.
# Example 1: Adding /proj/data/include will pass -I/proj/data/include.
# Example 2: Adding ../../common/include will consider the path as relative to this component directory.
# Example 3: Adding ${CMAKE_SOURCE_DIR}/data/include to add data/include from this project.

set(USER_INCLUDE_DIRECTORIES
".."
)

#Add any source below, they will be added as Compile sources.
#Example 1: Adding /proj/data/helloworld.c will pass /proj/data/helloworld.c
#Example 2: Adding ../../common/helloworld.c will consider the path as relative to this component directory
#Example 3: Adding ${MY_ENV}/data/helloworld.c are expanded using project-specific environment settings.
set(USER_COMPILE_SOURCES
"board_io.c"
"main.c"
"../basic/avr_pgm/ailayer/ailayer_dense_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_elu_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_leaky_relu_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_relu_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_sigmoid_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_softmax_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_softsign_avr_pgm.c"
"../basic/avr_pgm/ailayer/ailayer_tanh_avr_pgm.c"
"../basic/avr_pgm/aimath/aimath_f32_avr_pgm.c"
"../basic/avr_pgm/aimath/aimath_q7_avr_pgm.c"
"../basic/base/aialgo/aialgo_sequential_inference.c"
"../basic/base/aialgo/aialgo_sequential_training.c"
"../basic/base/ailayer/ailayer_dense.c"
"../basic/base/ailayer/ailayer_elu.c"
"../basic/base/ailayer/ailayer_input.c"
"../basic/base/ailayer/ailayer_leaky_relu.c"
"../basic/base/ailayer/ailayer_relu.c"
"../basic/base/ailayer/ailayer_sigmoid.c"
"../basic/base/ailayer/ailayer_softmax.c"
"../basic/base/ailayer/ailayer_softsign.c"
"../basic/base/ailayer/ailayer_tanh.c"
"../basic/base/ailayer/ailayer_template.c"
"../basic/base/ailoss/ailoss_crossentropy.c"
"../basic/base/ailoss/ailoss_mse.c"
"../basic/base/aimath/aimath_basic.c"
"../basic/base/aimath/aimath_f32.c"
"../basic/base/aimath/aimath_q31.c"
"../basic/base/aimath/aimath_q7.c"
"../basic/base/aimath/aimath_u8.c"
"../basic/base/aiopti/aiopti_adam.c"
"../basic/base/aiopti/aiopti_sgd.c"
"../basic/cmsis/ailayer/ailayer_dense_cmsis.c"
"../basic/cmsis/aimath/aimath_f32_cmsis.c"
"../basic/cmsis/aimath/aimath_q31_cmsis.c"
"../basic/cmsis/aimath/aimath_q7_cmsis.c"
"../basic/default/ailayer/ailayer_dense_default.c"
"../basic/default/ailayer/ailayer_elu_default.c"
"../basic/default/ailayer/ailayer_input_default.c"
"../basic/default/ailayer/ailayer_leaky_relu_default.c"
"../basic/default/ailayer/ailayer_relu_default.c"
"../basic/default/ailayer/ailayer_sigmoid_default.c"
"../basic/default/ailayer/ailayer_softmax_default.c"
"../basic/default/ailayer/ailayer_softsign_default.c"
"../basic/default/ailayer/ailayer_tanh_default.c"
"../basic/default/ailoss/ailoss_crossentropy_default.c"
"../basic/default/ailoss/ailoss_mse_default.c"
"../basic/default/aimath/aimath_f32_default.c"
"../basic/default/aimath/aimath_q31_default.c"
"../basic/default/aimath/aimath_q7_default.c"
"../basic/default/aiopti/aiopti_adam_default.c"
"../basic/default/aiopti/aiopti_sgd_default.c"
"../basic/express/aifes_express_f32_fnn.c"
"../basic/express/aifes_express_q7_fnn.c"
"../cnn/base/ailayer/ailayer_batch_normalization.c"
"../cnn/base/ailayer/ailayer_conv2d.c"
"../cnn/base/ailayer/ailayer_maxpool2d.c"
"../cnn/base/ailayer/ailayer_reshape.c"
"../cnn/default/ailayer/ailayer_batch_normalization_default.c"
"../cnn/default/ailayer/ailayer_conv2d_default.c"
"../cnn/default/ailayer/ailayer_maxpool2d_default.c"
"../cnn/default/ailayer/ailayer_reshape_default.c"
"../cnn/default/aimath/aimath_cnn_f32_default.c"
)

# -----------------------------------------

# Turn on all optional warnings (-Wall)
set(USER_COMPILE_WARNINGS_ALL -Wall)

# Enable extra warning flags (-Wextra)
set(USER_COMPILE_WARNINGS_EXTRA -Wextra)

# Make all warnings into hard errors (-Werror)
set(USER_COMPILE_WARNINGS_AS_ERRORS )

# Check the code for syntax errors, but don't do anything beyond that (-fsyntax-only)
set(USER_COMPILE_WARNINGS_CHECK_SYNTAX_ONLY )

# Issue all the mandatory diagnostics listed in the C standard (-pedantic)
set(USER_COMPILE_WARNINGS_PEDANTIC )

# Issue all the mandatory diagnostics, and make all mandatory diagnostics into errors. (-pedantic-errors)
set(USER_COMPILE_WARNINGS_PEDANTIC_AS_ERRORS )

# Suppress all warnings (-w)
set(USER_COMPILE_WARNINGS_INHIBIT_ALL )

# -----------------------------------------

# Optimization level   "-O0" [None], "-O1" [Optimize] , "-O2" [Optimize More], "-O3" [Optimize Most] or "-Os" [Optimize Size]
set(USER_COMPILE_OPTIMIZATION_LEVEL "-O2")

# Other flags related to optimization
set(USER_COMPILE_OPTIMIZATION_OTHER_FLAGS )

# -----------------------------------------

# Debug level "" [None], "-g1" [Minimum], "g2" [Default], "g3" [Maximum]
set(USER_COMPILE_DEBUG_LEVEL -g3)

# Other flags related to debugging
set(USER_COMPILE_DEBUG_OTHER_FLAGS "")

# -----------------------------------------

# Enable profiling (-pg) (This feature is not supported currently)
# set(USER_COMPILE_PROFILING_ENABLE )

# -----------------------------------------

# Verbose (-v)
set(USER_COMPILE_VERBOSE )

# Support ANSI_PROGRAM (-ansi)
set(USER_COMPILE_ANSI )
set(USER_COMPILE_RELAXATION "-Wl,--no-relax")
set(USER_COMPILE_GARBAGE "")
# Add any compiler options that are not covered by the above variables, they will be added as extra compiler options
# To enable profiling -pg [ for gprof ]  or -p [ for prof information ]
set(USER_COMPILE_OTHER_FLAGS )

# -----------------------------------------

# Linker options
# Do not use the standard system startup files when linking.
# The standard system libraries are used normally, unless -nostdlib or -nodefaultlibs is used. (-nostartfiles)
set(USER_LINK_NO_START_FILES )

# Do not use the standard system libraries when linking. (-nodefaultlibs)
set(USER_LINK_NO_DEFAULT_LIBS )

# Do not use the standard system startup files or libraries when linking. (-nostdlib)
set(USER_LINK_NO_STDLIB )

# Omit all symbol information. (-s)
set(USER_LINK_OMIT_ALL_SYMBOL_INFO "")


# -----------------------------------------

# Add any libraries to be linked below, they will be added as extra libraries.
# User needs to update USER_LINK_DIRECTORIES below with these library search paths.
set(USER_LINK_LIBRARIES
"m"
)

# Add any directories to look for the libraries to be linked.
# Example 1: Adding /proj/compression/lib will pass -L/proj/compression/lib to the linker.
# Example 2: Adding ../../common/lib will consider the path as relative to this directory and will pass the path to -L option.
set(USER_LINK_DIRECTORIES
)

# -----------------------------------------

set(USER_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/lscript.ld")

# Add linker options to be passed, they will be added as extra linker options
# Example : Adding -s will pass -s to the linker.
set(USER_LINK_OTHER_FLAGS
)

# -----------------------------------------

###   END OF USER SETTINGS SECTION ###
###   DO NOT EDIT BEYOND THIS LINE ###

set(USER_COMPILE_OPTIONS
    " ${USER_COMPILE_WARNINGS_ALL}"
    " ${USER_COMPILE_WARNINGS_EXTRA}"
    " ${USER_COMPILE_WARNINGS_AS_ERRORS}"
    " ${USER_COMPILE_WARNINGS_CHECK_SYNTAX_ONLY}"
    " ${USER_COMPILE_WARNINGS_PEDANTIC}"
    " ${USER_COMPILE_WARNINGS_PEDANTIC_AS_ERRORS}"
    " ${USER_COMPILE_WARNINGS_INHIBIT_ALL}"
    " ${USER_COMPILE_OPTIMIZATION_LEVEL}"
    " ${USER_COMPILE_OPTIMIZATION_OTHER_FLAGS}"
    " ${USER_COMPILE_DEBUG_LEVEL}"
    " ${USER_COMPILE_DEBUG_OTHER_FLAGS}"
    " ${USER_COMPILE_VERBOSE}"
    " ${USER_COMPILE_ANSI}"
    " ${USER_COMPILE_OTHER_FLAGS}"
)
foreach(entry ${USER_UNDEFINED_SYMBOLS})
    list(APPEND USER_COMPILE_OPTIONS " -U${entry}")
endforeach()

# Process USER_LINK_DIRECTORIES to generate proper -L flags
if(USER_LINK_DIRECTORIES)
    # Convert list to string with proper -L flag formatting
    string(REPLACE ";" "\" -L\"" _formatted_dirs "${USER_LINK_DIRECTORIES}")
    set(USER_LINK_DIRECTORIES "${_formatted_dirs}")
endif()

set(USER_LINK_OPTIONS
    " ${USER_LINKER_NO_START_FILES}"
    " ${USER_LINKER_NO_DEFAULT_LIBS}"
    " ${USER_LINKER_NO_STDLIB}"
    " ${USER_LINKER_OMIT_ALL_SYMBOL_INFO}"
    " ${USER_LINK_OTHER_FLAGS}"
)
if(("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "microblaze") OR ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "microblaze_riscv"))
	if(USER_COMPILE_RELAXATION)
		string(FIND "${CMAKE_C_LINK_FLAGS}" "-Wl,--no-relax" POSITION)
		if(POSITION EQUAL -1)
		    set(CMAKE_C_LINK_FLAGS "  -Wl,--no-relax ${CMAKE_C_LINK_FLAGS}" CACHE STRING "CMAKE C LINK FLAGS" FORCE)
		    set(CMAKE_ASM_LINK_FLAGS "  -Wl,--no-relax ${CMAKE_ASM_LINK_FLAGS}" CACHE STRING "CMAKE ASM LINK FLAGS" FORCE)
		    set(CMAKE_CXX_LINK_FLAGS "  -Wl,--no-relax ${CMAKE_CXX_LINK_FLAGS}" CACHE STRING "CMAKE CXX LINK FLAGS" FORCE)
		endif()
	else()
		string(REPLACE "-Wl,--no-relax" "" CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS}")
		string(REPLACE "-Wl,--no-relax" "" CMAKE_ASM_LINK_FLAGS "${CMAKE_ASM_LINK_FLAGS}")
		string(REPLACE "-Wl,--no-relax" "" CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS}")
	endif()
	if(USER_COMPILE_GARBAGE)
		string(FIND "${CMAKE_C_FLAGS}" "-ffunction-sections -fdata-sections" POSITION)
		if(POSITION EQUAL -1)
		    set(CMAKE_C_FLAGS " -ffunction-sections -fdata-sections ${CMAKE_C_FLAGS}" CACHE STRING "CMAKE C FLAGS" FORCE)
		    set(CMAKE_CXX_FLAGS " -ffunction-sections -fdata-sections ${CMAKE_CXX_FLAGS}" CACHE STRING "CMAKE CXX FLAGS" FORCE)
		    set(CMAKE_ASM_FLAGS " -ffunction-sections -fdata-sections ${CMAKE_ASM_FLAGS}" CACHE STRING "CMAKE ASM FLAGS" FORCE)
		endif()
	else()
		string(REPLACE "-ffunction-sections -fdata-sections" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
		string(REPLACE "-ffunction-sections -fdata-sections" "" CMAKE_CXX_FLAGS "${CMAKE_ASM_FLAGS}")
		string(REPLACE "-ffunction-sections -fdata-sections" "" CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS}")
	endif()
endif()
