/**
 * Compile-time Application UUID.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "UniversallyUniqueIdentifier.h"
module ApplicationUUIDC {
	provides interface GetStruct<uuid_t> as ApplicationUUID;
}
implementation {

	command error_t ApplicationUUID.get(uuid_t* uuid) {
		uuid->time_low = APPLICATION_UUID_TIME_LOW;
		uuid->time_mid = APPLICATION_UUID_TIME_MID;
		uuid->time_hi_and_version = APPLICATION_UUID_TIME_HI_AND_VERSION;
		uuid->clock_seq_hi_and_reserved = APPLICATION_UUID_CLOCK_SEQ_HI_AND_RESERVED;
		uuid->clock_seq_low = APPLICATION_UUID_CLOCK_SEQ_LOW;
		uuid->node[0] = APPLICATION_UUID_NODE_0;
		uuid->node[1] = APPLICATION_UUID_NODE_1;
		uuid->node[2] = APPLICATION_UUID_NODE_2;
		uuid->node[3] = APPLICATION_UUID_NODE_3;
		uuid->node[4] = APPLICATION_UUID_NODE_4;
		uuid->node[5] = APPLICATION_UUID_NODE_5;
		return SUCCESS;
	}

}
