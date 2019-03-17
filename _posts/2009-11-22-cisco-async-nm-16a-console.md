---
layout: post
title: Cisco ASYNC NM-16A console management
tags: [cisco]
---
The following is an example of using a Cisco 2811 slotted with an `NM-16A ASYNC` module to manage other Cisco devices as if you were connected to them locally with a laptop and a serial connection. The ASYNC modules are available in different port densities. There is also an HWIC version.
<!--more-->

```
## Router cold boot shows the NM-16A hardware

router# show hardware

Cisco 2811 (revision 53.50) with 772096K/14336K bytes of memory.

Processor board ID FTX1124A3VQ
2 FastEthernet interfaces
15 Serial interfaces
4 Low-speed serial(sync/async) interfaces
16 terminal lines
2 Channelized/Clear E1/PRI ports
4 Channelized/Clear T1/PRI ports
1 Virtual Private Network (VPN) Module

!
line con 0
exec-timeout 0 0
privilege level 15
line aux 0
line 1/0 1/15
session-timeout 5
transport input all
autohangup
stopbits 1
line vty 0 4
login
!
router#show line

Tty Line Typ Tx/Rx A Modem Roty AccO AccI Uses Noise Overruns Int
0 0 CTY – – – – – 0 0 0/0 -
1 1 AUX 9600/9600 – – – – – 0 0 0/0 -
1/0 66 TTY 9600/9600 – – – – – 0 0 0/0 -
1/1 67 TTY 9600/9600 – – – – – 0 0 0/0 -
1/2 68 TTY 9600/9600 – – – – – 0 0 0/0 -
1/3 69 TTY 9600/9600 – – – – – 0 0 0/0 -
1/4 70 TTY 9600/9600 – – – – – 0 0 0/0 -
1/5 71 TTY 9600/9600 – – – – – 0 0 0/0 -
1/6 72 TTY 9600/9600 – – – – – 0 0 0/0 -
1/7 73 TTY 9600/9600 – – – – – 0 0 0/0 -
1/8 74 TTY 9600/9600 – – – – – 0 0 0/0 -
1/9 75 TTY 9600/9600 – – – – – 0 0 0/0 -
1/10 76 TTY 9600/9600 – – – – – 0 0 0/0 -
1/11 77 TTY 9600/9600 – – – – – 0 0 0/0 -
1/12 78 TTY 9600/9600 – – – – – 0 0 0/0 -
1/13 79 TTY 9600/9600 – – – – – 0 0 0/0 -
1/14 80 TTY 9600/9600 – – – – – 0 0 0/0 -
1/15 81 TTY 9600/9600 – – – – – 0 0 0/0 -

The ASYNC module is in slot 1 and there are 16 available ASYNC ports labeled 1/0 – 1/15.

router# show diag

Slot 1:
Async Port adapter, 16 ports
Port adapter is analyzed
Port adapter insertion time 00:15:02 ago
EEPROM contents at hardware discovery:
Hardware revision 0.1 Board revision B0
Serial number 15674198 Part number 800-02244-05
FRU Part Number NM-16A=

```

## Configuration example

Best-practice is to create a loopback interface. They are never ‘down’ unless they are administratively shutdown.

```

router(config)# interface Loopback0
router(config-if)# ip address 177.1.254.254 255.255.255.255

Use the ‘ip host’ command to assign a hostname to your reverse telnet session. 20xx port number should match the intended physical connection from the rear of the NM-16A as seen in ’show line’ output.

router(config)# ip host hq 2066 177.1.254.254
router(config)# ip host sw 2067 177.1.254.254
router(config)# ip host br1 2068 177.1.254.254
router(config)# ip host br2 2069 177.1.254.254

```

## Breakdown

Router starts all reverse telnet ports with 20xx
The lowest xx value is 66 and the highest is 81 (review ’show line’ output)
Possible assignable ranges are 2066 – 2081 (which correspond with Line 1/0 – 1/15)
Rear of NM-16A module uses two Octal cables labeled Port 0-7 and Port 8-15
Port/Cable 0 = Line 1/0; Line 1/0 = 2066
Port/Cable 1 = Line 1/1; Line 1/1 = 2067
Port/Cable 2 = Line 1/2; Line 1/2 = 2068
Port/Cable 15 = Line 1/15; Line 1/15 = 2081
To verify this configuration is working to br2 type the host name in enable mode

```

router# br2
Translating “br2″

Trying br2 (177.1.254.254, 2069)… Open

r3-br2#

```

Press and hold `CTRL SHIFT 6` (in that order) then let go and press X to exit the console session and return back to the original router# acting as the Access Server.

`CTRL+SHIFT+6 X` does not permanently end the session, it only jumps the session back to the Access Server.  Knowing that the connection to br2 is still ‘open’ it is still possible to console to yet another device without ending the original session to br2.  If I want to connect to br1 from the router# I simply type br1. Pressing CTRL+SHIFT+6 X will escape the br1 session and return the session to the Access Server.

It is important to keep in mind the router still has two active console connections which include br2 (the original session) and br1. Entering ‘br2′ will not allow a connection to the br2 router because a session is already in open. Instead, enter ‘resume br2′ which uses the existing session to resume the console connection from the Access Server. When it is time to permanently end a console session enter ‘disconnect br2′ at the Access Server router prompt and the console session will end.