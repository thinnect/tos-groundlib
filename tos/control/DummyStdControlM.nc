/**
 * @author Andrei Lunjov
 * @license MIT
*/
module DummyStdControlM
{
	provides interface StdControl;
}
implementation
{
	command error_t StdControl.stop()
	{
		return SUCCESS;
	}

	command error_t StdControl.start()
	{
		return SUCCESS;
	}
}
