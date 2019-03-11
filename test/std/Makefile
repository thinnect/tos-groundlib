
WORKSPACE_ROOT ?= ../..

CFLAGS += -I.
CFLAGS += -DBASE_LOG_LEVEL=0xFFFF

CFLAGS += -I$(WORKSPACE_ROOT)/logging
SOURCEFILES += $(WORKSPACE_ROOT)/logging/loggers_std.c

all:
	gcc -std=gnu99 $(CFLAGS) $(SOURCEFILES) std_test_main.c -o std-test
