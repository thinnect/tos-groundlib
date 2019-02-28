/**
 * Dummy configuration to make LocalTime.get() global
 * through _getLocalTimeRadio() function
 *
 * @author Madis Uusjärv
 * @license MIT
 */
configuration SDCardLoggerC
{
}

implementation
{
	components ActiveMessageC as RadioC;
	components SDCardLoggerP;

	SDCardLoggerP.LocalTimeRadio -> RadioC.LocalTimeRadio;
}
