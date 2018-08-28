/**
 * Virtualize a ReadTs component.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic module VirtualizeReadTsP(uint8_t client_count, typedef value_type @number(), typedef presicion_tag) {
	provides {
		interface Init;
		interface ReadTs<value_type, presicion_tag>[uint8_t client];
	}
	uses {
		interface ReadTs<value_type, presicion_tag> as RealReadTs;
	}
}
implementation {

	bool requested[client_count];
	bool reading;

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<client_count;i++) {
			requested[i] = FALSE;
		}
		reading = FALSE;
		return SUCCESS;
	}

	command error_t ReadTs.read[uint8_t client]() {
		if(requested[client]) {
			return EALREADY;
		}
		if(!reading) {
			error_t err = call RealReadTs.read();
			if(err != SUCCESS) {
				return err;
			}
			reading = TRUE;
		}
		requested[client] = TRUE;
		return SUCCESS;
	}

	event void RealReadTs.readDone(error_t result, value_type value, uint32_t timestamp) {
		uint8_t i;
		reading = FALSE;
		for(i=0;i<client_count;i++) {
			if(requested[i]) {
				requested[i] = FALSE;
				signal ReadTs.readDone[i](result, value, timestamp);
			}
		}
	}

	default event void ReadTs.readDone[uint8_t client](error_t result, value_type value, uint32_t timestamp) { }

}
