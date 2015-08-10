/**
 * @author Raido Pahtma
 * @license MIT
*/
interface GetStruct<struct_type> {

	command error_t get(struct_type* value);

}
