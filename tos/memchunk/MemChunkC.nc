/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration MemChunkC(uint8_t g_count, uint16_t g_size) {
	provides interface MemChunk;
}
implementation {

	components new MemChunkP(g_count, g_size);
	MemChunk = MemChunkP;

	components MainC;
	MainC.SoftwareInit -> MemChunkP.Init;

}
