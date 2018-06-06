/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration DelayedBootC(char MY_NAME[], uint32_t delay_ms) {
	provides interface Boot as DelayedBoot;
}
implementation {

	components new DelayedBootP(MY_NAME, delay_ms);
	DelayedBoot = DelayedBootP.DelayedBoot;

	components new TimerMilliC();
	DelayedBootP.Timer -> TimerMilliC;

	components MainC;
	DelayedBootP.RealBoot -> MainC.Boot;

}
