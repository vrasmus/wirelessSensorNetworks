#ifndef DEFINES_H
#define DEFINES_H

#define TOSH_DATA_LENGTH 103

enum {
	AM_BLINKTORADIO = 6,
	TEST_ENV_ID = 13,
	NUMBER_OF_BULK_MESSAGES = 1000,
	DATA_LENGTH = 100,
	INTER_BULK_DELAY = 5000,
	INTER_MESSAGE_DELAY = 50
};
 
typedef nx_struct TestMsg {
	nx_uint16_t nodeid;
	nx_uint8_t counter[DATA_LENGTH-2];
} TestMsg;

#endif /* DEFINES_H */