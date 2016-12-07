/**
 * Provide PCB version info defined in compile-time constants.
 * This is intended as a fallback option, when the hardware provides no way of
 * identifying its version.
 *
 * @author Raido Pahtma
 * @license MIT
 */
module PCBVersionInfoC {
	provides interface Get<semantic_version_t> as PCBVersion;
}
implementation {

	#warning "Using DEFINED PCB Verison Info"

	command semantic_version_t PCBVersion.get() {
		semantic_version_t v;
		v.major = PCB_VERSION_MAJOR;
		v.minor = PCB_VERSION_MINOR;
		v.patch = PCB_VERSION_ASSEMBLY;
		return v;
	}

}
