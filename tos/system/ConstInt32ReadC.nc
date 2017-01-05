/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstInt32ReadC(error_t result, int32_t value) {
	provides interface Read<int32_t>;
}
implementation {

	task void readDone() {
		signal Read.readDone(result, value);
	}

	command error_t Read.read() {
		return post readDone();
	}

}
