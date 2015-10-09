/**
 * Log MCUSR on AVR platforms that do PLATFORM_MCUSR = MCUSR in bootstrap.
 * @author Raido Pahtma
 * @license MIT
 */
#include "platform.h"
module MCUSRInfoP {
	uses interface Boot;
}
implementation {

	#define __MODUUL__ "mcusr"
	#define __LOG_LEVEL__ ( LOG_LEVEL_MCUSRInfoP & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted()
	{
		info1("MCUSR %02X |%s|%s|%s|%s|%s|", PLATFORM_MCUSR,
			(1<<4)&PLATFORM_MCUSR?"J":" ",
			(1<<3)&PLATFORM_MCUSR?"W":" ",
			(1<<2)&PLATFORM_MCUSR?"B":" ",
			(1<<1)&PLATFORM_MCUSR?"E":" ",
			(1<<0)&PLATFORM_MCUSR?"P":" ");
	}

}
