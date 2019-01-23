---
layout: post
title: How to “tail” sipmsg.log on the Acme Packet SBC command line (ACLI)
tags: [acme,sbc,sip]
---
The `tail` program is available on Unix operating systems and is used to view the tail end of a text file or piped data. 

<!--more-->

Once tail is running for a particular log file, and as the log file get populated with new data, the newly populated content is displayed on the screen real-time. This saves a step from having to use more or cat after the fact where a user would have to scroll all the way through the log file to the end in order to view the newly added data (and more data may continuously be added making it even more inconvenient).

In the case of the Acme Packet SBC, retrieving log files for viewing typically requires downloading them via FTP/SFTP. The Acme Packet SBC now supports `tail from ACLI`.

In the following example I want to see what dialog is happening when trying to register a SIP phone through the SBC.  It is possible to tail different log files.

```text 
NNOS-VM# notify sipd siplog

NNOS-VM# tail-logfile-open sipd sipmsg.log

waiting 1200 for response to request
completed

14:44.154 On [0:0]72.12.135.250:5060 received from 72.12.135.2:56883
REGISTER sip:acmepacket.local SIP/2.0
Via: SIP/2.0/UDP 172.20.10.4:56883;rport;branch=z9hG4bKPjjWHgcYsrr-T9bPbaZ1-hzFTE-U70g.F2
Route: <sip:acmepacket.local;lr>
Max-Forwards: 70
From: “Mark Holloway-8001″ <sip:7818018001@acmepacket.local>;tag=q.wbz5RZXd30uc7RwV2IP4GmSCGKDTwl
To: “Mark Holloway-8001″ <sip:7818018001@acmepacket.local>
Call-ID: VV5Yro3MQmi7fXX1CDeDax79zDnR.5jN
CSeq: 55540 REGISTER
User-Agent: Telephone 1.1.4
Contact: “Mark Holloway-8001″ <sip:7818018001@172.20.10.4:56883;ob>
Expires: 300
Allow: PRACK, INVITE, ACK, BYE, CANCEL, UPDATE, INFO, SUBSCRIBE, NOTIFY, REFER, MESSAGE, OPTIONS
Content-Length: 0

—————————————-

14:44.158 On [0:0]72.12.135.250:5060 sent to 72.12.135.2:56883
SIP/2.0 404 Not Found
Via: SIP/2.0/UDP 172.20.10.4:56883;received=72.12.135.2;branch=z9hG4bKPjjWHgcYsrr-T9bPbaZ1-hzFTE-U70g.F2;rport=56883
From: “Mark Holloway-8001″ <sip:7818018001@acmepacket.local>;tag=q.wbz5RZXd30uc7RwV2IP4GmSCGKDTwl
To: “Mark Holloway-8001″ <sip:7818018001@acmepacket.local>;tag=aprqngfrt-ejkv9p0000m9f
Call-ID: VV5Yro3MQmi7fXX1CDeDax79zDnR.5jN
CSeq: 55540 REGISTER

—————————————-

NNOS-VM# notify sipd nosiplog

NNOS-VM# tail-logfile-close sipd sipmsg.log

```