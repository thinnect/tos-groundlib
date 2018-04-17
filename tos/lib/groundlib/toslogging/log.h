/**
 * @author Andrei Lunjov, Raido Pahtma, Andres Vahter
 * @license MIT
*/
#ifndef LOG_H
#define LOG_H

#ifndef __MODUUL__
	#warning no __MODUUL__ defined, using __FILE__
	#define __MODUUL__ __FILE__
#endif

#ifndef TOSSIM
	#define STATIC_CONST static const
#else
	#define STATIC_CONST
#endif

#define LOG_DEBUG4       0x0001
#define LOG_DEBUG3       0x0002
#define LOG_DEBUG2       0x0004
#define LOG_DEBUG1       0x0008

#define LOG_INFO4        0x0010
#define LOG_INFO3        0x0020
#define LOG_INFO2        0x0040
#define LOG_INFO1        0x0080

#define LOG_WARN4        0x0100
#define LOG_WARN3        0x0200
#define LOG_WARN2        0x0400
#define LOG_WARN1        0x0800

#define LOG_ERR4         0x1000
#define LOG_ERR3         0x2000
#define LOG_ERR2         0x4000
#define LOG_ERR1         0x8000

#define LOG_LEVEL_DEBUG  0xFFFF
#define LOG_LEVEL_INFO   0xFFF0
#define LOG_LEVEL_WARN   0xFF00
#define LOG_LEVEL_ERR    0xF000

#define LOG_LEVEL_ASSERT LOG_ERR4
#define LOG_LEVEL_NANOEVENT LOG_DEBUG4

// these triple macros enable us to use something like this:
// uartqueue_putstr("E| " ## __LINE_STRING__ ## "\n");
#define STRINGIZE(x) STRINGIZE2(x)
#define STRINGIZE2(x) #x
#define __LINE_STRING__ STRINGIZE(__LINE__)

#if defined(__LOG_LEVEL__) && __LOG_LEVEL__!=0
	#define logger(severity, str, args...)				({\
		if( (severity) & __LOG_LEVEL__){ \
			STATIC_CONST char moduulROM[] PROGMEM = __MODUUL__;	\
			STATIC_CONST char strROM[] PROGMEM = str;	\
			__logger( severity, moduulROM, __LINE__, strROM , ##args ); 	\
		}	\
	})

	#define nanologger(severity, str, args...)			({\
		if( (severity) & __LOG_LEVEL__){ \
			STATIC_CONST char strROM[] PROGMEM = str;	\
			__nanologger( strROM , ##args ); 	\
		}	\
	})

	#define loggerb(severity, str, data, len, args...)	({	\
		if( (severity) & __LOG_LEVEL__){\
			STATIC_CONST char moduulROM[] PROGMEM = __MODUUL__;	\
			STATIC_CONST char strROM[] PROGMEM = str;	\
			__loggerb( severity, moduulROM, __LINE__, strROM, data, len , ##args  );	\
		}	\
	})

	#define loggerb2(severity, str1, data1, len1, str2, data2, len2 , args...  )	({	\
		if( (severity) & __LOG_LEVEL__){\
			STATIC_CONST char moduulROM[] PROGMEM = __MODUUL__;	\
			STATIC_CONST char str1ROM[] PROGMEM = str1;	\
			STATIC_CONST char str2ROM[] PROGMEM = str2;	\
			__loggerb2( severity, moduulROM, __LINE__, str1ROM, data1, len1, str2ROM, data2, len2, ##args  );	\
		}	\
	})

	#define loggerd(severity, def, args...)				({	\
		if( (severity) & __LOG_LEVEL__){	\
			STATIC_CONST char moduulROM[] PROGMEM = __MODUUL__;	\
			logger##def( severity, moduulROM, __LINE__ , ##args );	\
		}	\
	})

	#define loggerds(severity, def, str, args...)				({	\
		if( (severity) & __LOG_LEVEL__){	\
			STATIC_CONST char moduulROM[] PROGMEM = __MODUUL__;	\
			STATIC_CONST char strROM[] PROGMEM = str;	\
			logger##def( severity, moduulROM, __LINE__ , strROM, ##args );	\
		}	\
	})
#else
	#define logger(severity, str, args...)
	#define nanologger(str, args...)
	#define loggerb(severity, str, data, len, args...)
	#define loggerb2(severity, str1, data1, len1, str2, data2, len2, args...)
	#define loggerd(severity, def, args...)
	#define loggerds(severity, def, str, args...)

	#define uartqueue_putstr(str)
	#define uartqueue_putbuf(buf, len)
	#define uartqueue_putbufhex(buf, len)

#endif

#ifdef debug
	#undef debug
#endif

#define nanoevent(str, args...)				nanologger( LOG_DEBUG4, str , ##args )

#define debug(str, args...)					logger( LOG_DEBUG2, str , ##args )
#define debugb(str, data, len, args...)		loggerb( LOG_DEBUG2, str, data, len , ##args )
#define debugd(def, args...)				loggerd( LOG_DEBUG2, def, ##args )
#define debugds(def, str, args...)			loggerds( LOG_DEBUG2, def, str, ##args )

#define debug1(str, args...)				logger( LOG_DEBUG1, str , ##args )
#define debugb1(str, data, len, args...)	loggerb( LOG_DEBUG1, str, data, len , ##args )
#define debugd1(def, args...)				loggerd( LOG_DEBUG1, def, ##args )
#define debugds1(def, str, args...)			loggerds( LOG_DEBUG1, def, str, ##args )

#define debug2(str, args...)				logger( LOG_DEBUG2, str , ##args )
#define debugb2(str, data, len, args...)	loggerb( LOG_DEBUG2, str, data, len , ##args )
#define debugd2(def, args...)				loggerd( LOG_DEBUG2, def, ##args )
#define debugds2(def, str, args...)			loggerds( LOG_DEBUG2, def, str, ##args )

#define debug3(str, args...)				logger( LOG_DEBUG3, str , ##args )
#define debugb3(str, data, len, args...)	loggerb( LOG_DEBUG3, str, data, len , ##args )
#define debugd3(def, args...)				loggerd( LOG_DEBUG3, def, ##args )
#define debugds3(def, str, args...)			loggerds( LOG_DEBUG3, def, str, ##args )

#define debug4(str, args...)				logger( LOG_DEBUG4, str , ##args )
#define debugb4(str, data, len, args...)	loggerb( LOG_DEBUG4, str, data, len , ##args )
#define debugd4(def, args...)				loggerd( LOG_DEBUG4, def, ##args )
#define debugds4(def, str, args...)			loggerds( LOG_DEBUG4, def, str, ##args )


#define info(str, args...)				logger( LOG_INFO2, str , ##args )
#define infob(str, data, len, args...)	loggerb( LOG_INFO2, str, data, len , ##args )
#define infod(def, args...)				loggerd( LOG_INFO2, def, ##args )
#define infods(def, str, args...)		loggerds( LOG_INFO2, def, str, ##args )

#define info1(str, args...)				logger( LOG_INFO1, str , ##args )
#define infob1(str, data, len, args...)	loggerb( LOG_INFO1, str, data, len , ##args )
#define infod1(def, args...)			loggerd( LOG_INFO1, def, ##args )
#define infods1(def, str, args...)		loggerds( LOG_INFO1, def, str, ##args )

#define info2(str, args...)				logger( LOG_INFO2, str , ##args )
#define infob2(str, data, len, args...)	loggerb( LOG_INFO2, str, data, len , ##args )
#define infod2(def, args...)			loggerd( LOG_INFO2, def, ##args )
#define infods2(def, str, args...)		loggerds( LOG_INFO2, def, str, ##args )

#define info3(str, args...)				logger( LOG_INFO3, str , ##args )
#define infob3(str, data, len, args...)	loggerb( LOG_INFO3, str, data, len , ##args )
#define infod3(def, args...)			loggerd( LOG_INFO3, def, ##args )
#define infods3(def, str, args...)		loggerds( LOG_INFO3, def, str, ##args )

#define info4(str, args...)				logger( LOG_INFO4, str , ##args )
#define infob4(str, data, len, args...)	loggerb( LOG_INFO4, str, data, len , ##args )
#define infod4(def, args...)			loggerd( LOG_INFO4, def, ##args )
#define infods4(def, str, args...)		loggerds( LOG_INFO4, def, str, ##args )


#define warn(str, args...)				logger( LOG_WARN2, str , ##args )
#define warnb(str, data, len, args...)	loggerb( LOG_WARN2, str, data, len , ##args )
#define warnd(def, args...)				loggerd( LOG_WARN2, def, ##args )
#define warnds(def, str, args...)		loggerds( LOG_WARN2, def, str, ##args )

#define warn1(str, args...)				logger( LOG_WARN1, str , ##args )
#define warnb1(str, data, len, args...)	loggerb( LOG_WARN1, str, data, len , ##args )
#define warnd1(def, args...)			loggerd( LOG_WARN1, def, ##args )
#define warnds1(def, str, args...)		loggerds( LOG_WARN1, def, str, ##args )

#define warn2(str, args...)				logger( LOG_WARN2, str , ##args )
#define warnb2(str, data, len, args...)	loggerb( LOG_WARN2, str, data, len , ##args )
#define warnd2(def, args...)			loggerd( LOG_WARN2, def, ##args )
#define warnds2(def, str, args...)		loggerds( LOG_WARN2, def, str, ##args )

#define warn3(str, args...)				logger( LOG_WARN3, str , ##args )
#define warnb3(str, data, len, args...)	loggerb( LOG_WARN3, str, data, len , ##args )
#define warnd3(def, args...)			loggerd( LOG_WARN3, def, ##args )
#define warnds3(def, str, args...)		loggerds( LOG_WARN3, def, str, ##args )

#define warn4(str, args...)				logger( LOG_WARN4, str , ##args )
#define warnb4(str, data, len, args...)	loggerb( LOG_WARN4, str, data, len , ##args )
#define warnd4(def, args...)			loggerd( LOG_WARN4, def, ##args )
#define warnds4(def, str, args...)		loggerds( LOG_WARN4, def, str, ##args )


#define logerr(str, args...)				logger( LOG_ERR2, str , ##args )
#define logerrb(str, data, len, args...)	loggerb( LOG_ERR2, str, data, len , ##args )
#define logerrd(def, args...)				loggerd( LOG_ERR2, def, ##args )
#define logerrds1(def, str, args...)		loggerds( LOG_ERR2, def, str, ##args )

#define err1(str, args...)				logger( LOG_ERR1, str , ##args )
#define errb1(str, data, len, args...)	loggerb( LOG_ERR1, str, data, len , ##args )
#define errd1(def, args...)				loggerd( LOG_ERR1, def, ##args )
#define errds1(def, str, args...)		loggerds( LOG_ERR1, def, str, ##args )

#define err2(str, args...)				logger( LOG_ERR2, str , ##args )
#define errb2(str, data, len, args...)	loggerb( LOG_ERR2, str, data, len , ##args )
#define errd2(def, args...)				loggerd( LOG_ERR2, def, ##args )
#define errds2(def, str, args...)		loggerds( LOG_ERR2, def, str, ##args )

#define err3(str, args...)				logger( LOG_ERR3, str , ##args )
#define errb3(str, data, len, args...)	loggerb( LOG_ERR3, str, data, len , ##args )
#define errd3(def, args...)				loggerd( LOG_ERR3, def, ##args )
#define errds3(def, str, args...)		loggerds( LOG_ERR3, def, str, ##args )

#define err4(str, args...)				logger( LOG_ERR4, str , ##args )
#define errb4(str, data, len, args...)	loggerb( LOG_ERR4, str, data, len , ##args )
#define errd4(def, args...)				loggerd( LOG_ERR4, def, ##args )
#define errds4(def, str, args...)		loggerds( LOG_ERR4, def, str, ##args )

#endif // LOG_H
