/**
 * Component for setting GPIO state from Boot event.
 *
 * @author Raido Pahtma
 * @license MIT
 *
 * GPIO_MODE - TRUE for output, FALSE for input
 * GPIO_LEVEL - TRUE for set, FALSE for clr
*/
generic configuration BootGeneralIOC(char GPIO_NAME[], bool GPIO_MODE, bool GPIO_LEVEL) {
	uses {
		interface GeneralIO;
	}
}
implementation {

	components new BootGeneralIOP(GPIO_NAME, GPIO_MODE, GPIO_LEVEL);
	BootGeneralIOP.GeneralIO = GeneralIO;

	components MainC;
	BootGeneralIOP.Boot -> MainC;

}
