/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module SeqStdControlM( char MY_NAME[], char FIRST_NAME[], char SECOND_NAME[] )
{
	provides interface StdControl;

	uses {
		interface StdControl as First;
		interface StdControl as Second;
	}
}
implementation
{
	#define __MODUUL__ "StSt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SeqStdControlM & BASE_LOG_LEVEL )
	#include "log.h"

	command error_t StdControl.start()
	{
		error_t error = call First.start();
		debug( "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error );

		if( !error ) {
			error = call Second.start();
			debug( "%s2:%s.start=%d", MY_NAME, SECOND_NAME, error );
		}

		return error;
	}

	command error_t StdControl.stop()
	{
		error_t error = call Second.stop();
		debug( "%s2:%s.stop=%d", MY_NAME, SECOND_NAME, error );

		if( !error ) {
			error = call First.stop();
			debug( "%s1:%s.start=%d", MY_NAME, FIRST_NAME, error );
		}

		return error;
	}
}
