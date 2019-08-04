---
layout: post
title: Broadsoft R14.SP9 Generic SIP Smart Proxy bug
tags: [broadsoft,sbc,sip]
---
I ran across this during an upgrade from `Broadworks R14.SP8 to SP9`. 

<!--more-->

BroadWorks appears to contain a bug when using the `Generic SIP Smart Proxy` device in SP9. At the time I am writing this post Broadsoft TAC has not officially acknowledged this as a bug.  The behavior did not exist in any prior version of Broadworks and I am confident Broadsoft Engineering did not intend this behavior to occur.

In this particular scenario there is an Acme Packet SBC between a `SIP endpoint` and `BroadWorks`. SIP registration traverses through the SBC and rewrites the `SIP URI` which contains a cookie in the `SD-Contact` after the phone number `7025551234`.

```text

acme01# show sip endpoint-ip 7025551234
User <sip:7025551234@65.110.156.250>
Contact ID=98488082 exp=1819
UA-Contact: UDP
realm=Access local=65.110.156.250:5060 UA=63.110.156.130:4618
SD-Contact: <sip:7025551234-rjbrh1f7n2m68@10.110.156.250:5060> realm=Core
Call-ID: MjVhYjQxZTcyMDA3ZDAyODAwMzA1NTI5MzFjNzU3MjE.’
SA=10.110.156.250  <– Broadworks AS
Via-Key: 63.110.156.130:4618#Access!sip:7025551234@63.110.156.130:4618!

```

In Broadworks the SIP registration for this number would show the SIP URI exactly as it appears with the cookie.  However, with SP9 Broadworks sets up a SIP invite to the number and sends `7025551234@10.110.156.250:5060` rather than `sip:7025551234-rjbrh1f7n2m68@10.110.156.250:5060`.  The cookie portion of the URI is missing and the SBC responds with a 604 global failure response.

Sheer luck would have it that enabling the `Use Business Trunking Contact` under System > Resources > Identity/Device Profile Types would clear up the issue.  Otherwise each number for every BroadWorks Group using `GSSP` would need to be reassigned to another Device type in Broadworks and would be service impacting.