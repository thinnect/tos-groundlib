/**
 * FixedActiveMessageAddressC is a read-only ActiveMessageAddressC.
 *
 * @author Raido Pahtma
 * @license MIT
 */
module FixedActiveMessageAddressC {
	provides {
		interface ActiveMessageAddress;
	}
	uses {
		interface ActiveMessageAddress as RealActiveMessageAddress;
	}
}
implementation {

	async command am_addr_t ActiveMessageAddress.amAddress() {
		return call RealActiveMessageAddress.amAddress();
	}

	async command am_group_t ActiveMessageAddress.amGroup() {
		return call RealActiveMessageAddress.amGroup();
	}

	async command void ActiveMessageAddress.setAddress(am_group_t myGroup, am_addr_t myAddr) { }
	default async event void ActiveMessageAddress.changed() { }

	async event void RealActiveMessageAddress.changed() { }

}
