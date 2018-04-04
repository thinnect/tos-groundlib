/*
 * Allow switching between 2 different activemessage stacks at run-time.
 *
 * The switch cannot determine if the passed packet has been formatted using
 * the correct set of Packet commands. Therefore switching while manipulating
 * packets or having queued packets will probably not end well, but if
 * the stacks implement sanity checks, then nothing terrible should happen ...
 * other than the message not getting correctly delivered to the intended
 * destination.
 */
#include "AM.h"
generic module ActiveMessageSwitchC() {
	provides {
		interface GetSet<uint8_t> as GetSetInterface;

		interface AMSend[am_id_t id];
		interface AMPacket[am_id_t id];
		interface Packet[am_id_t id];
		interface Receive[am_id_t id];
		interface Receive as Snoop[am_id_t id];
	}
	uses {
		interface AMSend   as PrimaryAMSend[am_id_t id];
		interface AMPacket as PrimaryAMPacket[am_id_t id];
		interface Packet   as PrimaryPacket[am_id_t id];
		interface Receive  as PrimaryReceive[am_id_t id];
		interface Receive  as PrimarySnoop[am_id_t id];

		interface AMSend   as SecondaryAMSend[am_id_t id];
		interface AMPacket as SecondaryAMPacket[am_id_t id];
		interface Packet   as SecondaryPacket[am_id_t id];
		interface Receive  as SecondaryReceive[am_id_t id];
		interface Receive  as SecondarySnoop[am_id_t id];
	}
}
implementation {

	uint8_t m_interface = 0; // 0 for primary, 1 for secondary

	command uint8_t GetSetInterface.get() {
		return m_interface;
	}

	command void GetSetInterface.set(uint8_t val) {
		if(val < 2) {
			m_interface = val;
		}
	}

	// -------------------------------------------------------------------------

	command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
		if(m_interface == 0) {
			return call PrimaryAMSend.send[id](addr, msg, len);
		}
		return call SecondaryAMSend.send[id](addr, msg, len);
	}
	command error_t AMSend.cancel[am_id_t id](message_t* msg) {
		if(m_interface == 0) {
			return call PrimaryAMSend.cancel[id](msg);
		}
		return call SecondaryAMSend.cancel[id](msg);
	}
	command uint8_t AMSend.maxPayloadLength[am_id_t id]() {
		if(m_interface == 0) {
			return call PrimaryAMSend.maxPayloadLength[id]();
		}
		return call SecondaryAMSend.maxPayloadLength[id]();
	}
	command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len) {
		if(m_interface == 0) {
			return call PrimaryAMSend.getPayload[id](msg, len);
		}
		return call SecondaryAMSend.getPayload[id](msg, len);
	}
	event void PrimaryAMSend.sendDone[am_id_t id](message_t* msg, error_t error) {
		signal AMSend.sendDone[id](msg, error);
	}
	event void SecondaryAMSend.sendDone[am_id_t id](message_t* msg, error_t error) {
		signal AMSend.sendDone[id](msg, error);
	}

	default event void AMSend.sendDone[am_id_t id](message_t* msg, error_t error) { return; }

	default command error_t PrimaryAMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
		return ELAST;
	}
	default command error_t PrimaryAMSend.cancel[am_id_t id](message_t* msg) {
		return ELAST;
	}
	default command uint8_t PrimaryAMSend.maxPayloadLength[am_id_t id]() {
		if(id != 0) {
			return call PrimaryAMSend.maxPayloadLength[0]();
		}
		return 0;
	}
	default command void* PrimaryAMSend.getPayload[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			return call PrimaryAMSend.getPayload[0](msg, len);
		}
		return NULL;
	}
	default command error_t SecondaryAMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
		return ELAST;
	}
	default command error_t SecondaryAMSend.cancel[am_id_t id](message_t* msg) {
		return ELAST;
	}
	default command uint8_t SecondaryAMSend.maxPayloadLength[am_id_t id]() {
		if(id != 0) {
			return call SecondaryAMSend.maxPayloadLength[0]();
		}
		return 0;
	}
	default command void* SecondaryAMSend.getPayload[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			return call SecondaryAMSend.getPayload[0](msg, len);
		}
		return NULL;
	}

	// -------------------------------------------------------------------------

	command am_addr_t AMPacket.address[am_id_t id]() {
		if(m_interface == 0) {
			return call PrimaryAMPacket.address[id]();
		}
		return call SecondaryAMPacket.address[id]();
	}
	command am_addr_t AMPacket.destination[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryAMPacket.destination[id](amsg);
		}
		return call SecondaryAMPacket.destination[id](amsg);
	}
	command am_addr_t AMPacket.source[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryAMPacket.source[id](amsg);
		}
		return call SecondaryAMPacket.source[id](amsg);
	}
	command void AMPacket.setDestination[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(m_interface == 0) {
			call PrimaryAMPacket.setDestination[id](amsg, addr);
		}
		else {
			call SecondaryAMPacket.setDestination[id](amsg, addr);
		}
	}
	command void AMPacket.setSource[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(m_interface == 0) {
			call PrimaryAMPacket.setSource[id](amsg, addr);
		}
		else {
			call SecondaryAMPacket.setSource[id](amsg, addr);
		}
	}
	command bool AMPacket.isForMe[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryAMPacket.isForMe[id](amsg);
		}
		return call SecondaryAMPacket.isForMe[id](amsg);
	}
	command am_id_t AMPacket.type[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryAMPacket.type[id](amsg);
		}
		return call SecondaryAMPacket.type[id](amsg);
	}
	command void AMPacket.setType[am_id_t id](message_t* amsg, am_id_t t) {
		if(m_interface == 0) {
			call PrimaryAMPacket.setType[id](amsg, t);
		}
		else {
			call SecondaryAMPacket.setType[id](amsg, t);
		}
	}
	command am_group_t AMPacket.group[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryAMPacket.group[id](amsg);
		}
		return call SecondaryAMPacket.group[id](amsg);
	}
	command void AMPacket.setGroup[am_id_t id](message_t* amsg, am_group_t grp) {
		if(m_interface == 0) {
			call PrimaryAMPacket.setGroup[id](amsg, grp);
		}
		else {
			call SecondaryAMPacket.setGroup[id](amsg, grp);
		}
	}
	command am_group_t AMPacket.localGroup[am_id_t id]() {
		if(m_interface == 0) {
			return call PrimaryAMPacket.localGroup[id]();
		}
		return call SecondaryAMPacket.localGroup[id]();
	}

	// -------------------------------------------------------------------------

	default command am_addr_t PrimaryAMPacket.address[am_id_t id]() {
		if(id != 0) {
			return call PrimaryAMPacket.address[0]();
		}
		return 0;
	}
	default command am_addr_t PrimaryAMPacket.destination[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call PrimaryAMPacket.destination[0](amsg);
		}
		return 0;
	}
	default command am_addr_t PrimaryAMPacket.source[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call PrimaryAMPacket.source[0](amsg);
		}
		return 0;
	}
	default command void PrimaryAMPacket.setDestination[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(id != 0) {
			call PrimaryAMPacket.setDestination[0](amsg, addr);
		}
	}
	default command void PrimaryAMPacket.setSource[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(id != 0) {
			call PrimaryAMPacket.setSource[0](amsg, addr);
		}
	}
	default command bool PrimaryAMPacket.isForMe[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call PrimaryAMPacket.isForMe[0](amsg);
		}
		return FALSE;
	}
	default command am_id_t PrimaryAMPacket.type[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call PrimaryAMPacket.type[0](amsg);
		}
		return 0;
	}
	default command void PrimaryAMPacket.setType[am_id_t id](message_t* amsg, am_id_t t) {
		if(id != 0) {
			call PrimaryAMPacket.setType[0](amsg, t);
		}
	}
	default command am_group_t PrimaryAMPacket.group[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call PrimaryAMPacket.group[0](amsg);
		}
		return 0;
	}
	default command void PrimaryAMPacket.setGroup[am_id_t id](message_t* amsg, am_group_t grp) {
		if(id != 0) {
			call PrimaryAMPacket.setGroup[0](amsg, grp);
		}
	}
	default command am_group_t PrimaryAMPacket.localGroup[am_id_t id]() {
		if(id != 0) {
			return call PrimaryAMPacket.localGroup[0]();
		}
		return 0;
	}

	// -------------------------------------------------------------------------

	default command am_addr_t SecondaryAMPacket.address[am_id_t id]() {
		if(id != 0) {
			return call SecondaryAMPacket.address[0]();
		}
		return 0;
	}
	default command am_addr_t SecondaryAMPacket.destination[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call SecondaryAMPacket.destination[0](amsg);
		}
		return 0;
	}
	default command am_addr_t SecondaryAMPacket.source[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call SecondaryAMPacket.source[0](amsg);
		}
		return 0;
	}
	default command void SecondaryAMPacket.setDestination[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(id != 0) {
			call SecondaryAMPacket.setDestination[0](amsg, addr);
		}
	}
	default command void SecondaryAMPacket.setSource[am_id_t id](message_t* amsg, am_addr_t addr) {
		if(id != 0) {
			call SecondaryAMPacket.setSource[0](amsg, addr);
		}
	}
	default command bool SecondaryAMPacket.isForMe[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call SecondaryAMPacket.isForMe[0](amsg);
		}
		return FALSE;
	}
	default command am_id_t SecondaryAMPacket.type[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call SecondaryAMPacket.type[0](amsg);
		}
		return 0;
	}
	default command void SecondaryAMPacket.setType[am_id_t id](message_t* amsg, am_id_t t) {
		if(id != 0) {
			call SecondaryAMPacket.setType[0](amsg, t);
		}
	}
	default command am_group_t SecondaryAMPacket.group[am_id_t id](message_t* amsg) {
		if(id != 0) {
			return call SecondaryAMPacket.group[0](amsg);
		}
		return 0;
	}
	default command void SecondaryAMPacket.setGroup[am_id_t id](message_t* amsg, am_group_t grp) {
		if(id != 0) {
			call SecondaryAMPacket.setGroup[0](amsg, grp);
		}
	}
	default command am_group_t SecondaryAMPacket.localGroup[am_id_t id]() {
		if(id != 0) {
			return call SecondaryAMPacket.localGroup[0]();
		}
		return 0;
	}

	// -------------------------------------------------------------------------

	command void Packet.clear[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryPacket.clear[id](amsg);
		}
		return call SecondaryPacket.clear[id](amsg);
	}
	command uint8_t Packet.payloadLength[am_id_t id](message_t* amsg) {
		if(m_interface == 0) {
			return call PrimaryPacket.payloadLength[id](amsg);
		}
		return call SecondaryPacket.payloadLength[id](amsg);
	}
	command void Packet.setPayloadLength[am_id_t id](message_t* amsg, uint8_t len) {
		if(m_interface == 0) {
			return call PrimaryPacket.setPayloadLength[id](amsg, len);
		}
		return call SecondaryPacket.setPayloadLength[id](amsg, len);
	}
	command uint8_t Packet.maxPayloadLength[am_id_t id]() {
		if(m_interface == 0) {
			return call PrimaryPacket.maxPayloadLength[id]();
		}
		return call SecondaryPacket.maxPayloadLength[id]();
	}
	command void* Packet.getPayload[am_id_t id](message_t* amsg, uint8_t len) {
		if(m_interface == 0) {
			return call PrimaryPacket.getPayload[id](amsg, len);
		}
		return call SecondaryPacket.getPayload[id](amsg, len);
	}

	// -------------------------------------------------------------------------

	default command void PrimaryPacket.clear[am_id_t id](message_t* msg) {
		if(id != 0) {
			call PrimaryPacket.clear[0](msg);
		}
	}
	default command uint8_t PrimaryPacket.payloadLength[am_id_t id](message_t* msg) {
		if(id != 0) {
			call PrimaryPacket.payloadLength[0](msg);
		}
		return 0;
	}
	default command void PrimaryPacket.setPayloadLength[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			call PrimaryPacket.setPayloadLength[0](msg, len);
		}
	}
	default command uint8_t PrimaryPacket.maxPayloadLength[am_id_t id]() {
		if(id != 0) {
			return call PrimaryPacket.maxPayloadLength[0]();
		}
		return 0;
	}
	default command void* PrimaryPacket.getPayload[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			return call PrimaryPacket.getPayload[0](msg, len);
		}
		return 0;
	}

	// -------------------------------------------------------------------------

	default command void SecondaryPacket.clear[am_id_t id](message_t* msg) {
		if(id != 0) {
			call SecondaryPacket.clear[0](msg);
		}
	}
	default command uint8_t SecondaryPacket.payloadLength[am_id_t id](message_t* msg) {
		if(id != 0) {
			call SecondaryPacket.payloadLength[0](msg);
		}
		return 0;
	}
	default command void SecondaryPacket.setPayloadLength[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			call SecondaryPacket.setPayloadLength[0](msg, len);
		}
	}
	default command uint8_t SecondaryPacket.maxPayloadLength[am_id_t id]() {
		if(id != 0) {
			return call SecondaryPacket.maxPayloadLength[0]();
		}
		return 0;
	}
	default command void* SecondaryPacket.getPayload[am_id_t id](message_t* msg, uint8_t len) {
		if(id != 0) {
			return call SecondaryPacket.getPayload[0](msg, len);
		}
		return 0;
	}

	// -------------------------------------------------------------------------

	event message_t* PrimaryReceive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		if(m_interface == 0) {
			return signal Receive.receive[id](msg, payload, len);
		}
		return msg;
	}

	event message_t* PrimarySnoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		if(m_interface == 0) {
			return signal Snoop.receive[id](msg, payload, len);
		}
		return msg;
	}

	event message_t* SecondaryReceive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		if(m_interface == 1) {
			return signal Receive.receive[id](msg, payload, len);
		}
		return msg;
	}

	event message_t* SecondarySnoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		if(m_interface == 1) {
			return signal Snoop.receive[id](msg, payload, len);
		}
		return msg;
	}

	default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		return msg;
	}

	default event message_t* Snoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		return msg;
	}

}
