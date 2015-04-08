/**
 * @author Andrei Lunjov
 * @license MIT
*/
generic module Std2SplitControlM()
{
	provides interface SplitControl;
	uses interface StdControl;
}
implementation
{
	task void stop()
	{
		signal SplitControl.stopDone( SUCCESS );
	}

	command error_t SplitControl.stop()
	{
		error_t error = call StdControl.stop();
		if( !error )
			post stop();
		return error;
	}

	task void start()
	{
		signal SplitControl.startDone( SUCCESS );
	}

	command error_t SplitControl.start()
	{
		error_t error = call StdControl.start();
		if( !error )
			post start();
		return error;
	}
}
