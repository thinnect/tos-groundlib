/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration DummyBootC() {
	provides interface Boot;
	uses interface Boot as SysBoot;
}
implementation {

	Boot = SysBoot;

}
