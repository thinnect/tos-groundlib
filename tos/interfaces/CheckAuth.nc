/**
 * Simple interface for checking a provided token against a stored
 * authentication token.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
interface CheckAuth {

	// Check if the authentication token matches the stored token
	// Returns FALSE, when stored token is empty
	command bool good(uint8_t* auth, uint8_t length);

	// Allow checking for empty tokens (uninitialized state)
	command bool empty();

}
