/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module Std2InitControlC()
{
	provides {
		interface StdControl;
	}
	uses {
		interface Init;
	}
}
implementation
{

	command error_t StdControl.stop()
	{
		return FAIL;
	}

	command error_t StdControl.start()
	{
		return call Init.init();
	}

}
