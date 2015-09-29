/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration BootAddressFromIeeeEui64C(uint8_t addr_byte_high, uint8_t addr_byte_low) {
	provides {
		interface Boot;
	}
	uses {
		interface Boot as SysBoot;
	}
}
implementation {

	components new BootAddressFromIeeeEui64P(addr_byte_high, addr_byte_low);
	BootAddressFromIeeeEui64P.SysBoot = SysBoot;
	Boot = BootAddressFromIeeeEui64P.Boot;

	components ActiveMessageAddressC;
	BootAddressFromIeeeEui64P.ActiveMessageAddress -> ActiveMessageAddressC;

	components LocalIeeeEui64C;
	BootAddressFromIeeeEui64P.LocalIeeeEui64 -> LocalIeeeEui64C;

}
