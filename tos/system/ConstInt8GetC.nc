/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstInt8GetC(int8_t value) {
	provides interface Get<int8_t>;
}
implementation {

	command int8_t Get.get() {
		return value;
	}

}
