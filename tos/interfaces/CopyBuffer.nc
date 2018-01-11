/**
 * Interface for requesting data to be copied to a buffer.
 *
 * @author Raido Pahtma
 * @license MIT
*/
interface CopyBuffer {

	command uint16_t get(void* buffer, uint16_t length);

}
