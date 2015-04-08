/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module InvertedSplitControlM( char MY_NAME[] )
{
	provides interface SplitControl as InvertedSplitControl;
	uses interface SplitControl;
}
implementation
{
	#define __MODUUL__ "IvSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_InvertedSplitControlM & BASE_LOG_LEVEL )
	#include "log.h"

	command error_t InvertedSplitControl.start()
	{
		error_t error = call SplitControl.stop();
		logger( error?LOG_WARN2:LOG_INFO2, "%s:stop=%d",MY_NAME,error);
		return error;
	}

	command error_t InvertedSplitControl.stop()
	{
		error_t error = call SplitControl.start();
		logger( error?LOG_WARN2:LOG_INFO2, "%s:start=%d",MY_NAME,error);
		return error;
	}

	event void SplitControl.startDone(error_t error)
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s:startDone=%d",MY_NAME,error);
		signal InvertedSplitControl.stopDone( error );
	}

	event void SplitControl.stopDone(error_t error)
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s:stopDone=%d",MY_NAME,error);
		signal InvertedSplitControl.startDone( error );
	}
}
