---
layout: post
title: Cisco CSIM command (call simulation)
tags: [cisco]
---
`CSIM` is an undocumented IOS command.  When configuring a router to act as a voice gateway it is possible to test outbound calls by originating calls from the router.  If the router is configured correctly then the far end number will ring and can be answered.
<!--more-->
 Use the `csim start dialstring` hidden command to initiate simulated calls to whichever real-world E.164 number is desired. This allows you to determine whether you can properly go offhook from the router to the PSTN, send digits, and complete a call to the destination phone. You can modify the POTS dial-peer appropriately to account for long-distance access codes and other prefixed digits as necessary. In the example below, the POTS dial-peer can match on any string of digits starting with “9”, and all digits that follow the “9” are played out voice-port X/Y/Z.

```

dial-peer voice 1 pots
destination-pattern 9T
port 1/0:0

r1# csim start 918005551212

csim: called number = 18005551212, loop count = 1 ping count = 0

csim err csimDisconnected recvd DISC cid(28)

csim: loop = 1, failed = 1   csim: call attempted = 1, setup failed = 1, tone failed = 0

```

Despite the call working in this case CSIM will always display `failed=1`.  There is no real explanation for this.  CSIM can also be used with PRI, CAS, and if calls are not completing it is recommended to begin analyzing the call flow using debug commands. For example debug isdn q931 will show the Tx and Rx messages (including ISDN Cause Codes) between the local router and the far end TDM equipment.

Here are other examples of `POTS dial-peers` which reflect different ways to pass digits to the TDM network.

Any of these now sends the entire string “12345678” to the PBX:

```

!
dial-peer voice X pots
 destination-pattern 1234....
 port 1/0:0
 forward-digits all
!

!
dial-peer voice X pots
 destination-pattern 1234....
 port 1/0:0
 no digit-strip
!

!
dial-peer voice X pots
 destination-pattern 1234....
 port 1/0:0
 prefix 1234
!

```