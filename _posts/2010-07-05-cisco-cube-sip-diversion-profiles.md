---
layout: post
title: Cisco CUBE and modifying SIP diversion with SIP profiles
tags: [cisco,cube]
---
When configuring a `SIP Trunk` with `CUCM` to a SIP Service Provider it is best practice to use an `SBC` or Session Border Controller such as CUBE (Cisco Unified Border Element) between CUCM and the provider's SIP Trunk.  One benefit is this automatically alleviates the challenges most IP PBX’s face with hosted nat traversal specific to SIP and RTP.
<!--more-->

However, an even greater benefit is the power and flexibility that CUBE provides with its ability to `modify SIP headers` much like the larger and more costly Session Border Controllers used by SIP Service Providers.

In this case the modification is for `SIP Diversion`. By default, when UCM forwards a call to another number over the SIP Trunk it sends the internal DN as the number performing the redirect. This is a problem when forwarding calls back to the PSTN as the provider expects 10 digits instead of 4 (or whatever the internal dial plan may be).  An easy solution to this problem is using a SIP Profile with CUBE and replacing the 4 digit number with the 10 digit Pilot Number (this is same number in your sip-ua portion of the router config).

When CUBE is set to `allow sip to sip` it is possible to reference a SIP Profile that will modify a particular SIP message (or messages) traversing through the router. In this example it’s any SIP signaling message that contains a SIP header called `Diversion`.  The goal is to change 9948 (the 4 digit DN) to the full 10 digit phone number 9494289948 otherwise the SIP provider will reject a redirected call with only 4 digits in the user portion of the SIP URI in the Diversion header.

Below is the `SIP Invite` in its entirety as originated by UCM and sent towards the Cisco router running CUBE where the original Diversion header only contains the 4 digit DN. The call flow is a PSTN call originated from 4802317040 to a number on UCM 9494289948 and the UCM number forwards back to PSTN 7023100500. Below is the forwarding part of the call-flow back to CUBE/PSTN.

```
*Oct 14 00:25:06.327: //-1/xxxxxxxxxxxx/SIP/Msg/ccsipDisplayMsg:
Received:
INVITE sip:17023100500@192.168.1.1:5060 SIP/2.0
Date: Sat, 10 Jul 2010 20:09:26 GMT
Allow: INVITE, OPTIONS, INFO, BYE, CANCEL, ACK, PRACK, UPDATE, REFER, SUBSCRIBE, NOTIFY
From: “HOLLOWAY MARK  ” <sip:4802317040@192.168.1.254>;tag=9fc21ef0-b4f8-4240-a30e-86b6cfa8e8f7-27463414
Allow-Events: presence
P-Asserted-Identity: “HOLLOWAY MARK  ” <sip:4802317040@192.168.1.254>
Supported: timer,resource-priority,replaces
Supported: Geolocation
Min-SE:  1800
Diversion: “9948″ <sip:9948@192.168.1.254>;reason=unconditional;privacy=off;screen=yes
Remote-Party-ID: “HOLLOWAY MARK  ” <sip:4802317044@192.168.1.254>;party=calling;screen=yes;privacy=off
Content-Length: 214
User-Agent: Cisco-CUCM7.1
To: <sip:17023100500@192.168.1.1>
Contact: <sip:4802317040@192.168.1.254:5060>
Expires: 180
Content-Type: application/sdp
Call-ID: 8aa2480-c381d376-c6-fe01a8c0@192.168.1.254
Via: SIP/2.0/UDP 192.168.1.254:5060;branch=z9hG4bK1b172bdcdc9
CSeq: 101 INVITE
Session-Expires:  1800
Max-Forwards: 7
```

The following CUBE configuration modifies the User portion of the SIP URI to replace 9948 with 9494289948 which is our valid 10 digit number the Service Provider is expecting.

```
voice service voip
allow-connections sip to sip
sip
sip-profiles 1

voice class sip-profiles 1
request INVITE sip-header Diversion modify “<sip:(.*)@(.*)>” “<sip:4804101040@voip.markholloway.net”
```

The characters  [.*@.*] in the first set of the expression identify all characters in the original Diversion header coming from UCM and the second set identifies what the first set will be replaced with.

This is the new SIP Invite modified by CUBE in its entirety as it leaves CUBE and goes towards the SIP Service Provider.

```
*Oct 14 00:25:06.355: //-1/xxxxxxxxxxxx/SIP/Msg/ccsipDisplayMsg:
Sent:
INVITE sip:17023100500@voip.markholloway.net:5060 SIP/2.0
Via: SIP/2.0/UDP 174.26.121.21:5060;branch=z9hG4bK81718
From: “HOLLOWAY MARK  ” <sip:4802317040@voip.markholloway.net>;tag=2C06BC-1C60
To: <sip:17023100500@voip.markholloway.net>
Date: Wed, 14 Oct 2009 00:25:06 GMT
Call-ID: DB7F2DFB-B78E11DE-801FA01B-F10CA800@174.26.121.21
Supported: 100rel,timer,resource-priority,replaces,sdp-anat
Min-SE:  1800
Cisco-Guid: 3682385244-3079541214-2149163035-4044138496
User-Agent: Cisco-SIPGateway/IOS-12.x
Allow: INVITE, OPTIONS, BYE, CANCEL, ACK, PRACK, UPDATE, REFER, SUBSCRIBE, NOTIFY, INFO, REGISTER
CSeq: 101 INVITE
Timestamp: 1255479906
Contact: <sip:4802317040;tgrp=9494289948;trunk-context=voip.markholloway.net@174.26.121.21:5060>
Expires: 180
Allow-Events: telephone-event
Max-Forwards: 6
Session-Expires:  1800
Diversion: <sip:9494289948@voip.markholloway.net>;privacy=off;reason=unconditional;screen=yes
Content-Type: application/sdp
Content-Disposition: session;handling=required
Content-Length: 216
```

You do not need to build the profile for multiple numbers since the router is using the pilot user from `sip-ua` as the Diversion number.  It’s common for Service Providers to build a trunk group in a parent-child hierarchy so if the redirect number is the pilot number, regardless of which DN is doing the forwarding, the call is permitted. This will not interfere with caller-id either.

The following are more SIP Profile examples.  These are for supporting a Trunk Group Identifier.  Some SIP Provider platforms such as Broadworks and Sonus will allow tgrp to be used for validating a legitimate call rather than using a phone number from the trunk group.  This allows the customer to send any outbound caller-id they want without the call being rejected.

In the following examples the customer in Broadworks would have their Trunk Group Identifier set by the Service Provider.  For simplicity, the Provider is using the main trunking number as the identifier.  It needs to be set for both SIP registrations and SIP Invites.

```
request REGISTER sip-header Contact modify “<sip:(.*)@(.*)>” “<sip:\1;tgrp=9494289948;trunk-context=voip.markholloway.net@\2>”
request INVITE sip-header Contact modify “<sip:(.*)@(.*)>” “<sip:\1;tgrp=9494289948;trunk-context=voip.markholloway.net@\2>”
```

Below is another example where a call coming from UCM includes the leading 9 for outside dial tone. Rather than stripping 9 on UCM it will be stripped by CUBE using a SIP Profile.

```
response 183 sip-header Remote-Party-ID modify “(.*):9(.*)” “\1:\2″
```