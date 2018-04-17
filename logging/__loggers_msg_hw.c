#ifndef LOGGERS_MSG_H
#define LOGGERS_MSG_H

#include "message.h"

void __vloggerm( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, message_t* msg, va_list a )
{
#if !defined(TFRAMES_ENABLED) && !defined(IEEE154FRAMES_ENABLED) && defined(PLATFORM_IRIS)
	static const char headerFormat[] PROGMEM = "AM[%2X] %-4X>%-4X len=%3d fcf=%d dsn=%d destpan=%d group=%-2X";
	rf230packet_header_t* h = (rf230packet_header_t*) msg;

	__vlogger( severity, moduul, __line__, str, a );

	__logger( severity,
	          moduul,
	          __line__,
	          headerFormat,
	          h->am.type,
	          h->ieee154.src,
	          h->ieee154.dest,
	          h->rf230.length,
	          h->ieee154.fcf,
	          h->ieee154.dsn,
	          h->ieee154.destpan,
	          h->network.network
	);

	__loghead( severity, moduul, __line__ );
	__logmem( msg->data, TOSH_DATA_LENGTH );
#else
	__loghead( severity, moduul, __line__ );
	vfprintf_P( stdout, str, a );
	__logmem( msg, sizeof(message_t) );
#endif

	putchar('\n');
	printfflush();
}

void __loggerm( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, message_t* msg, ... )
{
	va_list a;

	va_start( a, msg );
	__vloggerm( severity, moduul, __line__, str, msg, a );
	va_end( a );
}

#endif // LOGGERS_MSG_H
