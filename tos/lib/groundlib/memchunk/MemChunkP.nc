/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module MemChunkP(uint8_t g_count, uint16_t g_size) {
	provides {
		interface MemChunk;
		interface Init;
	}
}
implementation {

	#define __MODUUL__ "memc"
	#define __LOG_LEVEL__ ( LOG_LEVEL_MemChunkP & BASE_LOG_LEVEL )
	#include "log.h"

	uint8_t m_mem[g_count][g_size];
	bool locked[g_count];

	command void* MemChunk.get(uint16_t length) {
		uint8_t i;
		for(i=0;i<g_count;i++)
		{
			if(locked[i] == FALSE)
			{
				if(length <= g_size)
				{
					locked[i] = TRUE;
					if(i == g_count-1) warn1("utilized %d", g_count);
					return m_mem[i];
				}
			}
		}
		warn1("depleted %d", g_count);
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
