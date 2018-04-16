/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
#ifndef __LOGGERS_H
#define __LOGGERS_H

#ifndef MODULE_NAME_LENGTH
#define MODULE_NAME_LENGTH 12
#endif // MODULE_NAME_LENGTH

#define LOG_MASK_DEBUG   0x000F
#define LOG_MASK_INFO    0x00F0
#define LOG_MASK_WARN    0x0F00
#define LOG_MASK_ERR     0xF000

#include <stdio.h>

#ifdef __AVR__
#include <avr/pgmspace.h>
#endif

int printfflush();
uint32_t _getLocalTimeRadio();

void putsr( PGM_P str, uint8_t len );

void __loghead( uint16_t severity, PGM_P _file_, unsigned _line_ );

void __logmem( void* _data, uint8_t len );

void __vloggernnl( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P format, va_list a );
void __loggernnl( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P format, ... );
void __vlogger( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P format, va_list a );
void __logger( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P format, ... );
void __nanologger(PGM_P format, ... );
void __vloggerb( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, void* data, uint8_t len, va_list a);
void __loggerb( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, void* data, uint8_t len, ...);
void __loggerb2( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str1, void* data1, uint8_t len1, PGM_P str2, void* data2, uint8_t len2, ...);

#endif // __LOGGERS_H
