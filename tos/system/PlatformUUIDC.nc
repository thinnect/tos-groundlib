/**
 * Compile-time Platform UUID.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "UniversallyUniqueIdentifier.h"
module PlatformUUIDC {
	provides interface GetStruct<uuid_t> as PlatformUUID;
}
implementation {

	command error_t PlatformUUID.get(uuid_t* uuid) {
		uuid->time_low = PLATFORM_UUID_TIME_LOW;
		uuid->time_mid = PLATFORM_UUID_TIME_MID;
		uuid->time_hi_and_version = PLATFORM_UUID_TIME_HI_AND_VERSION;
		uuid->clock_seq_hi_and_reserved = PLATFORM_UUID_CLOCK_SEQ_HI_AND_RESERVED;
		uuid->clock_seq_low = PLATFORM_UUID_CLOCK_SEQ_LOW;
		uuid->node[0] = PLATFORM_UUID_NODE_0;
		uuid->node[1] = PLATFORM_UUID_NODE_1;
		uuid->node[2] = PLATFORM_UUID_NODE_2;
		uuid->node[3] = PLATFORM_UUID_NODE_3;
		uuid->node[4] = PLATFORM_UUID_NODE_4;
		uuid->node[5] = PLATFORM_UUID_NODE_5;
		return SUCCESS;
	}

}
