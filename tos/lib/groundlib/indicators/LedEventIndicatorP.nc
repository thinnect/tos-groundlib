/**
 * Toggle LED based on event start and end.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic module LedEventIndicatorP(uint8_t lednum, typedef evtype) {
	uses {
		interface Notify<evtype> as EventStart;
		interface Notify<evtype> as EventEnd;
		interface Leds;
		interface Boot;
	}
}
implementation {

	event void Boot.booted() {
		call EventStart.enable();
		call EventEnd.enable();
	}

	event void EventStart.notify(evtype value) {
		switch(lednum) {
		case 0:
			call Leds.led0On();
			break;
		case 1:
			call Leds.led1On();
			break;
		case 2:
			call Leds.led2On();
			break;
		}
	}

	event void EventEnd.notify(evtype value) {
		switch(lednum) {
		case 0:
			call Leds.led0Off();
			break;
		case 1:
			call Leds.led1Off();
			break;
		case 2:
			call Leds.led2Off();
			break;
		}
	}

}
