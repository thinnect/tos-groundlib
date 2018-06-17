/**
 * SystemControl interface.
 *
 * @author Raido Pahtma
 * @license MIT
*/
interface SystemControl {

	/**
	 * @param grace_period - request services to close down within the allocated grace_period.
	 * @return Services should return SUCCESS if ready to close down.
	 */
	command error_t signalHalt(uint32_t grace_period);

	/**
	 * @param force - reboot immediately without signalling halt event.
	 */
	command void reboot(bool force);

}
