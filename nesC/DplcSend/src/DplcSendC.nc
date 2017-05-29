#include "Timer.h"
#include "Defines.h"

module DplcSendC @safe()
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
 
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Receive;
}
implementation
{
	bool busy = FALSE;
	message_t pkt;
	
	uint8_t sentpacks = 0;
	
	uint8_t plen = 20;
	float e_old = 0.0;
	uint8_t plen_old = 10;
	
	uint8_t waitingForAck = 0;
	
	uint8_t consecutiveStable = 0;
	
	event void Boot.booted()
	{
		call AMControl.start();
	}
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call Timer0.startOneShot(INTER_MESSAGE_DELAY);
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
	
		if (!busy) {
			TestMsg* btrpkt = (TestMsg*)(call Packet.getPayload(&pkt, sizeof (TestMsg)));
			if (sentpacks<PACKAGE_COUNT_REQUEST && waitingForAck==0){
				btrpkt->nodeid = PAYL_ENV_ID;
				sentpacks++;
				call Leds.led2Toggle();
				if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, (sizeof (TestMsg))- DATA_LENGTH + plen) == SUCCESS) {
					busy = TRUE;
				}
			}
			else {
				btrpkt->nodeid = REQ_ENV_ID;
				sentpacks=0;
				call Leds.led1Toggle();
				if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, (sizeof (TestMsg))-98) == SUCCESS) {
					busy = TRUE;
					waitingForAck = 1;
				}
			}
		}
	}
	
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
			call Timer0.startOneShot(INTER_MESSAGE_DELAY);
		}
	}
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		//if (len == sizeof(TestMsg)) {
			
		
		TestMsg* btrpkt = (TestMsg*)payload;
		if(btrpkt->nodeid==REQ_ENV_ID){
			
			
	
			uint8_t count  =  btrpkt->counter[0];
	
			float efficiency = (plen*((float)count/PACKAGE_COUNT_REQUEST))/(plen + 11);
	
			float direction = (efficiency - e_old)*(plen-plen_old);
	
			plen_old = plen;
			e_old = efficiency;
			if(direction > 0.1 && plen != 100){
				plen = plen + 10;
			}
			else if (direction < -0.1 && plen != 10){
				plen = plen - 10;
			}
			else if (direction == 0 && consecutiveStable != 3){
				consecutiveStable++;				
				}
			else if (direction == 0 && consecutiveStable == 3)
			{
				consecutiveStable = 0;
				if (plen == 100)
				{
					plen = plen - 10;
				}
				else
				{
					plen = plen + 10;	
				}
			}
			
			waitingForAck = 0;
		}
		return msg;
	}
}