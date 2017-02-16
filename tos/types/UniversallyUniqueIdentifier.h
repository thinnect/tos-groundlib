/**
 * Data types and manipulation functions for UUID's.
 * @author Raido Pahtma
 * @license MIT
*/
#ifndef UNIVERSALLYUNIQUEIDENTIFIER_H_
#define UNIVERSALLYUNIQUEIDENTIFIER_H_

typedef struct uuid {
	uint32_t time_low;
	uint16_t time_mid;
	uint16_t time_hi_and_version;
	uint8_t  clock_seq_hi_and_reserved;
	uint8_t  clock_seq_low;
	uint8_t  node[6];
} uuid_t;

typedef nx_struct nx_uuid {
	nx_uint32_t time_low;
	nx_uint16_t time_mid;
	nx_uint16_t time_hi_and_version;
	nx_uint8_t  clock_seq_hi_and_reserved;
	nx_uint8_t  clock_seq_low;
	nx_uint8_t  node[6];
} nx_uuid_t;

nx_uuid_t* hton_uuid(nx_uuid_t* net_uuid, uuid_t* host_uuid) {
	net_uuid->time_low = host_uuid->time_low;
	net_uuid->time_mid = host_uuid->time_mid;
	net_uuid->time_hi_and_version = host_uuid->time_hi_and_version;
	net_uuid->clock_seq_hi_and_reserved = host_uuid->clock_seq_hi_and_reserved;
	net_uuid->clock_seq_low = host_uuid->clock_seq_low;
	memcpy(net_uuid->node, host_uuid->node, 6);
	return net_uuid;
}

uuid_t* ntoh_uuid(uuid_t* host_uuid, nx_uuid_t* net_uuid) {
	host_uuid->time_low = net_uuid->time_low;
	host_uuid->time_mid = net_uuid->time_mid;
	host_uuid->time_hi_and_version = net_uuid->time_hi_and_version;
	host_uuid->clock_seq_hi_and_reserved = net_uuid->clock_seq_hi_and_reserved;
	host_uuid->clock_seq_low = net_uuid->clock_seq_low;
	memcpy(host_uuid->node, net_uuid->node, 6);
	return host_uuid;
}

#endif // UNIVERSALLYUNIQUEIDENTIFIER_H_
