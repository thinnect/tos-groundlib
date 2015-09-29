/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
generic module Boot2SplitControlC(char MY_NAME[], char FIRST_NAME[])
{
	uses {
		interface Boot;
		interface SplitControl;
	}
}
implementation
{

	#define __MODUUL__ "BtSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Boot2SplitControl & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted()
	{
		error_t error;
		logger(LOG_INFO2, "%s1.boot", MY_NAME);
		error = call SplitControl.start();
		logger(error?LOG_WARN2:LOG_INFO2, "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error);
		(void)error; // Suppress unused-but-set-variable
	}

	event void SplitControl.startDone(error_t error)
	{
		logger(error?LOG_WARN2:LOG_INFO2, "%s1:%s.startDone=%d", MY_NAME, FIRST_NAME, error);
	}

	event void SplitControl.stopDone(error_t error) { }
}
