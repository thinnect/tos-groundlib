/**
 * The reset interface is used to reset stored configuration to initial values.
 *
 * @author Raido Pahtma
 * @license MIT
 */
interface Reset {

	/**
	 * The reset command.
	 */
	command error_t reset();

	/**
	 * The reset done event. An error here is cause for panic.
	 */
	event void resetDone(error_t err);

}
