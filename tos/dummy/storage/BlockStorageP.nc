/**
 * Dummy BlockStorage that fails to read, but happily does everything else.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "Storage.h"
module BlockStorageP {
	provides {
		interface BlockWrite[uint8_t blockId];
		interface BlockRead[uint8_t blockId];
	}
	uses {
		interface Get<storage_len_t> as GetSize[uint8_t blockId];
	}
}
implementation
{

	#define __MODUUL__ "DBS"
	#define __LOG_LEVEL__ ( LOG_LEVEL_BlockStorageP & BASE_LOG_LEVEL )
	#include "log.h"

	#warning "Dummy BlockStorage"

	enum BlockStorageEvents {
		STEV_NONE,
		STEV_WD,
		STEV_RD,
		STEV_ED,
		STEV_SD,
		STEV_CD
	};

	uint8_t m_id[uniqueCount(UQ_BLOCK_STORAGE)];
	storage_addr_t m_addr[uniqueCount(UQ_BLOCK_STORAGE)];
	void* m_buf[uniqueCount(UQ_BLOCK_STORAGE)];
	storage_len_t m_length[uniqueCount(UQ_BLOCK_STORAGE)];

	task void eraseDone() {
		uint8_t i;
		for(i=0;i<uniqueCount(UQ_BLOCK_STORAGE);i++) {
			if(m_id[i] == STEV_ED) {
				m_id[i] = STEV_NONE;
				signal BlockWrite.eraseDone[i](SUCCESS);
			}
		}
	}

	command error_t BlockWrite.erase[uint8_t id]() {
		debug1("erase[%d]()", id);
		if(m_id[id] == STEV_NONE){
			m_id[id] = STEV_ED;
			post eraseDone();
			return SUCCESS;
		}
		return EBUSY;
	}

	task void writeDone() {
		uint8_t i;
		for(i=0;i<uniqueCount(UQ_BLOCK_STORAGE);i++) {
			if(m_id[i] == STEV_WD) {
				m_id[i] = STEV_NONE;
				signal BlockWrite.writeDone[i](m_addr[i], m_buf[i], m_length[i], SUCCESS);
			}
		}
	}

	command error_t BlockWrite.write[uint8_t id](storage_addr_t addr, void* buf, storage_len_t len) {
		debug1("write[%d](%"PRIu32",%p,%"PRIu32")", id, addr, buf, len);
		if(m_id[id] == STEV_NONE) {
			m_id[id] = STEV_WD;
			m_addr[id] = addr;
			m_buf[id] = buf;
			m_length[id] = len;
			post writeDone();
			return SUCCESS;
		}
		return EBUSY;
	}

	task void syncDone() {
		uint8_t i;
		for(i=0;i<uniqueCount(UQ_BLOCK_STORAGE);i++) {
			if(m_id[i] == STEV_SD) {
				m_id[i] = STEV_NONE;
				signal BlockWrite.syncDone[i](SUCCESS);
			}
		}
	}

	command error_t BlockWrite.sync[uint8_t id]() {
		debug1("sync[%d]()", id);
		if(m_id[id] == STEV_NONE) {
			m_id[id] = STEV_SD;
			post syncDone();
			return SUCCESS;
		}
		return EBUSY;
	}

	task void readDone() {
		uint8_t i;
		for(i=0;i<uniqueCount(UQ_BLOCK_STORAGE);i++) {
			if(m_id[i] == STEV_RD) {
				m_id[i] = STEV_NONE;
				signal BlockRead.readDone[i](m_addr[i], m_buf[i], m_length[i], FAIL);
			}
		}
	}

	command error_t BlockRead.read[uint8_t id](storage_addr_t addr, void* buf, storage_len_t len) {
		debug1("read[%d](%"PRIu32",%p,%"PRIu32")", id, addr, buf, len);
		if(m_id[id] == STEV_NONE) {
			m_id[id] = STEV_RD;
			m_addr[id] = addr;
			m_buf[id] = buf;
			m_length[id] = len;
			post readDone();
			return SUCCESS;
		}
		return EBUSY;
	}

	task void computeCrcDone() {
		uint8_t i;
		for(i=0;i<uniqueCount(UQ_BLOCK_STORAGE);i++) {
			if(m_id[i] == STEV_CD) {
				m_id[i] = STEV_NONE;
				signal BlockRead.computeCrcDone[i](m_addr[i], m_length[i], 0, FAIL);
			}
		}
	}

	command error_t BlockRead.computeCrc[uint8_t id](storage_addr_t addr, storage_len_t len, uint16_t basecrc) {
		debug1("crc[%d](%"PRIu32",%"PRIu32",%d)", id, addr, len, basecrc);
		if(m_id[id] == STEV_NONE) {
			m_id[id]= STEV_CD;
			m_addr[id] = addr;
			m_length[id] = len;
			post computeCrcDone();
			return SUCCESS;
		}
		return EBUSY;
	}

	command storage_len_t BlockRead.getSize[uint8_t blockId]() {
		return call GetSize.get[blockId]();
	}

	default command storage_len_t GetSize.get[uint8_t blockId]() { return 0; }

	default event void BlockWrite.writeDone[uint8_t id](storage_addr_t addr, void* buf, storage_len_t len, error_t result) { }
	default event void BlockWrite.eraseDone[uint8_t id](error_t result) { }
	default event void BlockWrite.syncDone[uint8_t id](error_t result) { }
	default event void BlockRead.readDone[uint8_t id](storage_addr_t addr, void* buf, storage_len_t len, error_t result) { }
	default event void BlockRead.computeCrcDone[uint8_t id](storage_addr_t addr, storage_len_t len, uint16_t x, error_t result) { }

}
