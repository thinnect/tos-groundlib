/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration GlobalPoolC {
	provides interface Pool<message_t>;
}
implementation {

	#ifndef GLOBAL_MESSAGE_POOL_SIZE
	#define GLOBAL_MESSAGE_POOL_SIZE 5
	#endif /* GLOBAL_MESSAGE_POOL_SIZE */

	components new PoolC(message_t, GLOBAL_MESSAGE_POOL_SIZE);

	#ifdef GLOBAL_POOL_WRAPPER
	components GlobalPoolWrapperP;
	Pool = GlobalPoolWrapperP;
	GlobalPoolWrapperP.Sub -> PoolC;

	components MainC;
	GlobalPoolWrapperP.Boot -> MainC;
	#else
	Pool = PoolC;
	#endif /* GLOBAL_POOL_WRAPPER */

}
