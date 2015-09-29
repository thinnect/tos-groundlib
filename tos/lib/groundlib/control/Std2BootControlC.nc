/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module Std2BootControlC(char MY_NAME[], char FIRST_NAME[])
{
	provides {
		interface StdControl;
		interface Boot;
	}
}
implementation
{

	#define __MODUUL__ "StBt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Std2BootControl & BASE_LOG_LEVEL )
	#include "log.h"

	command error_t StdControl.stop()
	{
		return FAIL;
	}

	command error_t StdControl.start()
	{
		logger(LOG_INFO2, "%s1:%s.boot", MY_NAME, FIRST_NAME);
		signal Boot.booted();
		return SUCCESS;
	}

}
