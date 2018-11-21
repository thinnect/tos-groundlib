/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module MultiSeqSplitControlC(char MY_NAME[], uint8_t count) {
	provides interface SplitControl;
	uses {
		interface SplitControl as SeqSplitControl[uint8_t seq];
	}
}
implementation
{
	#define __MODUUL__ "MSqSp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_MultiSeqSplitControlC & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_working = FALSE;

	command error_t SplitControl.start() {
		error_t err = call SeqSplitControl.start[0]();
		logger(err?LOG_WARN2:LOG_INFO2, "%s:%d.st=%d", MY_NAME, 0, err);
		if(err == SUCCESS) {
			m_working = TRUE;
		}
		return err;
	}

	event void SeqSplitControl.startDone[uint8_t seq](error_t result) {
		logger(result?LOG_WARN2:LOG_INFO2, "%s:%d.stD=%d", MY_NAME, seq, result);
		if(m_working) {
			if(result == SUCCESS) {
				if(++seq < count) {
					error_t err = call SeqSplitControl.start[seq]();
					logger(err?LOG_WARN2:LOG_INFO2, "%s:%d.st=%d", MY_NAME, seq, err);
					if(err == SUCCESS) {
						return;
					}
					else {
						result = FAIL;
					}
				}
			}
			m_working = FALSE;
			signal SplitControl.startDone(result);
		}
	}

	command error_t SplitControl.stop() {
		error_t err = call SeqSplitControl.stop[count-1]();
		logger(err?LOG_WARN2:LOG_INFO2, "%s:%d.sp=%d", MY_NAME, 0, err);
		if(err == SUCCESS) {
			m_working = TRUE;
		}
		return err;
	}

	event void SeqSplitControl.stopDone[uint8_t seq](error_t result) {
		logger(result?LOG_WARN2:LOG_INFO2, "%s:%d.spD=%d", MY_NAME, seq, result);
		if(m_working) {
			if(result == SUCCESS) {
				if(seq-- > 0) {
					error_t err = call SeqSplitControl.stop[seq]();
					logger(err?LOG_WARN2:LOG_INFO2, "%s:%d.sp=%d", MY_NAME, seq, err);
					if(err == SUCCESS) {
						return;
					}
					else {
						result = FAIL;
					}
				}
			}
			m_working = FALSE;
			signal SplitControl.stopDone(result);
		}
	}

	default command error_t SeqSplitControl.start[uint8_t seq]() { return ELAST; }
	default command error_t SeqSplitControl.stop[uint8_t seq]()  { return ELAST; }

}
