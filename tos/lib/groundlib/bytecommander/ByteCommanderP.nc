/**
 * ByteCommander client and UART wiring configuration, always uses the same UART
 * as the logging module.
 *
 * @author Raido Pahtma
 * @license MIT
 */
configuration ByteCommanderP {
	provides interface Notify<uint8_t>[uint8_t client];
}
implementation {

	components new ByteCommanderM(uniqueCount("ByteCommander"));
	Notify = ByteCommanderM.Notify;

	#if PRINTF_PORT==0
		components Atm128Uart0C as Uart;
	#elif PRINTF_PORT==1
		components Atm128Uart1C as Uart;
	#else
		#error PRINTF_PORT must be 0 or 1
	#endif
	ByteCommanderM.SerialControl -> Uart.StdControl;
	ByteCommanderM.UartStream    -> Uart.UartStream;

	components MainC;
	MainC.SoftwareInit -> ByteCommanderM.Init;

}
