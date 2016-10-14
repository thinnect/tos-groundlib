/**
 * Simple module to use logging system for displaying some information right after boot.
 * @author Raido Pahtma
 * @license MIT
 */
module BootInfoP {
	uses {
		interface LocalIeeeEui64;
		interface Boot;
	}
}
implementation {

	#define __MODUUL__ "binfo"
	#define __LOG_LEVEL__ ( LOG_LEVEL_BootInfoP & BASE_LOG_LEVEL )
	#include "log.h"

	#ifndef DEFAULT_RADIO_CHANNEL
	#define DEFAULT_RADIO_CHANNEL 0
	#endif // DEFAULT_RADIO_CHANNEL

	event void Boot.booted()
	{
		#if __LOG_LEVEL__ & LOG_INFO1
			ieee_eui64_t guid = call LocalIeeeEui64.getId();
			infob1("TOS_NODE_ID %04X GUID", guid.data, sizeof(ieee_eui64_t), TOS_NODE_ID);
			info1("SW %u.%u.%u %08"PRIX32" %08"PRIX32, SW_MAJOR_VERSION, SW_MINOR_VERSION, SW_PATCH_VERSION, IDENT_TIMESTAMP, IDENT_UIDHASH);
			info1("RADIO_CHANNEL=%u TOSH_DATA_LENGTH=%u", DEFAULT_RADIO_CHANNEL, TOSH_DATA_LENGTH);
		#endif // __LOG_LEVEL__
	}

}
