/**
 * @author Raido Pahtma
 * @license MIT
*/
module GlobalPoolWrapperP {
	provides interface Pool<message_t>;
	uses {
		interface Pool<message_t> as Sub;
		interface Boot;
	}
}
implementation
{

 	#define __MODUUL__ "GPW"
	#define __LOG_LEVEL__ ( LOG_LEVEL_GPW & BASE_LOG_LEVEL )
	#include "log.h"

	#warning "GlobalPoolWrapper"

	task void poolStatus();

	command bool Pool.empty() {
		return call Sub.empty();
	}

	command uint8_t Pool.maxSize() {
		return call Sub.maxSize();
	}

	command error_t Pool.put(message_t *newVal) {
		debug1("put %u %u %04x", call Sub.size(), call Sub.maxSize(), newVal);
		return call Sub.put(newVal);
	}

	command message_t* Pool.get() {
		debug1("get %u %u", call Sub.size(), call Sub.maxSize());
		return call Sub.get();
	}

	command uint8_t Pool.size() {
		return call Sub.size();
	}

	bool poolOk = TRUE;

	task void poolStatus()
	{
		if(call Sub.size() == 0)
		{
			if(poolOk)
			{
				debug1("empty");
			}
			poolOk = FALSE;
		}
		else
		{
			poolOk = TRUE;
		}
		post poolStatus();
	}

	event void Boot.booted() {
		post poolStatus();
	}

}
