/**
 * @author Raido Pahtma, Andres Vahter
 * @license MIT
*/
generic module BlinkyP(uint32_t g_period_ms, uint32_t g_on_time_ms) {
	uses {
		interface Boot;
		interface Timer<TMilli>;
		interface Leds;
	}
}
implementation {

    bool m_on = TRUE;

	event void Boot.booted(){
		call Timer.startOneShot(g_period_ms);
	}

	event void Timer.fired(){
	    if(m_on) {
	        m_on = FALSE;
	        call Leds.led0On();
	        call Timer.startOneShot(g_on_time_ms);
	    }
	    else {
	        m_on = TRUE;
	        call Leds.led0Off();
	        call Timer.startOneShot(g_period_ms - g_on_time_ms);
	    }
	}
}
