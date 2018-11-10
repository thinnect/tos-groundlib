/**
 * Client configuration for platform light sensor.
 *
 * @author Raido Pahtma
 * @license MIT
 */
generic configuration PlatformLightSensorClientC() {
	provides interface Read<uint32_t>;
}
implementation {

	components PlatformLightSensorC;
	Read = PlatformLightSensorC.Read[unique("PlatformLightSensorClientC")];

}
