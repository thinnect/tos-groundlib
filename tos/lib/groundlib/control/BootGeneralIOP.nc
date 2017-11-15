/**
 * Component for setting GPIO state from Boot event.
 *
 * @author Raido Pahtma
 * @license MIT
 *
 * GPIO_MODE - TRUE for output, FALSE for input
 * GPIO_LEVEL - TRUE for set, FALSE for clr
*/
generic module BootGeneralIOP(char GPIO_NAME[], bool GPIO_MODE, bool GPIO_LEVEL) {
	uses {
		interface Boot;
		interface GeneralIO;
	}
}
implementation {

	#define __MODUUL__ "BtGPIO"
	#define __LOG_LEVEL__ ( LOG_LEVEL_BootGeneralIO & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted() {
		if(GPIO_MODE) {
			call GeneralIO.makeOutput();
		}
		else {
			call GeneralIO.makeInput();
		}
		if(GPIO_LEVEL) {
			call GeneralIO.set();
		}
		else {
			call GeneralIO.clr();
		}
		debug1("%s: %d->%d", GPIO_NAME, GPIO_MODE, GPIO_LEVEL);
	}

}
