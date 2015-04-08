/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "logger.h"
configuration LoggingTestC {

}
implementation {

	components new LoggingTestP();

	components MainC;
	LoggingTestP.Boot -> MainC;

	components new TimerMilliC();
	LoggingTestP.Timer -> TimerMilliC;

	#ifndef START_PRINTF_DELAY
		#define START_PRINTF_DELAY 50
	#endif

	components new StartPrintfC(START_PRINTF_DELAY);
	LoggingTestP.PrintfControl -> StartPrintfC.SplitControl;


}
