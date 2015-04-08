/**
 * @author Elmo Trolla
 * @license MIT
*/
#ifndef __LOGGER_DEF_H__
#define __LOGGER_DEF_H__

//
// simplified version of Andrei's logging system. used in base.
//

//
// usage:
//
//   root/loglevels.h:
//
//       #ifndef LOGLEVELS_H
//       #define LOGLEVELS_H
//         // BASE_LOG_LEVEL is used as the current max log level. log level cap.
//         #define BASE_LOG_LEVEL       (LOGERROR | LOGINFO | LOGSTATE | LOGCOMMAND | LOGEVENT)
//         #define LOG_LEVEL_ModemTelit (LOGERROR | LOGINFO | LOGSTATE | LOGCOMMAND | LOGEVENT)
//       #endif
//
//
//   anywhere/ModemTelitM.nc:
//
//       #include "logger.h"
//
//       ..
//
//       impementation
//       {
//           #define __MODUUL__ "telit"
//           #define __LOG_LEVEL__ ( LOG_LEVEL_ModemTelit & BASE_LOG_LEVEL )
//           #include "logger_def.h" // instead of "log.h"
//
//           ..
//
//           logerror("ERROR\n");
//           logstate("module: state %i\n", m_state);
//           logcommand("module: command start\n");
//           logevent("module: event stopDone\n");
//           loginfo("module: everything ok so far\n");
//
//           ..
//
//           // to preserve memory
//           #if (__LOG_LEVEL__ & LOGSTATE)
//               char* STATE_STRING[] =
//               {
//                   "",
//                   "STATE_DISCONNECTED",
//                   "STATE_CONNECTING",
//                   "STATE_DISCONNECTING",
//               }
//           #endif
//
//       ..

// --------------------------------------------------------------------------

// logerror  : log errors
// logstate  : log state transitions
// logcommand: log incoming commands (public interface calls)
// logevent  : log incoming events from submodules (for example timers)
//           : but does not log event signaling from this module to outside.
// loginfo   : other random info

// --------------------------------------------------------------------------

#include "log.h"

// simplify the default logger a bit. instead of the many-many levels of loggers, we now
// have only 5, differentiated with names other than "debug, info, warn, error".

// prevent some embarrassing problems
#undef logerr

#define LOGERROR   LOG_ERR2
#define LOGSTATE   LOG_INFO1
#define LOGCOMMAND LOG_INFO2
#define LOGEVENT   LOG_INFO3
#define LOGINFO    LOG_INFO4

// do-while trick is to enable semicolons and cases where __logger unpacks
// to more than one function-call:
//
//   if (1)
//       loginfo("hello\n"); // printf("hello\n"); flush(); - this would be bad
//   else
//       logerror("bad\n");

#if (__LOG_LEVEL__ & LOGERROR)
    #define logerror(str, args...)   do { logger( LOGERROR,   str , ##args ); } while(0)
#else
    #define logerror(str, ...)
#endif
#if (__LOG_LEVEL__ & LOGSTATE)
    #define logstate(str, args...)   do { logger( LOGSTATE,   str , ##args ); } while(0)
#else
    #define logstate(str, ...)
#endif
#if (__LOG_LEVEL__ & LOGCOMMAND)
    #define logcommand(str, args...) do { logger( LOGCOMMAND, str , ##args ); } while(0)
#else
    #define logcommand(str, ...)
#endif
#if (__LOG_LEVEL__ & LOGEVENT)
    #define logevent(str, args...)   do { logger( LOGEVENT,   str , ##args ); } while(0)
#else
    #define logevent(str, ...)
#endif
#if (__LOG_LEVEL__ & LOGINFO)
    #define loginfo(str, args...)    do { logger( LOGINFO,    str , ##args ); } while(0)
#else
    #define loginfo(str, ...)
#endif


#endif // __LOGGER_DEF_H__
