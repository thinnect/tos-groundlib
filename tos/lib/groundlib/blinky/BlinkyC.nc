/**
 * @author Raido Pahtma, Andres Vahter
 * @license MIT
*/
generic configuration BlinkyC(uint32_t g_period_ms, uint32_t g_on_time_ms) {

}
implementation {

	components new BlinkyP(g_period_ms, g_on_time_ms);

	components MainC;
	BlinkyP.Boot -> MainC;

	components new TimerMilliC();
	BlinkyP.Timer -> TimerMilliC;

	components LedsC;
	BlinkyP.Leds -> LedsC;

}
