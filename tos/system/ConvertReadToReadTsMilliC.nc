/**
 * Convert Read to ReadTs, current time is added as timestamp.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic module ConvertReadToReadTsMilliC(typedef value_type @number()) {
	provides {
		interface ReadTs<value_type, TMilli>;
	}
	uses {
		interface Read<value_type>;
	}
}
implementation {

	components new ConvertReadToReadTsMilliP(value_type, TMilli);
	ReadTs = ConvertReadToReadTsMilliP.ReadRs;
	ConvertReadToReadTsMilliP.Read = Read;

	components LocalTimeMilliC;
	ConvertReadToReadTsMilliP.LocalTime -> LocalTimeMilliC;

}
