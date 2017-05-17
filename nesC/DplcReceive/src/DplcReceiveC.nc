#include "Timer.h"
#include "DplcReceive.h"

module DplcReceiveC @safe()
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
 
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface AMSend as SendW;
 
	uses interface SplitControl as SControl;
	uses interface AMSend;
	uses interface Packet;
}
implementation
{
	uint8_t PRRCount;
	uint8_t PLen;
	bool locked = FALSE;
	bool lockedW = FALSE;
	message_t countMsg1;
	
	event void Boot.booted(){
		PRRCount = 0;
		PLen = 255;
		call AMControl.start();
		call SControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			//call Timer0.startPeriodic(TIMER_PERIOD_MILLI);	
		} else {
			call AMControl.start();
		}
	}
	
	
	event void AMControl.stopDone(error_t err){
	}
	
	
	event void SControl.startDone(error_t err) {
		if (err == SUCCESS) {
			//call Timer0.startOneShot(2000);
			call Timer0.startPeriodic(SERIAL_PERIOD_MILLI);
		} else {
			call SControl.start();
		}
	}
	
	event void SControl.stopDone(error_t err){
	}

	event void Timer0.fired()
	{
		dbg("BlinkC", "Timer 0 fired @ %s.\n", sim_time_string());
		//  call Leds.led0Toggle();
		//  call Leds.led1Toggle();
		call Leds.led1Toggle();
 
		if (locked) {
			return;
		}
		else {
			//		serialMsg sendMe = (serialMsg){PRRCount};
			message_t sendMe;
			serialMsg * countMsg = (serialMsg *)call Packet.getPayload(&sendMe, sizeof(serialMsg));
			countMsg->count = PRRCount;
			countMsg->payloadLen = PLen;
			if (call AMSend.send(AM_BROADCAST_ADDR, &sendMe, sizeof(serialMsg)) == SUCCESS) {
				locked = TRUE;
			}
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		//if (len == sizeof(TestMsg)) {
		TestMsg* btrpkt = (TestMsg*)payload;
		if(btrpkt->nodeid==13){//magic number set on transmitter.
			call Leds.led0Toggle();
			//    	PLen = call Packet.payloadLength(msg);
			PLen = len;
			PRRCount++;
			//}
		} else if(btrpkt->nodeid==42){//PRR Count Request id
			if (lockedW) {
				return msg;
			}
			else {
				TestMsg * countReqMsg = (TestMsg *)call Packet.getPayload(&countMsg1, sizeof(TestMsg));
				countReqMsg->nodeid = 42;
				countReqMsg->counter = PRRCount;
				if (call SendW.send(AM_BROADCAST_ADDR, &countMsg1, sizeof(TestMsg)) == SUCCESS) {
					lockedW = TRUE;
					PRRCount = 0;					
				}
			}
		}
		return msg;
	}

	event void SendW.sendDone(message_t* bufPtr, error_t error) {
		lockedW = FALSE;
		call Leds.led2Toggle();
	}

	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		locked = FALSE;
	}
}


