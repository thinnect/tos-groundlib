/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module AggregateSplitControlM( uint8_t NUM_VICTIMS, char MY_NAME[] )
{
	provides interface SplitControl;
	uses interface SplitControl as Victim[ uint8_t victim ];
}
implementation
{
	#define __MODUUL__ "AgSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_AggregateSplitControlM & BASE_LOG_LEVEL )
	#include "log.h"

	task void startDone()
	{
		signal SplitControl.startDone( SUCCESS );
	}

	error_t start( uint8_t victim )
	{
		error_t error = EALREADY;
		while( victim<NUM_VICTIMS && error==EALREADY ) {
			error = call Victim.start[ victim ]();
			logger( error?LOG_WARN2:LOG_INFO2, "%s[%d].start=%d", MY_NAME, victim, error );
			++ victim;
		}
		return error;
	}

	command error_t SplitControl.start()
	{
		error_t error = start( 0 );
		if( error == EALREADY ){
			post startDone();
			error = SUCCESS;
		}
		return error;
	}

	event void Victim.startDone[ uint8_t victim ]( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s[%d].startDone=%d", MY_NAME, victim, error );

		if( error==SUCCESS || error==EALREADY ) {
			error = start( victim );
			if( !error )
				return;
			if( error == EALREADY )
				error = SUCCESS;
		}

		signal SplitControl.startDone( error );
	}


	error_t stop( uint8_t victim )
	{
		error_t error = EALREADY;
		while( victim-- && error==EALREADY ) {
			error = call Victim.stop[ victim ]();
			logger( error?LOG_WARN2:LOG_INFO2, "%s[%d].stop=%d", MY_NAME, victim, error );
		}
		return error;
	}

	task void stopDone()
	{
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		error_t error = stop( NUM_VICTIMS );
		if( error == EALREADY ){
			post stopDone();
			error = SUCCESS;
		}
		return error;
	}

	event void Victim.stopDone[ uint8_t victim ]( error_t error )
	{
		logger( error?LOG_WARN2:LOG_INFO2, "%s[%d].stopDone=%d", MY_NAME, victim, error );

		if( error==SUCCESS || error==EALREADY ) {
			error = stop( victim );
			if( !error )
				return;
			if( error == EALREADY )
				error = SUCCESS;
		}

		signal SplitControl.stopDone( error );
	}
}
