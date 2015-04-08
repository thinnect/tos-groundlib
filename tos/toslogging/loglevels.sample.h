#ifndef LOGLEVELS_H
#define LOGLEVELS_H

#include "logger.h"

#define LOG_LEVEL_debug           LOG_LEVEL_DEBUG
#define LOG_LEVEL_info            LOG_LEVEL_INFO
#define LOG_LEVEL_test_warn       LOG_LEVEL_WARN
#define LOG_LEVEL_test_err        LOG_LEVEL_ERR
#define LOG_LEVEL_disabled        0
#define LOG_LEVEL_example         (LOG_DEBUG1 + LOG_INFO2 + LOG_WARN3 + LOG_ERR4)

#endif
