#include "Timer.h"
#include "Defines.h"

module BlinkC @safe()
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
 
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
}
implementation
{
	bool busy = FALSE;
	message_t pkt;
	
	uint16_t sentMessages = 0;
 
	event void Boot.booted()
	{
		call AMControl.start();
	}
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		else {
			call AMControl.start();
		}
	}
	
	event void AMControl.stopDone(error_t err) {
	}
 
	//
	event void Timer0.fired()
	{
	
		if (!busy && sentMessages<NUMBER_OF_ITERATIONS) {
			TestMsg* btrpkt = (TestMsg*)(call Packet.getPayload(&pkt, sizeof (TestMsg)));
			btrpkt->nodeid = TEST_ENV_ID;
			btrpkt->counter = 42;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TestMsg)) == SUCCESS) {
				busy = TRUE;
			}
			
			sentMessages++;
			call Leds.led2Toggle();
		}
	}
	
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
}

