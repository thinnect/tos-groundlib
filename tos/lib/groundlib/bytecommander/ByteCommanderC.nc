/**
 * ByteCommander instance configuration.
 * Create an instance, wire to it and call enable to get notifications when
 * characters are received from the UART that is used for logging (PRINTF_PORT).
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic configuration ByteCommanderC() {
	provides interface Notify<uint8_t>;
}
implementation {

	components ByteCommanderP;
	Notify = ByteCommanderP.Notify[unique("ByteCommander")];

}
