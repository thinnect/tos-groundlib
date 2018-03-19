/**
 * FactoryReset core.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic module FactoryResetP(uint8_t component_count) {
	provides {
		interface Init;
		interface Reset;
	}
	uses interface Reset as ComponentReset[uint8_t cmpnnt];
}
implementation {

	#define __MODUUL__ "reset"
	#define __LOG_LEVEL__ ( LOG_LEVEL_FactoryResetP & BASE_LOG_LEVEL )
	#include "log.h"

	enum ComponentResetStates {
		FR_ST_DISABLED,
		FR_ST_IDLE,
		FR_ST_RESETTING,
		FR_ST_DONE,
		FR_ST_FAILED
	};

	uint8_t m_component_states[component_count];
	uint8_t m_state = FR_ST_DISABLED;

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<component_count;i++) {
			m_component_states[i] = FR_ST_IDLE;
		}
		m_state = FR_ST_IDLE;
		return SUCCESS;
	}

	command error_t Reset.reset() {
		if(m_state == FR_ST_IDLE) {
			uint8_t resetting = 0;
			uint8_t i;
			for(i=0;i<component_count;i++) {
				error_t err = call ComponentReset.reset[i]();
				if(err == SUCCESS) {
					m_component_states[i] = FR_ST_RESETTING;
					resetting++;
				}
				else {
					m_component_states[i] = FR_ST_FAILED;
				}
			}
			if(resetting > 0) {
				return SUCCESS;
			}
			return FAIL;
		}
		return EBUSY;
	}

	event void ComponentReset.resetDone[uint8_t cmpnnt](error_t result) {
		uint8_t errors = 0;
		uint8_t i;
		if(result == SUCCESS) {
			m_component_states[cmpnnt] = FR_ST_DONE;
		}
		else {
			m_component_states[cmpnnt] = FR_ST_FAILED;
		}
		for(i=0;i<component_count;i++) {
			if(m_component_states[i] == FR_ST_RESETTING) {
				return;
			}
			if(m_component_states[i] == FR_ST_FAILED) {
				errors++;
			}
		}
		m_state = FR_ST_IDLE;
		logger(errors == 0 ? LOG_DEBUG1: LOG_ERR1, "done %d/%d", component_count-errors, component_count);
		signal Reset.resetDone(errors == 0 ? SUCCESS: FAIL);
	}

	default command error_t ComponentReset.reset[uint8_t cmpnnt]() { return ELAST; }

	default event void Reset.resetDone(error_t result) { }

}
