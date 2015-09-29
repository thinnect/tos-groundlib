/**
 * @author Andrei Lunjov, Raido Pahtma
 * @license MIT
*/

#define PRINTF_USING_UART1
#ifdef PRINTF_USING_UART0
    #error cant use both PRINTF_USING_UART0 and PRINTF_USING_UART1 at the same time
#endif

configuration Uart1PrintfC
{
	provides interface StdControl;
}

implementation
{
	components HplAtm128UartC, UartPrintfP;

	UartPrintfP.HplUartTxControl -> HplAtm128UartC.Uart1TxControl;
	UartPrintfP.HplUart          -> HplAtm128UartC.HplUart1;

	StdControl = UartPrintfP.StdControl;

#ifdef UART_PRINTF_LEDS
	components LedsC as Leds;
#else
	components NoLedsC as Leds;
#endif
	UartPrintfP.Leds -> Leds;
}
