/**
 * Generic freeze frame structure and status codes.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#ifndef FREEZE_FRAME_DATA_H_
#define FREEZE_FRAME_DATA_H_

enum FreezeFrameState {
  FF_NONE,     // No issues, just a run-time snapshot
  FF_FAULT,    // Fault occurred, but system recovered
  FF_DEGRADED, // System is operating in a degraded state
  FF_FAILURE,  // System has failed
};

typedef struct freeze_frame_data {
  uint8_t  status;
  uint32_t timestamp;
  uint8_t  length;
  uint8_t* data;
} freeze_frame_data_t;

#endif // FREEZE_FRAME_DATA_H_
