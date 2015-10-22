/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ClearMessagePoolP() {
	provides {
		interface Pool<message_t>;
	}
	uses {
		interface Pool<message_t> as SubPool;
		interface Packet;
		interface Boot;
	}
}
implementation
{

 	#define __MODUUL__ "GPool"
	#define __LOG_LEVEL__ ( LOG_LEVEL_ClearMessagePool & BASE_LOG_LEVEL )
	#include "log.h"

	command bool Pool.empty() {
		return call SubPool.empty();
	}

	command uint8_t Pool.maxSize() {
		return call SubPool.maxSize();
	}

	command error_t Pool.put(message_t* newVal) {
		debug1("put %u %u %04x", call SubPool.size(), call SubPool.maxSize(), newVal);
		return call SubPool.put(newVal);
	}

	command message_t* Pool.get() {
		message_t* msg;
		debug1("get %u %u", call SubPool.size(), call SubPool.maxSize());
		msg = call SubPool.get();
		if(msg != NULL) {
			call Packet.clear(msg);
		}
		else {
			info1("empty (%u/%u)", call SubPool.size(), call SubPool.maxSize());
		}
		return msg;
	}

	command uint8_t Pool.size() {
		return call SubPool.size();
	}

#ifdef CLEAR_MESSAGE_POOL_MONITOR
	#warning "CLEAR_MESSAGE_POOL_MONITOR"
	// This is a slightly paranoid approach for monitoring the pool.
	// Should not be used in production, because the MCU will never go to sleep.
	// It was useful for detecting memory corruption bugs.

	bool poolOk = TRUE;

	task void poolStatus() {
		if(call SubPool.size() == 0) {
			if(poolOk) {
				debug1("empty");
			}
			poolOk = FALSE;
		}
		else {
			poolOk = TRUE;
		}
		post poolStatus();
	}

#endif // CLEAR_MESSAGE_POOL_MONITOR

	event void Boot.booted() {
		info1("size (%u/%u)", call SubPool.size(), call SubPool.maxSize());
		#ifdef CLEAR_MESSAGE_POOL_MONITOR
			post poolStatus();
		#endif // CLEAR_MESSAGE_POOL_MONITOR
	}

}
