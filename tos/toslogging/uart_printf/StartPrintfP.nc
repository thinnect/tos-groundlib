/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/
#include "logger.h"

generic module StartPrintfP(uint32_t g_printf_start_delay) {
	provides {
		interface SplitControl;
		interface Boot;
	}
	uses {
		interface StdControl as PrintfControl;

		interface Timer<TMilli>;
		interface Leds;
		interface Boot as SysBoot;
	}
}
implementation
{

	typedef struct start_printf_t {
		uint8_t led;
		bool booted;
	} start_printf_t;

	start_printf_t m_state = {0, FALSE};

	task void start()
	{
		signal SplitControl.startDone(SUCCESS);
		if(!m_state.booted)
		{
			m_state.booted = TRUE;
			signal Boot.booted();
		}
	}

	task void stop()
	{
		signal SplitControl.startDone(SUCCESS);
	}

	event void Timer.fired()
	{
		wdt_reset();
		if(m_state.led < 3)
		{
			call Leds.set( call Leds.get() | 1<<m_state.led++ );
			call Timer.startOneShot(g_printf_start_delay);
		}
		else
		{
			printf_P(PSTR("BOOT %04X t=%"PRIu32"\n"), TOS_NODE_ID, call Timer.getNow());
			printfflush();
			call Leds.set(0);
			post start();
		}
	}

	command error_t SplitControl.start()
	{
		error_t error = call PrintfControl.start();
		if(error == SUCCESS)
		{
			m_state.led = 0;
			call Leds.set(0);
			call Timer.startOneShot(g_printf_start_delay);
		}
		return error;
	}

	event void SysBoot.booted()
	{
		call SplitControl.start();
	}

	command error_t SplitControl.stop()
	{
		error_t error = call PrintfControl.stop();
		if(error != SUCCESS)
		{
			post stop();
		}
		return error;
	}

	default event void SplitControl.startDone(error_t err) { }
	default event void SplitControl.stopDone(error_t err) { }
	default event void Boot.booted() { }

}
