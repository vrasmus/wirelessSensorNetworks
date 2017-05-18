#ifndef DPLC_RECEIVE_H
#define DPLC_RECEIVE_H

#define TOSH_DATA_LENGTH 103

enum{
	//CC2420_DEF_CHANNEL = 25,
	TIMER_PERIOD_MILLI = 500,
	AM_BLINKTORADIO = 6,
	AM_TEST_SERIAL_MSG = 0x89,
	AM_FEEDBACK_MSG = 0x42,
	SERIAL_PERIOD_MILLI = 2000,
};

typedef nx_struct TestMsg {
	nx_uint16_t nodeid;
	nx_uint8_t counter;
} TestMsg;

typedef nx_struct serialMsg {
  nx_uint16_t count;
  nx_uint8_t payloadLen;
} serialMsg;

//typedef nx_struct feedbackMsg {
//  nx_uint16_t nodeid;
//  nx_uint16_t count;
//} feedbackMsg;

#endif /* TEST_RECEIVE_H */
