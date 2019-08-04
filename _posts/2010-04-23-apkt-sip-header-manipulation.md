---
layout: post
title: Acme Packet SBC SIP Header Manipulation Rules
tags: [acme,sbc,sip]
---

This is an example of how to `modify a SIP header` with an Acme Packet Session Border Controller (SBC).  An SBC is a device most commonly used by Service Providers and Enterprises to provide topology hiding between a SIP platform and an untrusted SIP network.  In the most simplistic terms think of it as a Cisco PIX or ASA but explicitly dedicated to Voice over IP (SIP, H.323, MGCP).

<!--more-->

This `HMR` provides the ability to populate Call Detail Record VSA’s with info from a SIP Header Manipulation Rule. It lets the HMR `copy header content` from the SIP message into one of thirty CDR fields of your choosing and works for RADIUS and CSV file CDR formats using `VSA number range` of 200-229 reserved for customer-specific requirements. 


```text

header-rule

    name                storeDiversion
    header-name         Diversion
    action              store
    comparison-type     pattern-rule
    match-value 
    msg-type            request
    new-value methods   INVITE

    name                generateVSA200
    header-name         P-Acme-VSA
    action              add
    comparison-type     boolean
    match-value         $storeDiversion
    msg-type            any
    new-value           200:+$storeDiversion.$0
    new-value methods   INVITE

```

```text

In this example a Nortel CS2K sends `m=audio` and `m=image` in a single SIP Invite which breaks Cisco ISR Faxing.
An HMR is required to set `SDP` m=audio and m=image to `0` only when both are present. HMR cannot take
effect when only one is present otherwise the FAX will fail.

sip-manipulation
        name                           setSdp
        description                    
        split-headers                  
        join-headers                  
        header-rule
                name                           setSdpZero
                header-name                    content-type
                action                         manipulate
                comparison-type                case-sensitive
                msg-type                       request
                methods                        INVITE
                match-value                    
                new-value                      
                element-rule
                        name                           setSdpZeroRule
                        parameter-name                 application/sdp
                        type                           mime
                        action                         find-replace-all
                        match-val-type                 any
                        comparison-type                pattern-rule
                        match-value                    m=audio\,*m=image([0-9]{1,5}).udptl[[:1:]]
                        new-value                      0
                        


INVITE sip:8088881491@voip.hawaiiantel.net:5060 SIP/2.0
Via: SIP/2.0/UDP 172.20.20.1:5060;branch=z9hG4bKuucm4i10cg21fh8id4b0.1
Record-Route: <sip:8088881491@172.20.20.1;lr>
From: <sip:8085463052@172.20.20.1:5060;user=phone>;tag=1688407842-1296205260165-
To: "A5_Lab Fax" <sip:8088881491@172.20.20.1:5060>
Call-ID: BW230100165270111358024115@113.52.63.7
CSeq: 636310211 INVITE
Contact: <sip:8085463052@172.20.20.1:5060;transport=udp>
Supported: 100rel
Max-forwards: 69
Allow: ACK, BYE, CANCEL, INFO, INVITE, OPTIONS, PRACK, REFER, NOTIFY, UPDATE
Content-Type: application/sdp
Accept: multipart/mixed, application/media_control+xml, application/sdp
Content-Length:   257
 
v=0
o=BroadWorks 644472 1 IN IP4 172.20.20.1
s=-
c=IN IP4 172.20.20.1
t=0 0
m=audio 16480 RTP/AVP 0 8 18 101
a=ptime:20
a=fmtp:18 annexb=no
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15
m=image 16484 udptl t38
a=T38FaxUdpEC:t38UDPRedundancy
 
```