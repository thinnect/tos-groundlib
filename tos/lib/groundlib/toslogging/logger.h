/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
#ifndef LOGGER_H
#define LOGGER_H

#ifndef PRINTF_BUFFER_SIZE
#define PRINTF_BUFFER_SIZE 255
#endif // PRINTF_BUFFER_SIZE

#include "loglevels.h"

#if !defined(TOSSIM_ENABLE_NANOMSG_DEBUG_CHANNEL)
	#define nanodbg(s, ...)
#endif

#ifndef BASE_LOG_LEVEL
	#ifdef DEBUG_ON
		#define INFO_ON
		#define BASE_LOG_LEVEL LOG_LEVEL_DEBUG
	#elif defined(INFO_ON)
		#define WARN_ON
		#ifndef BASE_LOG_LEVEL
			#define BASE_LOG_LEVEL LOG_LEVEL_INFO
		#endif
	#elif defined(WARN_ON)
		#define ERR_ON
		#ifndef BASE_LOG_LEVEL
			#define BASE_LOG_LEVEL LOG_LEVEL_WARN
		#endif
	#elif defined(ERR_ON)
		#define BASE_LOG_LEVEL LOG_LEVEL_ERR
	#else
		#define BASE_LOG_LEVEL 0
	#endif
#endif // BASE_LOG_LEVEL

#if BASE_LOG_LEVEL
	#define LOGGER_ON

	#ifndef PRINTF_PORT
		#define PRINTF_PORT 0
	#endif

	#ifndef TOSSIM
		#include "__loggers.h"
	#else
		#include "__loggers_sim.h"
	#endif
#endif // BASE_LOG_LEVEL

#endif // LOGGER_H
