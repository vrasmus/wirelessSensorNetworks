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
		
	uint8_t pacLen = 0;
	uint8_t sentpacks = 0;
 
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
			if (sentpacks<15){
				btrpkt->nodeid = PAYL_ENV_ID;
				sentpacks++;
				call Leds.led2Toggle();
				
				call Timer0.startOneShot(INTER_MESSAGE_DELAY);
			}
			else {
				btrpkt->nodeid = REQ_ENV_ID;
				pacLen=sizeof (TestMsg)-2;
				sentpacks=0;
				call Leds.led1Toggle();
			}
			
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, (sizeof (TestMsg))-pacLen) == SUCCESS) {
				busy = TRUE;
			}
		}
	}
	
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		//if (len == sizeof(TestMsg)) {
		TestMsg* btrpkt = (TestMsg*)payload;
		if(btrpkt->nodeid==REQ_ENV_ID){
			call Leds.led0Toggle();
		}
		return msg;
	}
}