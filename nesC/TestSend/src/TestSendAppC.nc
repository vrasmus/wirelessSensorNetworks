#include <Timer.h>
#include "Defines.h"

configuration TestSendAppC
{
}
implementation
{
  components MainC, TestSendC, LedsC;
  components new TimerMilliC() as Timer0;

  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);

  TestSendC -> MainC.Boot;

  TestSendC.Timer0 -> Timer0;
  TestSendC.Leds -> LedsC;
  
  TestSendC.Packet -> AMSenderC;
  TestSendC.AMPacket -> AMSenderC;
  TestSendC.AMSend -> AMSenderC;
  TestSendC.AMControl -> ActiveMessageC;
}

