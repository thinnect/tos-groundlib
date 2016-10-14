/**
 * Log MCUSR on AVR platforms that do PLATFORM_MCUSR = MCUSR in bootstrap.
 * @author Raido Pahtma
 * @license MIT
 */
#include "logger.h"
configuration MCUSRInfoC { }
implementation {

#ifdef TOSSIM
	#warning "MCUSRInfoC does nothing in TOSSIM"
#else
	components MCUSRInfoP;

	components MainC;
	MCUSRInfoP.Boot -> MainC;
#endif // TOSSIM

}
