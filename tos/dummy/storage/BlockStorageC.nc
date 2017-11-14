/**
 * Dummy BlockStorage that fails to read, but happily does everything else.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "Storage.h"
generic configuration BlockStorageC(volume_id_t volid) {
	provides {
		interface BlockWrite;
		interface BlockRead;
	}
}
implementation {

	#warning "Dummy BlockStorage"

	enum {
		BLOCK_ID = unique(UQ_BLOCK_STORAGE) + uniqueCount(UQ_CONFIG_STORAGE),
	};

	components BlockStorageP;
	BlockWrite = BlockStorageP.BlockWrite[BLOCK_ID];
	BlockRead = BlockStorageP.BlockRead[BLOCK_ID];

	components BlockStorageVolumesC;
	BlockStorageP.GetSize[BLOCK_ID] -> BlockStorageVolumesC.GetSize[volid];
}
