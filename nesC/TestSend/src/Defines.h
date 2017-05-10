#ifndef DEFINES_H
#define DEFINES_H

enum {
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 250,
	TEST_ENV_ID = 13,
	NUMBER_OF_ITERATIONS = 10
};
 
typedef nx_struct TestMsg {
	nx_uint16_t nodeid;
	nx_uint8_t counter;
} TestMsg;

#endif /* DEFINES_H */