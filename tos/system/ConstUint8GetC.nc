/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstUint8GetC(uint8_t value) {
	provides interface Get<uint8_t>;
}
implementation {

	command uint8_t Get.get() {
		return value;
	}

}
