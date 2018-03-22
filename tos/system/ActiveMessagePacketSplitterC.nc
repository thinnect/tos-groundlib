/*
 * Process AMPacket and Packet based on AMID contained in the packet.
 *
 * Makes the assumption that the AMID location is always the same and the AMID
 * is set!
 */
#include "AM.h"
generic module ActiveMessagePacketSplitterC() {
	provides {
		interface AMPacket;
		interface Packet;
	}
	uses {
		interface AMPacket as SubAMPacket[am_id_t id];
		interface Packet   as SubPacket[am_id_t id];
	}
}
implementation {

	command am_addr_t AMPacket.address() {
		return call SubAMPacket.address[0]();
	}
	command am_addr_t AMPacket.destination(message_t* amsg) {
		return call SubAMPacket.destination[call SubAMPacket.type[0](amsg)](amsg);
	}
	command am_addr_t AMPacket.source(message_t* amsg) {
		return call SubAMPacket.source[call SubAMPacket.type[0](amsg)](amsg);
	}
	command void AMPacket.setDestination(message_t* amsg, am_addr_t addr) {
		call SubAMPacket.setDestination[call SubAMPacket.type[0](amsg)](amsg, addr);
	}
	command void AMPacket.setSource(message_t* amsg, am_addr_t addr) {
		call SubAMPacket.setSource[call SubAMPacket.type[0](amsg)](amsg, addr);
	}
	command bool AMPacket.isForMe(message_t* amsg) {
		return call SubAMPacket.isForMe[call SubAMPacket.type[0](amsg)](amsg);
	}
	command am_id_t AMPacket.type(message_t* amsg) {
		return call SubAMPacket.type[call SubAMPacket.type[0](amsg)](amsg);
	}
	command void AMPacket.setType(message_t* amsg, am_id_t t) {
		call SubAMPacket.setType[call SubAMPacket.type[0](amsg)](amsg, t);
	}
	command am_group_t AMPacket.group(message_t* amsg) {
		return call SubAMPacket.group[call SubAMPacket.type[0](amsg)](amsg);
	}
	command void AMPacket.setGroup(message_t* amsg, am_group_t grp) {
		call SubAMPacket.setGroup[call SubAMPacket.type[0](amsg)](amsg, grp);
	}
	command am_group_t AMPacket.localGroup() {
		return call SubAMPacket.localGroup[0]();
	}

	default command am_addr_t SubAMPacket.address[am_id_t id]() { return 0; }
	default command am_addr_t SubAMPacket.destination[am_id_t id](message_t* amsg) { return 0; }
	default command am_addr_t SubAMPacket.source[am_id_t id](message_t* amsg) { return 0; }
	default command void SubAMPacket.setDestination[am_id_t id](message_t* amsg, am_addr_t addr) { }
	default command void SubAMPacket.setSource[am_id_t id](message_t* amsg, am_addr_t addr) { }
	default command bool SubAMPacket.isForMe[am_id_t id](message_t* amsg) { return FALSE; }
	default command am_id_t SubAMPacket.type[am_id_t id](message_t* amsg) { return 0; }
	default command void SubAMPacket.setType[am_id_t id](message_t* amsg, am_id_t t) { }
	default command am_group_t SubAMPacket.group[am_id_t id](message_t* amsg) { return 0; }
	default command void SubAMPacket.setGroup[am_id_t id](message_t* amsg, am_group_t grp) { }
	default command am_group_t SubAMPacket.localGroup[am_id_t id]() { return 0; }

	// -------------------------------------------------------------------------

	command void Packet.clear(message_t* amsg) {
		return call SubPacket.clear[call SubAMPacket.type[0](amsg)](amsg);
	}
	command uint8_t Packet.payloadLength(message_t* amsg) {
		return call SubPacket.payloadLength[call SubAMPacket.type[0](amsg)](amsg);
	}
	command void Packet.setPayloadLength(message_t* amsg, uint8_t len) {
		return call SubPacket.setPayloadLength[call SubAMPacket.type[0](amsg)](amsg, len);
	}
	command uint8_t Packet.maxPayloadLength() {
		return call SubPacket.maxPayloadLength[0]();
	}
	command void* Packet.getPayload(message_t* amsg, uint8_t len) {
		return call SubPacket.getPayload[call SubAMPacket.type[0](amsg)](amsg, len);
	}

	default command void SubPacket.clear[am_id_t id](message_t* msg) { }
	default command uint8_t SubPacket.payloadLength[am_id_t id](message_t* msg) { return 0; }
	default command void SubPacket.setPayloadLength[am_id_t id](message_t* msg, uint8_t len) { }
	default command uint8_t SubPacket.maxPayloadLength[am_id_t id]() { return 0; }
	default command void* SubPacket.getPayload[am_id_t id](message_t* msg, uint8_t len) { return 0; }

}
