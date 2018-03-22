/*
 * Handle parametrized AMPacket and Packet interfaces based on one specific
 * reference interface.
 */
#include "AM.h"
generic module ActiveMessagePacketJoinerC() {
	provides {
		interface AMPacket[am_id_t id];
		interface Packet[am_id_t id];
	}
	uses {
		interface AMPacket as SubAMPacket;
		interface Packet   as SubPacket;
	}
}
implementation {

	command am_addr_t AMPacket.address[am_id_t id]() {
		return call SubAMPacket.address();
	}
	command am_addr_t AMPacket.destination[am_id_t id](message_t* amsg) {
		return call SubAMPacket.destination(amsg);
	}
	command am_addr_t AMPacket.source[am_id_t id](message_t* amsg) {
		return call SubAMPacket.source(amsg);
	}
	command void AMPacket.setDestination[am_id_t id](message_t* amsg, am_addr_t addr) {
		call SubAMPacket.setDestination(amsg, addr);
	}
	command void AMPacket.setSource[am_id_t id](message_t* amsg, am_addr_t addr) {
		call SubAMPacket.setSource(amsg, addr);
	}
	command bool AMPacket.isForMe[am_id_t id](message_t* amsg) {
		return call SubAMPacket.isForMe(amsg);
	}
	command am_id_t AMPacket.type[am_id_t id](message_t* amsg) {
		return call SubAMPacket.type(amsg);
	}
	command void AMPacket.setType[am_id_t id](message_t* amsg, am_id_t t) {
		call SubAMPacket.setType(amsg, t);
	}
	command am_group_t AMPacket.group[am_id_t id](message_t* amsg) {
		return call SubAMPacket.group(amsg);
	}
	command void AMPacket.setGroup[am_id_t id](message_t* amsg, am_group_t grp) {
		call SubAMPacket.setGroup(amsg, grp);
	}
	command am_group_t AMPacket.localGroup[am_id_t id]() {
		return call SubAMPacket.localGroup();
	}

	// -------------------------------------------------------------------------

	command void Packet.clear[am_id_t id](message_t* amsg) {
		return call SubPacket.clear(amsg);
	}
	command uint8_t Packet.payloadLength[am_id_t id](message_t* amsg) {
		return call SubPacket.payloadLength(amsg);
	}
	command void Packet.setPayloadLength[am_id_t id](message_t* amsg, uint8_t len) {
		return call SubPacket.setPayloadLength(amsg, len);
	}
	command uint8_t Packet.maxPayloadLength[am_id_t id]() {
		return call SubPacket.maxPayloadLength();
	}
	command void* Packet.getPayload[am_id_t id](message_t* amsg, uint8_t len) {
		return call SubPacket.getPayload(amsg, len);
	}

}
