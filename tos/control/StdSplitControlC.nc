/**
 * Composes StdControl and SplitControl
 * starts StdControl before SplitControl and stops after
 *
 * @author Andrei Lunjov
 * @license MIT
 */
generic module StdSplitControlC( const char MY_NAME[], const char FIRST_NAME[], char SECOND_NAME[] )
{
	provides interface SplitControl;

	uses {
		interface StdControl as First;
		interface SplitControl as Second;
	}
}
implementation
{
	#define __MODUUL__ "StSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_StdSplitControl & BASE_LOG_LEVEL )
	#include "log.h"

	task void startDone()
	{
		signal SplitControl.startDone( SUCCESS );
	}

	command error_t SplitControl.start()
	{
		error_t error = call First.start();
		logger( error ? LOG_WARN2 : LOG_INFO2, "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error );
		if( error )
			return error;

		error = call Second.start();
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
		if( error == EALREADY ) {
			error = SUCCESS;
			post startDone();
		}
		return error;
	}

	event void Second.startDone( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2,"%s2:%s.startDone=%d", MY_NAME, SECOND_NAME, error );
		signal SplitControl.startDone( error==EALREADY ? SUCCESS : error );
	}

	task void stopDone()
	{
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		error_t error = call Second.stop();
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.stop=%d", MY_NAME, SECOND_NAME, error );

		if( error == EALREADY ) {
			error = call First.stop();
			logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stop=%d", MY_NAME, FIRST_NAME, error );
			if( !error )
				post stopDone();
		}

		return error;
	}

	event void Second.stopDone(error_t error)
	{
		debug( "%s2:%s.stopDone=%d", MY_NAME, SECOND_NAME, error );

		if( error==SUCCESS || error==EALREADY ) {
			error = call First.stop();
			debug( "%s1:%s.stop=%d", MY_NAME, FIRST_NAME, error );
		}

		signal SplitControl.stopDone( error );
	}
}
