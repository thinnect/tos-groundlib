/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module LoggingTestP() {
	uses {
		interface SplitControl as PrintfControl;
		interface Boot;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "test"
	#define __LOG_LEVEL__ ( LOG_LEVEL_test & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted()
	{
		call PrintfControl.start();
	}

	event void PrintfControl.startDone(error_t err)
	{
		call Timer.startPeriodic(1024UL);
		debug1("test debug");
		info1("test info");
		warn1("test warning");
		err1("test error");
	}

	event void PrintfControl.stopDone(error_t err)
	{
		call Timer.stop();
	}

	event void Timer.fired()
	{
		debug1("%010"PRIu32" TOS_NODE_ID %04X", call Timer.getNow(), TOS_NODE_ID);
	}

}
