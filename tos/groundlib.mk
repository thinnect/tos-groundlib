#
# Makefile extension to include all the stuff in this repository.
# @author Raido Pahtma
# @license MIT
#

THIS_GROUNDLIB_DIR := $(realpath $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

# --------------------------------------------------------------------
#            This directory with header files
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)

# --------------------------------------------------------------------
#            Blinky
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/blinky

# --------------------------------------------------------------------
#            Std, split and boot control modules
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/control

# --------------------------------------------------------------------
#            Address initialization modules
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/boot

# --------------------------------------------------------------------
#            MemChunk
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/memchunk

# --------------------------------------------------------------------
#            Global message_t pool
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/globalpool

# --------------------------------------------------------------------
#            Logging over Serial
# --------------------------------------------------------------------
CFLAGS += -I$(THIS_GROUNDLIB_DIR)/toslogging

BASE_LOG_LEVEL ?= 0
ifneq ($(BASE_LOG_LEVEL),0)
    CFLAGS += -DBASE_LOG_LEVEL=$(BASE_LOG_LEVEL)
endif

ifndef PRINTF_PORT
    ifneq ($(BASE_LOG_LEVEL),0)
        PRINTF_PORT = 0
    endif
endif

ifdef PRINTF_PORT
    CFLAGS += -DPRINTF_PORT=$(PRINTF_PORT)
    CFLAGS += -I$(THIS_GROUNDLIB_DIR)/toslogging/uart_printf
else
    CFLAGS += -DBASE_LOG_LEVEL=0x0000
endif

MODULE_NAME_LENGTH ?= 4
ifdef MODULE_NAME_LENGTH
    CFLAGS += -DMODULE_NAME_LENGTH=$(MODULE_NAME_LENGTH)
endif

PRINTF_BUFFER_SIZE ?= 255
ifdef PRINTF_BUFFER_SIZE
    PFLAGS += -DPRINTF_BUFFER_SIZE=$(PRINTF_BUFFER_SIZE)
endif

# --------------------------------------------------------------------
#            ...
# --------------------------------------------------------------------
