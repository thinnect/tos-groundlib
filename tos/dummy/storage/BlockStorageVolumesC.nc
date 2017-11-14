/**
 * Dummy BlockStorage volume manager.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "Storage.h"
module BlockStorageVolumesC {
	provides {
		interface Get<storage_len_t> as GetSize[uint8_t volid];
	}
}
implementation
{

	command storage_len_t GetSize.get[uint8_t volid]() {
		switch (volid)
			{
#define VS(id, size) case id: return size;
#include "StorageVolumes.h"
			default: return 0;
			}
	}

}
