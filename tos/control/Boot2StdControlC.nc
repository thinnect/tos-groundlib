/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
generic module Boot2StdControlC(char MY_NAME[], char FIRST_NAME[])
{
	uses {
		interface Boot;
		interface StdControl;
	}
}
implementation
{

	#define __MODUUL__ "BtSt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Boot2StdControl & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted()
	{
		error_t error;
		logger(LOG_INFO2, "%s1.boot", MY_NAME);
		error = call StdControl.start();
		logger(error?LOG_WARN2:LOG_INFO2, "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error);
		(void)error; // Suppress unused-but-set-variable
	}

}
