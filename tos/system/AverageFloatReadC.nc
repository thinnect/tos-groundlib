/**
 * Periodically sample the SubRead interface, return average and reset when
 * Read called. Starts after initial Read.
 *
 * @author Raido Pahtma
 * @license MIT
 **/
generic configuration AverageFloatReadC(uint32_t period_s, uint32_t period_ms) {
	provides interface Read<float>;
	uses interface Read<float> as SubRead;
}
implementation {

	components new AverageFloatReadP(period_s, period_ms);
	Read = AverageFloatReadP.Read;
	AverageFloatReadP.SubRead = SubRead;

	components new TimerMilliC();
	AverageFloatReadP.Timer -> TimerMilliC;

}
