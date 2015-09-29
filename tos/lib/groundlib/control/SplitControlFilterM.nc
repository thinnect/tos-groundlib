/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module SplitControlFilterM( char MY_NAME[] )
{
	provides interface SplitControl as FilteredSplitControl;
	uses interface SplitControl;
}
implementation
{
	#define __MODUUL__ "SpFt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SplitControlFilterM & BASE_LOG_LEVEL )
	#include "log.h"

	enum
	{
		STOP = 0,
		STARTING = 1,
		RUN = 2,
		STOPPING = 3
	} state = STOP;

	command error_t FilteredSplitControl.start()
	{
		error_t error;

		debug2( "start state%d", state );

		switch( state ) {
		case STOP:
			error = call SplitControl.start();
			switch( error ) {
			case EALREADY:
				state = RUN;
			case SUCCESS:
				state = STARTING;
			}
			logger( error?LOG_WARN2:LOG_INFO2, "start%d state%d", error, state );
			return error;
		case STARTING:
		case STOPPING:
			err1("busy state%d", state);
			return EBUSY;
		case RUN:
			err1("already");
			return EALREADY;
		}

		err1("unknown state%d", state);
		return FAIL;

	}

	event void SplitControl.startDone( error_t error )
	{
		debug2("startDone%d state%d", error, state);
		if( state != STARTING )
			return;

		state = error==SUCCESS || error==EALREADY  ?  RUN  :  STOP;
		logger( state==RUN?LOG_INFO2:LOG_WARN2, "startDone%d state%d", error, state );
		signal FilteredSplitControl.startDone( error );
	}


	command error_t FilteredSplitControl.stop()
	{
		error_t error;

		debug2( "stop state%d", state );

		switch( state ) {
		case RUN:
			error = call SplitControl.stop();
			switch( error ) {
			case EALREADY:
				state = STOP;
			case SUCCESS:
				state = STOPPING;
			}
			logger( error?LOG_WARN2:LOG_INFO2, "stop%d state%d", error, state );
			return error;
		case STARTING:
		case STOPPING:
			err1("busy state%d", state);
			return EBUSY;
		case STOP:
			err1("already");
			return EALREADY;
		}

		err1("unknown state%d", state);
		return FAIL;
	}

	event void SplitControl.stopDone( error_t error )
	{
		debug2("stopDone%d state%d", error, state);
		if( state != STOPPING )
			return;

		state = error==SUCCESS || error==EALREADY  ?  STOP  :  RUN;
		logger( state==STOP?LOG_INFO2:LOG_WARN2, "stopDone%d state%d", error, state );
		signal FilteredSplitControl.stopDone( error );
	}
}
