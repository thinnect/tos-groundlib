/**
 * Periodically sample the SubRead interface, return average and reset when
 * Read called. Starts after initial Read.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
#include <stdint.h>
generic module AverageFloatReadP(uint32_t period_s, uint32_t period_ms) {
	provides interface Read<float>;
	uses {
		interface Read<float> as SubRead;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "mic"
	#define __LOG_LEVEL__ ( LOG_LEVEL_AverageReadP & BASE_LOG_LEVEL )
	#include "log.h"

	float m_sum = 0;
	uint16_t m_count = 0;

	event void Timer.fired() {
		if(call SubRead.read() != SUCCESS) {
			warn1("r");
		}
	}

	event void SubRead.readDone(error_t result, float value) {
		if(result == SUCCESS) {
			if(m_count < UINT16_MAX) {
				m_sum += value;
				m_count++;
			} else {
				m_sum = value;
				m_count = 1;
			}
		} else warn1("rD %d", result);
	}

	task void readDone() {
		if(m_count > 0) {
			float avg = m_sum / m_count;
			debug1("avg %"PRIi32"/%"PRIu16"=%"PRIi32, (int32_t)m_sum, m_count, (int32_t)avg);
			m_sum = 0;
			m_count = 0;
			signal Read.readDone(SUCCESS, avg);
		} else {
			if(call Timer.isRunning() == FALSE) {
				debug1("first");
				call Timer.startPeriodic(SEC_TMILLI(period_s) + period_ms);
				signal Read.readDone(EOFF, 0);
			} else {
				warn1("none");
				signal Read.readDone(ERETRY, 0);
			}
		}
	}

	command error_t Read.read() {
		return post readDone();
	}

}
