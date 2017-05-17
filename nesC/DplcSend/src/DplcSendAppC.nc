configuration DplcSendAppC
{
}
implementation
{
  components MainC, DplcSendC, LedsC;
  components new TimerMilliC() as Timer0;

  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);
  components new AMReceiverC(AM_BLINKTORADIO); 

  DplcSendC -> MainC.Boot;

  DplcSendC.Timer0 -> Timer0;
  DplcSendC.Leds -> LedsC;
  
  DplcSendC.Packet -> AMSenderC;
  DplcSendC.AMPacket -> AMSenderC;
  DplcSendC.AMSend -> AMSenderC;
  DplcSendC.AMControl -> ActiveMessageC;
  DplcSendC.Receive -> AMReceiverC;
}

