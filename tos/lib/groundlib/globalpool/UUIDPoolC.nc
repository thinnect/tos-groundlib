/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "UniversallyUniqueIdentifier.h"
configuration UUIDPoolC {
	provides interface Pool<uuid_t>;
}
implementation {

	#ifndef UUID_POOL_SIZE
	#define UUID_POOL_SIZE 7
	#endif /* UUID_POOL_SIZE */

	components new PoolC(uuid_t, UUID_POOL_SIZE);
	Pool = PoolC;

}
