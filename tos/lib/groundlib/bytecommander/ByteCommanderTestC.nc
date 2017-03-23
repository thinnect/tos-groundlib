/**
 * Basic ByteCommander test - prints "ByteCommanderTest" in response to 't'.
 *
 * @author Raido Pahtma
 * @license MIT
 */
configuration ByteCommanderTestC {}
implementation {

	components ByteCommanderTestP;

	components new ByteCommanderC();
	ByteCommanderTestP.Notify -> ByteCommanderC.Notify;

	components MainC;
	ByteCommanderTestP.Boot -> MainC.Boot;

}
