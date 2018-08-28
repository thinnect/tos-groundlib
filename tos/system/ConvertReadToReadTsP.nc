/**
 * Convert Read to ReadTs, current time is added as timestamp.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic module ConvertReadToReadTsP(typedef value_type @number(), typedef precision_tag) {
	provides {
		interface ReadTs<value_type, precision_tag>;
	}
	uses {
		interface Read<value_type>;
		interface LocalTime<precision_tag>;
	}
}
implementation {

	command error_t ReadTs.read() {
		return call Read.read();
	}

	event void Read.readDone(error_t result, value_type value) {
		signal ReadTs.readDone(result, value, call LocalTime.get());
	}

}
