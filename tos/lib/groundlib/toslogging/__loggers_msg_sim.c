/**
 * @author Raido Pahtma, Madis Uusjärv
 * @license MIT
*/

#include "log.h"

#include <message.h>

void __logmsg( message_t* msg )
{
	__logmem( msg, TOSH_DATA_LENGTH );
}

void __vloggerm( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, message_t* msg, va_list a )
{
	char timestr[80];
	__getTimestamp(timestr, sizeof(timestr));

	dbg(DBG_CHANNEL_NAME, "%s #%04X %c|%13s:%4d|__vloggerm\n", timestr, TOS_NODE_ID, sev(severity), module_name(moduul), __line__);
}

void __loggerm( uint16_t severity, PGM_P moduul, uint16_t __line__, PGM_P str, message_t* msg, ... )
{
	char timestr[80];
	__getTimestamp(timestr, sizeof(timestr));

	dbg(DBG_CHANNEL_NAME, "%s #%04X %c|%13s:%4d|__loggerm\n", timestr, TOS_NODE_ID, sev(severity), module_name(moduul), __line__);
}
