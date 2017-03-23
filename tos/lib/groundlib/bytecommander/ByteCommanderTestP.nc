/**
 * Basic ByteCommander test - prints "ByteCommanderTest" in response to 't'.
 *
 * @author Raido Pahtma
 * @license MIT
 */
module ByteCommanderTestP {
	uses {
		interface Notify<uint8_t>;
		interface Boot;
	}
}
implementation {

	event void Boot.booted() {
		call Notify.enable();
	}

	event void Notify.notify(uint8_t byte) {
		switch(byte) {
			case 't':
				printf("ByteCommanderTest\n");
			break;
		}
	}

}
