/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module ConstUint32ReadC(error_t result, uint32_t value) {
	provides interface Read<uint32_t>;
}
implementation {

	task void readDone() {
		signal Read.readDone(result, value);
	}

	command error_t Read.read() {
		return post readDone();
	}

}
