/*
 * Read interface that also returns the production timestamp of the data.
 *
 * Ocassionally on-demand reads may not work and the timestamp allows to have
 * the proper context of the data if the read process takes place autonomously.
 *
 * Can be wrapped around regular Read interface by returning the current time
 * in the readDone event.
 *
 * @author Raido Pahtma
 * @license MIT
*/
interface ReadTs<val_t, precision_tag> {
  /**
   * Read the value.
   *
   * @return SUCCESS if a readDone() event will be fired.
   */
  command error_t read();

  /**
   * Read completed.
   *
   * @param result SUCCESS if the read was successful
   * @param val the value
   * @param val the timestamp of the reading
   */
  event void readDone(error_t result, val_t val, uint32_t timestamp);
}
