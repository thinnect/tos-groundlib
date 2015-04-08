/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module MemChunkP(uint8_t g_count, uint8_t g_size) {
	provides {
		interface MemChunk;
		interface Init;
	}
}
implementation {

	uint8_t m_mem[g_count][g_size];
	bool locked[g_count];

	command void* MemChunk.get(uint8_t length) {
		uint8_t i;
		for(i=0;i<g_count;i++)
		{
			if(locked[i] == FALSE)
			{
				if(length <= g_size)
				{
					locked[i] = TRUE;
					return m_mem[i];
				}
			}
		}
		return NULL;
	}

	command error_t MemChunk.put(void *ptr) {
		uint8_t i;
		for(i=0;i<g_count;i++)
		{
			if(ptr == m_mem[i])
			{
				locked[i] = FALSE;
				return SUCCESS;
			}
		}
		return FAIL;
	}

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<g_count;i++)
		{
			locked[i] = FALSE;
		}
		return SUCCESS;
	}

}
