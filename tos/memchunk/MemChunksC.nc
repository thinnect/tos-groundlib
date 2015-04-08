/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration MemChunksC {
	provides interface MemChunk;
}
implementation {

	components new MemChunkC(1, 255);
	MemChunk = MemChunkC;

}
