#ifndef DEFINES_H
#define DEFINES_H

#define TOSH_DATA_LENGTH 103
#define CC2420_DEF_RFPOWER 7


enum {
	AM_BLINKTORADIO = 6,
	PAYL_ENV_ID = 13,
	REQ_ENV_ID = 42,
	DATA_LENGTH = 100,
	INTER_MESSAGE_DELAY = 50,
	PACKAGE_COUNT_REQUEST = 100
};
 
typedef nx_struct TestMsg {
	nx_uint16_t nodeid;
	nx_uint8_t counter[DATA_LENGTH-2];
} TestMsg;

#endif /* DEFINES_H */