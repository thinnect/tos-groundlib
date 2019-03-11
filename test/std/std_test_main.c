
#include "loglevels.h"
#define __MODUUL__ "main"
#define __LOG_LEVEL__ ( LOG_LEVEL_main & BASE_LOG_LEVEL )
#include "log.h"

int main() {

	debug1("debug1");
	debug1("debug2");
	debug1("debug3");
	debug1("debug4");
	info1("info1");
	info1("info2");
	info1("info3");
	info1("info4");
	warn1("warn1");
	warn1("warn2");
	warn1("warn3");
	warn1("warn4");
	err1("err1");
	err1("err2");
	err1("err3");
	err1("err4");

	return 0;
}

