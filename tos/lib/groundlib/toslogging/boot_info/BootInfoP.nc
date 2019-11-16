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

	event void Boot.booted() {
		info1("TOS_NODE_ID %04X", TOS_NODE_ID);
		#if __LOG_LEVEL__ & LOG_INFO2
		{
			ieee_eui64_t guid = call LocalIeeeEui64.getId();
			infob2("EUI", guid.data, sizeof(ieee_eui64_t));
		}
		#endif // __LOG_LEVEL__
		info3("SW %u.%u.%u%s %08"PRIX32" %08"PRIX32,
		      SW_MAJOR_VERSION, SW_MINOR_VERSION, SW_PATCH_VERSION, SW_DEV_VERSION,
		      IDENT_TIMESTAMP, IDENT_UIDHASH);
		info4("RADIO_CHANNEL=%u TOSH_DATA_LENGTH=%u", DEFAULT_RADIO_CHANNEL, TOSH_DATA_LENGTH);
	}

}
