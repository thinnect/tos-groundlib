/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module SeqSplitControlC( char MY_NAME[], char FIRST_NAME[], char SECOND_NAME[] )
{
	provides interface SplitControl;

	uses {
		interface SplitControl as First;
		interface SplitControl as Second;
	}
}
implementation
{
	#define __MODUUL__ "SpSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SeqSplitControl & BASE_LOG_LEVEL )
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
			// error = SUCCESS;
			error = call Second.start();

			debug3( "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
		}

		return error;
	}

	event void First.startDone( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.startDone=%d", MY_NAME, FIRST_NAME, error );

		if( error==SUCCESS || error==EALREADY ) {
			error = call Second.start();
			// error = SUCCESS;
			logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
			switch( error ) {
				case SUCCESS:
					return;
				case EALREADY:
					error = SUCCESS;
			}
		}

		signal SplitControl.startDone( error );
	}

	event void Second.startDone( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.startDone=%d", MY_NAME, SECOND_NAME, error );
		signal SplitControl.startDone( error==EALREADY ? SUCCESS : error );
	}

	task void stopDone()
	{
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		error_t error;// = call Second.stop();
		error = EALREADY;
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.stop=%d", MY_NAME, SECOND_NAME, error );

		if( error == EALREADY ) {
			error = call First.stop();
			logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stop=%d", MY_NAME, FIRST_NAME, error );
		}

		return error;
	}

	event void Second.stopDone(error_t error)
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s2:%s.stopDone=%d", MY_NAME, SECOND_NAME, error );

		if( error==SUCCESS || error==EALREADY ) {
			error = call First.stop();
			logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stopDone=%d", MY_NAME, FIRST_NAME, error );
			switch( error ) {
			case SUCCESS:
				return;
			case EALREADY:
				error = SUCCESS;
			}
		}

		signal SplitControl.stopDone( error );
	}

	event void First.stopDone(error_t error)
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s1:%s.stopDone=%d", MY_NAME, FIRST_NAME, error );
		signal SplitControl.stopDone( error==EALREADY ? SUCCESS : error );
	}
}
