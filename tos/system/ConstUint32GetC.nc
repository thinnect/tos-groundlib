/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstUint32GetC(uint32_t value) {
	provides interface Get<uint32_t>;
}
implementation {

	command uint32_t Get.get() {
		return value;
	}

}
