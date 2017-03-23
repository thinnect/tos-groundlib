/**
 * ByteCommander notification module.
 * Starts and enables the UART when at least one client calls enable.
 * Disable calls may have the unfortunate side-effect of disabling logging also.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic module ByteCommanderM(uint8_t clients) {
	provides {
		interface Init;
		interface Notify<uint8_t>[uint8_t client];
	}
	uses {
		interface StdControl as SerialControl;
		interface UartStream;
	}
}
implementation {

	bool m_enabled[clients];
	norace uint8_t m_byte_command; // norace because we just don't care

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<clients;i++) {
			m_enabled[i] = FALSE;
		}
		return SUCCESS;
	}

	bool enabled() {
		uint8_t i;
		for(i=0;i<clients;i++) {
			if(m_enabled[i]) {
				return TRUE;
			}
		}
		return FALSE;
	}

	command error_t Notify.enable[uint8_t client]() {
		if(!enabled()) {
			call SerialControl.start();
			call UartStream.enableReceiveInterrupt();
		}
		m_enabled[client] = TRUE;
		return SUCCESS;
	}

	command error_t Notify.disable[uint8_t client]() {
		m_enabled[client] = FALSE;
		if(!enabled()) {
			call UartStream.disableReceiveInterrupt();
			call SerialControl.stop();
		}
		return SUCCESS;
	}

	task void commandEvent() {
		uint8_t cmd = m_byte_command;
		uint8_t i;
		for(i=0;i<clients;i++) {
			if(m_enabled[i]) {
				signal Notify.notify[i](cmd);
			}
		}
	}

	async event void UartStream.receivedByte(uint8_t byte) {
		m_byte_command = byte;
		post commandEvent();
	}

  	async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) { }
  	async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) { }

  	default event void Notify.notify[uint8_t client](uint8_t byte) { }

}
