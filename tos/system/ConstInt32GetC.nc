/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstInt32GetC(int32_t value) {
	provides interface Get<int32_t>;
}
implementation {

	command int32_t Get.get() {
		return value;
	}

}
