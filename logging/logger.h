/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
#ifndef LOGGER_H
#define LOGGER_H

#ifndef PRINTF_BUFFER_SIZE
#define PRINTF_BUFFER_SIZE 255
#endif // PRINTF_BUFFER_SIZE

#define LOG_DEBUG4       0x0001
#define LOG_DEBUG3       0x0002
#define LOG_DEBUG2       0x0004
#define LOG_DEBUG1       0x0008
#define LOG_MASK_DEBUG   0x000F

#define LOG_INFO4        0x0010
#define LOG_INFO3        0x0020
#define LOG_INFO2        0x0040
#define LOG_INFO1        0x0080
#define LOG_MASK_INFO    0x00F0

#define LOG_WARN4        0x0100
#define LOG_WARN3        0x0200
#define LOG_WARN2        0x0400
#define LOG_WARN1        0x0800
#define LOG_MASK_WARN    0x0F00

#define LOG_ERR4         0x1000
#define LOG_ERR3         0x2000
#define LOG_ERR2         0x4000
#define LOG_ERR1         0x8000
#define LOG_MASK_ERR     0xF000

#define LOG_LEVEL_DEBUG  0xFFFF
#define LOG_LEVEL_INFO   0xFFF0
#define LOG_LEVEL_WARN   0xFF00
#define LOG_LEVEL_ERR    0xF000

#define LOG_LEVEL_ASSERT LOG_ERR4
#define LOG_LEVEL_NANOEVENT LOG_DEBUG4

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

	#ifdef _H_atmega128hardware_H
		#include <avr/pgmspace.h>
	#endif

	#include "__loggers.h"
#endif // BASE_LOG_LEVEL

#endif // LOGGER_H
