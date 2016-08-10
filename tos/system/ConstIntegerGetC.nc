/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstIntegerGetC(typedef value_type @integer(), value_type value) {
	provides interface Get<value_type>;
}
implementation {

	command value_type Get.get() {
		return value;
	}

}
