/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module DelayedBootP(char MY_NAME[], uint32_t delay_ms) {
	provides interface Boot as DelayedBoot;
	uses {
		interface Boot as RealBoot;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "DlBt"
	#define __LOG_LEVEL__ ( LOG_LEVEL_DelayedBootP & BASE_LOG_LEVEL )
	#include "log.h"

	event void RealBoot.booted() {
		info1("%s delay %"PRIu32, MY_NAME, delay_ms);
		call Timer.startOneShot(delay_ms);
	}

	event void Timer.fired() {
		info1("boot");
		signal DelayedBoot.booted();
	}
}
