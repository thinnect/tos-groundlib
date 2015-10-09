/**
 * Simple module to use logging system for displaying some information right after boot.
 * @author Raido Pahtma
 * @license MIT
 */
#include "logger.h"
configuration BootInfoC { }
implementation {

	components BootInfoP;

	components MainC;
	BootInfoP.Boot -> MainC;

	components LocalIeeeEui64C;
	BootInfoP.LocalIeeeEui64 -> LocalIeeeEui64C.LocalIeeeEui64;

}
