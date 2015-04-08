/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
generic module DummySplitControlC()
{
	provides interface SplitControl;
}
implementation
{
	enum {
		OFF, STARTING, ON, STOPPING
	} state = OFF;

	task void start()
	{
		state = ON;
		signal SplitControl.startDone(SUCCESS);
	}

	command error_t SplitControl.start()
	{
		switch( state ) {
		case OFF:
			state = STARTING;
			post start();
		case STARTING:
			return SUCCESS;
		case STOPPING:
			return EBUSY;
		case ON:
			return EALREADY;
		default:
			return FAIL;
		}
	}

	task void stop()
	{
		state=OFF;
		signal SplitControl.stopDone(SUCCESS);
	}

	command error_t SplitControl.stop()
	{
		switch( state ) {
		case ON:
			state = STOPPING;
			post stop();
		case STOPPING:
			return SUCCESS;
		case STARTING:
			return EBUSY;
		case OFF:
			return EALREADY;
		default:
			return FAIL;
		}
	}
}
