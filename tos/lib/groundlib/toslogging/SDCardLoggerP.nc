/**
 * Dummy component to make LocalTime.get() global
 * through _getLocalTimeRadio() function
 *
 * @author Madis Uusjärv
 * @license MIT
 */
module SDCardLoggerP
{
	uses
	{
		interface LocalTime<TRadio> as LocalTimeRadio;
	}
}

implementation
{
	uint32_t _getLocalTimeRadio() @C()
	{
		return call LocalTimeRadio.get();
	}
}
