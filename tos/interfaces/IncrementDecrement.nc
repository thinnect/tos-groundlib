/**
 * @author Raido Pahtma
 * @license MIT
*/
interface IncrementDecrement<value_type> {

	command void increment();

	command void decrement();

	command value_type get();

	command void set(value_type value);

}
