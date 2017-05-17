#include "Timer.h"
#include "Defines.h"

module TestSendC @safe()
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
	
	uint8_t pacLen = 0;
 
	event void Boot.booted()
	{
		call AMControl.start();
	}
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call Timer0.startOneShot(100);
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
	
		if (!busy && sentMessages<NUMBER_OF_BULK_MESSAGES) {
			TestMsg* btrpkt = (TestMsg*)(call Packet.getPayload(&pkt, sizeof (TestMsg)));
			btrpkt->nodeid = TEST_ENV_ID;
			
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, (sizeof (TestMsg))-pacLen) == SUCCESS) {
				busy = TRUE;
			}
	
			sentMessages++;
			call Leds.led2Toggle();
	
			call Timer0.startOneShot(INTER_MESSAGE_DELAY);
		}
		else
		{
			if(pacLen < 90)
			{
				call Timer0.startOneShot(INTER_BULK_DELAY);
				pacLen = pacLen + 10;
				sentMessages = 0;
			}
			else
			{
				call Leds.led1Toggle();
			}
	
		}
	}
	
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
}

