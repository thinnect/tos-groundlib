/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module BootStdPrependixM( char MY_NAME[] )
{
	provides interface Boot;
	uses {
		interface Boot as SubBoot;
		interface StdControl;
	}
}
implementation
{
	#define __MODUUL__ "BSPp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_BootStdPrependixM & BASE_LOG_LEVEL )
	#include "log.h"

	event void SubBoot.booted()
	{
		error_t error = call StdControl.start();
		logger( error ? LOG_ERR3 : LOG_DEBUG2, "%s:prepst%d", MY_NAME, error );
		signal Boot.booted();
	}
}
