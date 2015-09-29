/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
generic module Split2StdControlC()
{
	provides interface SplitControl;
	uses interface StdControl;
}
implementation
{

	task void stop()
	{
		signal SplitControl.stopDone(SUCCESS);
	}

	command error_t SplitControl.stop()
	{
		error_t error = call StdControl.stop();
		if(error == SUCCESS)
		{
			post stop();
		}
		return error;
	}

	task void start()
	{
		signal SplitControl.startDone(SUCCESS);
	}

	command error_t SplitControl.start()
	{
		error_t error = call StdControl.start();
		if(error == SUCCESS)
		{
			post start();
		}
		return error;
	}

}
