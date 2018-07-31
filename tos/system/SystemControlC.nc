/**
 * Mediator for system events ... halt for now.
 *
 * @author Raido Pahtma
 * @license MIT
*/
module SystemControlC {
	provides {
		interface SystemControl;
		interface Halt;
	}
	uses interface Halt as InitHalt;
}
implementation {

	#define __MODUUL__ "sys"
	#define __LOG_LEVEL__ ( LOG_LEVEL_SystemControlC & BASE_LOG_LEVEL )
	#include "log.h"

	event error_t InitHalt.halt(uint32_t grace_period) {
		return call SystemControl.signalHalt(grace_period);
	}

	command error_t SystemControl.signalHalt(uint32_t grace_period) {
		error_t err;
		info1("HALT %"PRIu32, grace_period);
		err = signal Halt.halt(grace_period);
		if(err != SUCCESS) {
			err1("e%d", err);
		}
		return err;
	}

	command void SystemControl.reboot(bool force) {
		if(force == FALSE) {
			signal Halt.halt(0);
		}
		#warning "This reboot solution only works for AVR"
		wdt_enable(1);
		while(1);
	}

	default event error_t Halt.halt(uint32_t grace_period) { return SUCCESS; }

}
