---
layout: post
title: Acme Packet SBC and Configuring “Comfort Noise Generation”
tags: [acme,sbc,sip]
---
`Comfort Noise` (RFC 3389) is the `sound` played in an RTP stream to prevent a user form hearing total silence on the connection. 

<!--more-->

Not all telephony systems have the ability to play music while a party is on hold. Without Comfort Noise (CN) the party on hold may think the connection dropped unless there is an indicator letting know the call has not been dropped..

Starting with `ECZ-7.4.0` the Acme Packet SBC has the ability to `inject` Comfort Noise into an RTP stream by analyzing the SDP Offer and SDP Answer from both SIP endpoints. `CN interworking` is triggered on a per realm basis.

In the example below the `calling party` (Skype for Business) SDP Offer contains CN and is traversing a realm called `core` which has `CN` interworking `enabled`. The SBC forwards SDP to the `called party`. If the called party SDP Answer contains CN the SBC does not do anything because both endpoints support Comfort Noise. If CN is `not present` in the PSTN’s SDP Answer the SBC `adds CN` to the egress SDP Answer (towards Skype for Business) and will take responsibility for injecting CN into the RTP stream.

Example SBC configuration:

```text

sbc# config t
sbc(configure)# media-manager
sbc(media-manager)# realm-config
sbc(realm-config)# spl-option +comfort-noise-generate
sbc(realm-config)# done

media-manager
    realm-config
        identifier          core
        addr-prefix         10.24.124.0/24
        network-interface   s1p0
        mm-in-realm         enabled
        spl-options         comfort-noise-generate

```
