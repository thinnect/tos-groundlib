/**
 * @author Raido Pahtma
 * @license MIT
*/
interface Calculate<output_type, input_type> {

	command output_type calculate(input_type value);

}
