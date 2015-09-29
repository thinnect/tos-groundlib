/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/

#define PRINTF_USING_UART0
#ifdef PRINTF_USING_UART1
    #error cant use both PRINTF_USING_UART0 and PRINTF_USING_UART1 at the same time
#endif

configuration Uart0PrintfC
{
	provides interface StdControl;
}

implementation
{
	components HplAtm128UartC, UartPrintfP;

	UartPrintfP.HplUartTxControl -> HplAtm128UartC.Uart0TxControl;
	UartPrintfP.HplUart          -> HplAtm128UartC.HplUart0;

	StdControl = UartPrintfP.StdControl;

#ifdef UART_PRINTF_LEDS
	components LedsC as Leds;
#else
	components NoLedsC as Leds;
#endif
	UartPrintfP.Leds -> Leds;
}
