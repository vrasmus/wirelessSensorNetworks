#include "DplcReceive.h"

configuration DplcReceiveAppC
{
}
implementation
{
  components MainC, DplcReceiveC, LedsC;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMReceiverC(AM_BLINKTORADIO);  
  components new AMSenderC(AM_BLINKTORADIO); 
  
  components SerialActiveMessageC as Serial;
  
  
  DplcReceiveC -> MainC.Boot;

  DplcReceiveC.Timer0 -> Timer0;
  DplcReceiveC.Leds -> LedsC;
  
  DplcReceiveC.AMControl -> ActiveMessageC;
  DplcReceiveC.Receive -> AMReceiverC;
  DplcReceiveC.SendW -> AMSenderC;
  
    
  DplcReceiveC.SControl -> Serial;
  DplcReceiveC.AMSend -> Serial.AMSend[AM_TEST_SERIAL_MSG];
  DplcReceiveC.Packet -> Serial;
  
}

