/**
 * Convert ReadTs to Read, timestamp is discarded.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic module ConvertReadTsToReadC(typedef value_type @number(), typedef precision_tag) {
	provides {
		interface Read<value_type>;
	}
	uses {
		interface ReadTs<value_type, precision_tag>;
	}
}
implementation {

	command error_t Read.read() {
		return call ReadTs.read();
	}

	event void ReadTs.readDone(error_t result, value_type value, uint32_t timestamp) {
		signal Read.readDone(result, value);
	}

}
