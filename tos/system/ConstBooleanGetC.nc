/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstBooleanGetC(bool value) {
	provides interface Get<bool>;
}
implementation {

	command bool Get.get() {
		return value;
	}

}
