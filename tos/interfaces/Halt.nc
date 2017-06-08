/**
 * The halt interface is used to indicate an impending unavoidable system halt.
 *
 * @author Raido Pahtma
 * @license MIT
 */
interface Halt {

	/**
	 * The halt event, may be fired several times before grace period runs out.
	 * The signal receiver can indicate a busy state by returning EBUSY and
	 * should indicate readiness for halt by returning SUCCESS.
	 */
	event error_t halt(uint32_t grace_period);

}
