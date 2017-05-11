#include "TestReceive.h"

configuration TestReceiveAppC
{
}
implementation
{
  components MainC, TestReceiveC, LedsC;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMReceiverC(AM_BLINKTORADIO);  
  components SerialActiveMessageC as Serial;
  
  
  TestReceiveC -> MainC.Boot;

  TestReceiveC.Timer0 -> Timer0;
  TestReceiveC.Leds -> LedsC;
  
  TestReceiveC.AMControl -> ActiveMessageC;
  TestReceiveC.Receive -> AMReceiverC;
    
  TestReceiveC.SControl -> Serial;
  //App.Receive -> AM.Receive[AM_TEST_SERIAL_MSG];
  TestReceiveC.AMSend -> Serial.AMSend[AM_TEST_SERIAL_MSG];
  TestReceiveC.Packet -> Serial;
  
}

