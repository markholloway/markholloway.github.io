---
layout: post
title: Broadsoft Trunk Group Identity Configuration
tags: [broadsof,sbc,sip]
---
Broadworks Trunk Group Identity (TGI) is an option in the Trunk Group Profile that allows a unique identity to be provisioned and allow `Unscreened Calls` from the customer premise. 

<!--more-->

Unscreened Calls is common with `TDM` (PRI) customers who want to send a `From` phone number that does not reside in their Trunk Group. With SIP trunks delivering PRI at the customer premise, this type of call will fail unless the PBX sends an `ISDN Redirect` on the PRI connected to the Gateway which generates `SIP Diversion` to BroadWorks. Otherwise Broadworks sees a To and From that are both PSTN numbers and `rejects` the call. 

A common scenario where this instance occurs is a `PSTN` caller calling a `SIP` subscriber and the call is forwarded to another PSTN number. The person receiving the forwarded call on the PSTN wants to see the caller ID of the original calling party not the SIP subscriber number. With Unscreened Calls enabled and Trunk Group Identity provisioned in the TG Profile the calls will be permitted even without SIP Diversion. This also requires an identical `TGI` to be configured on a SIP endpoint such as a Cisco ISR or IAD.  When the SIP endpoint sends a SIP invite it will include the provisioned TGI in the `Contact` header.  As of August 14, 2009, Adtran TA900’s do not support TGI. A feature request has been submitted to Adtran.
`
Trunk Group Identity in Broadworks complies with `RFC 4904`. Using `trgp` and trunk-context is a requirement to be compliant with the RFC.

If you are using an `Acme Packet SB`C you must configure the global `SIP option` to pass the Contact through to Broadworks. Otherwise the SBC will rewrite the Contact header and TGI will not pass.

```text

acme# config t
acme(config)# session-router
acme(session-router)# sip-config
acme(session-router)# select
acme(sip-config)# options +reg-cache-mode=none

```

All SIP Contact header information from the endpoint is now retained. It is important to note that using + means this option will be added to the SD sip-config and your other options will be retained as well. If you issue the show command you will see an example of this.

```text

acme(sip-config)# show

options
forward-reg-callid-change
max-udp-length=0
set-inv-exp-at-100-resp
reg-cache-mode=none

```

If you do not prepend `+` in front the option you are adding, the SD will remove the old options and only apply the option you are currently adding.

The last item to configure is the SIP endpoint. In this case it is a Cisco ISR or IAD. There is no `TGI feature` in IOS but IOS does offer the ability to modify SIP headers through the use of `SIP Profiles` which are a feature of `CUBE`. 

In the following example I am creating SIP profile 10 and this will serve two purposes. When the `sip-ua` registers to Broadworks it will include the tgrp modification in the Contact header. The other modification must be executed though the use of a VoIP `dial peer`. When the ISR/IAD sends a SIP invite to Broadworks (based on the VoIP dial peer) it will reference SIP profile 10 and include the modified statement for INVITE by injecting it into the Contact header.

```text

voice class sip-profiles 10
request REGISTER sip-header Contact modify “<sip:(.*)@(.*)>” “<sip:\1;tgrp=9494289972;trunk-context=voip.markholloway.com@\2>”

request INVITE sip-header Contact modify “<sip:(.*)@(.*)>” “<sip:\1;tgrp=9494289972;trunk-context=voip.markholloway.com@\2″

dial-peer voice 949 voip
(output omitted)
voice-class sip profiles 10

```

The example profile shows that we are taking all elements from the self-generated SIP registration and adding more information.  The second part of each `request` is where we inject the `tgrp` and `trunk-context` information.  

The tgrp value in this example is the `Pilot User` number `9494289972`.  The value of the trunk-context is a service provider domain.

This example only highlights Unscreened Calls for SIP to PRI customers using a SIP endpoint that has the ability to support RFC 4904.  There is another method which may be used by building unique `session agents` on the SBC.  