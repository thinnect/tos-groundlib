/**
 * Event status LED module.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic configuration LedEventIndicatorC(uint8_t lednum, typedef evtype) {
	uses {
		interface Notify<evtype> as EventStart;
		interface Notify<evtype> as EventEnd;
	}
}
implementation {

	components new LedEventIndicatorP(lednum, evtype) as LED;
	LED.EventStart = EventStart;
	LED.EventEnd   = EventEnd;

	components LedsC;
	LED.Leds -> LedsC;

	components MainC;
	LED.Boot -> MainC;

}
