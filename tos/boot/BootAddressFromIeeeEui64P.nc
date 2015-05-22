/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module BootAddressFromIeeeEui64P(uint8_t addr_byte_high, uint8_t addr_byte_low) {
	provides {
		interface Boot;
	}
	uses {
		interface Boot as SysBoot;
		interface LocalIeeeEui64;
		interface ActiveMessageAddress;
	}
}
implementation {

	event void SysBoot.booted()
	{
		ieee_eui64_t eui = call LocalIeeeEui64.getId();
		am_addr_t addr = ((uint16_t)(((uint8_t*)&eui)[addr_byte_high]) << 8) | ((uint8_t*)&eui)[addr_byte_low];
		if((addr != 0) && (addr != 0xFFFF))
		{
			call ActiveMessageAddress.setAddress(call ActiveMessageAddress.amGroup(), addr);
			TOS_NODE_ID = addr;
		}
		signal Boot.booted();
	}

	async event void ActiveMessageAddress.changed() { }

}
