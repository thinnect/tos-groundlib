/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module Init2SplitControlM(char MY_NAME[])
{
	provides interface SplitControl;
	uses interface Init;
}
implementation
{
	#define __MODUUL__ "I2SC"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Init2SplitControlM & BASE_LOG_LEVEL )
	#include "log.h"

	task void start()
	{
		debug1("%s:startDone", MY_NAME);
		signal SplitControl.startDone( SUCCESS );
	}

	command error_t SplitControl.start()
	{
		error_t error = call Init.init();
		logger( error?LOG_ERR3:LOG_INFO3,"%s:init=%d", MY_NAME, error);
		if( !error )
			post start();
		return error;
	}

	task void stop()
	{
		debug1("%s:stopDone", MY_NAME);
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		info2("%s:stop", MY_NAME);
		post stop();
		return SUCCESS;
	}
}
