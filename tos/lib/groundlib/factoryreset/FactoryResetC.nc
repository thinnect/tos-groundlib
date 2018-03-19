/**
 * FactoryReset core.
 *
 * @author Raido Pahtma
 * @license MIT
 */
configuration FactoryResetC {
	provides interface Reset;
	uses interface Reset as ComponentReset[uint8_t cmpnnt];
}
implementation {

	components new FactoryResetP(uniqueCount("FactoryResetHandler"));
	Reset = FactoryResetP.Reset;
	FactoryResetP.ComponentReset = ComponentReset;

	components MainC;
	MainC.SoftwareInit -> FactoryResetP.Init;

}

