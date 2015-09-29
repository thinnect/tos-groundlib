/**
 * Fragmentation and assembly functions.
 * Maximum fragment size needs to be known for assembly, all but the last fragment need to be of this size, the last one can be shorter.
 * Maximum number of fragments is 8, maximum data size is 255 bytes.
 *
 * @author Raido Pahtma
 * @license MIT
 */

#ifndef FRAGMENTER_ASSEMBLER_H_
#define FRAGMENTER_ASSEMBLER_H_

#ifndef NESC
#include <stdint.h>
#endif // NESC

/**
 * Compute the number of fragments needed to split dataSize over fragments of fragMaxSize.
 * Supports sending empty messages - returns 1 for dataSize 0.
 *
 * @param dataSize - Number of bytes to send.
 * @param fragMaxSize - Free space in one fragment.
 *
 * @return Number of fragments needed to send dataSize bytes of data.
 */
uint8_t data_fragments(uint8_t dataSize, uint8_t fragMaxSize)
{
	uint8_t frags = (uint8_t)(1 + ((((int16_t)dataSize) - 1) / fragMaxSize));
	if(frags == 0)
	{
		return 1;
	}
	return frags;
}

/**
 * @return size of fragment
 */
uint8_t data_fragmenter(uint8_t fragment[], uint8_t fragSize, uint8_t offset, uint8_t data[], uint8_t dataSize)
{
	if(offset < dataSize)
	{
		if(dataSize - offset < fragSize)
		{
			fragSize = dataSize - offset;
		}
		memcpy(fragment, &data[offset], fragSize);
		return fragSize;
	}
	return 0;
}

/**
 * @return TRUE, if assembly complete, FALSE if data still missing.
 */
bool data_assembler(uint8_t fragMaxSize, uint8_t object[], uint8_t objectSize, uint8_t fragment[], uint8_t fragSize, uint8_t offset, uint8_t* fragMap)
{
	uint8_t frag = offset / fragMaxSize;
	uint8_t frags = objectSize / fragMaxSize + (objectSize % fragMaxSize != 0 ? 1 : 0);
	uint8_t i;
	if((uint16_t)offset + fragSize <= objectSize) // (uint16_t) to make sure that offset+fragSize does not wrap
	{
		if(offset % fragMaxSize == 0)  // is properly fragmented
		{
			memcpy(&object[offset], fragment, fragSize);
			*fragMap = *fragMap | (1 << frag);
		}
	}
	for(i=0;i<frags;i++)
	{
		if((*fragMap & (1 << i)) == 0)
		{
			return FALSE; // Missing a fragment
		}
	}
	return TRUE;
}

#endif // FRAGMENTER_ASSEMBLER_H_
