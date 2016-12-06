/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration StartPrintfC {
	provides {
		interface SplitControl;
		interface Boot;
	}
	uses {
		interface Boot as SysBoot;
	}
}
implementation {

	#ifndef START_PRINTF_DELAY
		#warning "default START_PRINTF_DELAY 1024"
		#define START_PRINTF_DELAY 1024
	#endif
	components new StartPrintfP(START_PRINTF_DELAY);
	SplitControl = StartPrintfP;
	Boot = StartPrintfP;
	StartPrintfP.SysBoot = SysBoot;

	components new TimerMilliC();
	StartPrintfP.Timer -> TimerMilliC.Timer;

	#if PRINTF_PORT==0
		#warning using PRINTF_PORT 0
		components Uart0PrintfC as PrintfC;
	#elif PRINTF_PORT==1
		#warning using PRINTF_PORT 1
		components Uart1PrintfC as PrintfC;
	#else
		#error PRINTF_PORT must be 0 or 1
	#endif
	StartPrintfP.PrintfControl -> PrintfC.StdControl;

	#ifdef DISABLE_PRINTF_START_LEDS
		components NoLedsC as LedsC;
	#else
		components LedsC;
	#endif // DISABLE_PRINTF_START_LEDS
	StartPrintfP.Leds -> LedsC.Leds;

}
