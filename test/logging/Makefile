COMPONENT=LoggingTestC

CFLAGS += -I$(PWD)

PLATFORM_BAUDRATE ?= 500000UL
BASE_LOG_LEVEL ?= 0xFFFF

include ../../tos/groundlib.mk

# Avoid strange TinyOS issues
CFLAGS += -DTASKLET_IS_TASK

include $(MAKERULES)
