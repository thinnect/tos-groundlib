/**
 * Convert Read to ReadTs, current time is added as timestamp.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic configuration ConvertReadToReadTsMilliC(typedef value_type @number()) {
	provides {
		interface ReadTs<value_type, TMilli>;
	}
	uses {
		interface Read<value_type>;
	}
}
implementation {

	components new ConvertReadToReadTsP(value_type, TMilli);
	ReadTs = ConvertReadToReadTsP.ReadTs;
	ConvertReadToReadTsP.Read = Read;

	components LocalTimeMilliC;
	ConvertReadToReadTsP.LocalTime -> LocalTimeMilliC;

}
