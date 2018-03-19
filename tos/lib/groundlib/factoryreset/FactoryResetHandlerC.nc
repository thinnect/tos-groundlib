/**
 * FactoryReset handler.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic configuration FactoryResetHandlerC() {
	uses interface Reset;
}
implementation {

	components FactoryResetC;
	FactoryResetC.ComponentReset[unique("FactoryResetHandler")] = Reset;

}
