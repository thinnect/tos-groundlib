/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration GlobalPoolC {
	provides interface Pool<message_t>;
}
implementation {

	#ifndef GLOBAL_MESSAGE_POOL_SIZE
	#define GLOBAL_MESSAGE_POOL_SIZE 7
	#else GLOBAL_MESSAGE_POOL_SIZE defined externally
	#endif /* GLOBAL_MESSAGE_POOL_SIZE */

	components new ClearMessagePoolP();
	Pool = ClearMessagePoolP.Pool;

	components new PoolC(message_t, GLOBAL_MESSAGE_POOL_SIZE);
	ClearMessagePoolP.SubPool -> PoolC;

	components ActiveMessageC;
	ClearMessagePoolP.Packet -> ActiveMessageC;

	components MainC;
	ClearMessagePoolP.Boot -> MainC;

}
