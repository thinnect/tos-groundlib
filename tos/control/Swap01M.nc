/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module Swap01M( char MY_NAME[] )
{
	provides {
		interface Init;
		interface Swap;
		interface Swap01;
	}
}
implementation
{
	#define __MODUUL__ "SW01"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Swap01M & BASE_LOG_LEVEL )
	#include "log.h"

	uint8_t idxor = 0;

	command error_t Init.init()
	{
		info1("init");
		idxor = 0;
		return SUCCESS;
	}

	command void Swap.swap()
	{
		idxor ^= 1;
		info1("%s:idxor=%d", MY_NAME, idxor);
	}

	command uint8_t Swap01.id( uint8_t subid )
	{
		return (uint8_t)( subid ^ idxor );
	}
}
