/**
 * Composes SplitControl and StdControl
 * starts SplitControl before StdControl and stops after
 *
 * @author Andrei Lunjov
 * @license MIT
 */
generic module SplitStdControlC( char MY_NAME[], char FIRST_NAME[], char SECOND_NAME[] )
{
	provides interface SplitControl;

	uses {
		interface SplitControl as First;
		interface StdControl as Second;
	}
}
implementation
{
	#define __MODUUL__ "SpSt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SplitStdControl & BASE_LOG_LEVEL )
	#include "log.h"

	task void startDone()
	{
		signal SplitControl.startDone( SUCCESS );
	}

	command error_t SplitControl.start()
	{
		error_t error = call First.start();
		logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error );

		if( error == EALREADY ) {
			error = call Second.start();
			logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
			if( !error )
				post startDone();
		}

		return error;
	}

	event void First.startDone( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.startDone=%d", MY_NAME, FIRST_NAME, error );
		if( error==SUCCESS || error==EALREADY ) {
			error = call Second.start();
			logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
		}
		signal SplitControl.startDone( error );
	}

	task void stopDone()
	{
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		error_t error = call Second.stop();
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.stop=%d", MY_NAME, SECOND_NAME, error );

		if( error == SUCCESS ) {
			error = call First.stop();
			logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stop=%d", MY_NAME, FIRST_NAME, error );
			if( error == EALREADY ) {
				post stopDone();
				error = SUCCESS;
			}
		}

		return error;
	}

	event void First.stopDone(error_t error)
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stopDone=%d", MY_NAME, FIRST_NAME, error );
		signal SplitControl.stopDone( error );
	}
}
