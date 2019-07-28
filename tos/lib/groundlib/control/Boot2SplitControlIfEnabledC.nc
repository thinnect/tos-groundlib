/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module Boot2SplitControlIfEnabledC(char COMPONENT_NAME[]) {
	uses {
		interface Boot;
		interface Get<bool> as Enabled;
		interface SplitControl;
	}
}
implementation {

	#define __MODUUL__ "BtSpIf"
	#define __LOG_LEVEL__ ( LOG_LEVEL_Boot2SplitControlIfEnabled & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted() {
		if(call Enabled.get()) {
			error_t error = call SplitControl.start();
			logger(error?LOG_WARN2:LOG_INFO2, "%s.s=%d", COMPONENT_NAME, error);
			(void)error; // Suppress unused-but-set-variable
		}
		else {
			info2("%s dsbld", COMPONENT_NAME);
		}
	}

	event void SplitControl.startDone(error_t error) {
		logger(error?LOG_WARN2:LOG_INFO2, "%s.sD=%d", COMPONENT_NAME, error);
	}

	event void SplitControl.stopDone(error_t error) { }
}
