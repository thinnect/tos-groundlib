/**
 * @author Raido Pahtma
 * @license MIT
*/
interface MemChunk {

	command void* get(uint16_t length);

	command error_t put(void* ptr);

}
