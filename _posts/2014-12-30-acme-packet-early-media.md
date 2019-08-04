---
layout: post
title: Acme Packet SBC and Configuring “Selective” Early Media Suppression
tags: [acme,sbc,sip]
---
The Acme Packet SBC includes support for `Early Media Suppression`. This allows you to decide what `Realms` can and cannot support Early Media and in what direction Early Media is allowed. 

<!--more-->

Taking it one step further, the Acme Packet SBC also supports `Selective` Early Media Suppression. This means that even if a realm is configured to receive Early Media for all calls, the SBC can still be configured to deny Early Media from certain realms (even if those realms can send early media to other destinations) through the use of Realm Groups.

Early Media is defined by an endpoint sending `RTP/RTCP` packets `before` a `SIP session` is established by a `200 OK`. Otherwise, the expected behavior is media does not begin flowing between endpoints until 200 OK is received. Instances where early media may occur is when a user calls the PSTN and an announcement is immediately played or a custom ringtone (ie. music) is heard when calling a mobile phone.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-early-media01.jpg)

There may be a variety of reasons why one does not want to `allow Early Media` under specific conditions. For example (real world) a Service Provider supporting Hosted IP PBX subscribers and SIP Trunking customers sends PSTN traffic from their network to multiple PSTN Media Gateways. One gateway supports outbound Local and Domestic Long Distance calls and the other media gateway supports outbound International calls. The Service Provider doesn’t want to allow Early Media from the International gateway to flow inbound to their Hosted IP PBX customer base, but they will allow Early Media to flow from the International media gateway to their SIP Trunking customer base. The Local and Domestic Long Distance media gateway is allowed to send Early Media to either customer base.

First, it’s important to cover the basics of implementing Early Media Suppression. This may be configured within a Realm or a `Session Agent` using the `early-media-allow` parameter. When a call egresses the SBC to a specific realm, the matching realm’s early-media-allow setting will be applied to either allow-all, block-all, or block one-way early media until a 200 OK is received. Media must be anchored to the SBC in order for Early Media settings to have any effect. In this example, calls are originated from the Access (Hosted IP PBX) realm to the PSTN (Access realm’s next-hop is the Core realm).

```text

APKT-6300(realm-config)# show

realm-config
    identifier                  Core
    description                 PSTN Media Gateway
    addr-prefix                 0.0.0.0
    network-interface           s0p0:0
    mm-in-realm                 enabled
...
    symetric-latching           disabled
    early-media-allow           none

APKT-6300(realm-config)# early-media-allow ?

<enumeration> how to handle early media
    <none, reverse, both>
    none: no early media allowed
    reverse: allow early media in the direction of calling endpoint
    both: allow early media in both directions

```

This example has `early-media-allow` set to `none` in the realm configuration. Early Media is not allowed in either direction. Therefore, if an Access subscriber calls the PSTN, no Early Media is permitted back to the Access realm, and vice-versa.

~[]({{ site.baseurl }}/blog/assets/apkt/apkt-early-media02.png)

This example has `early-media-allow` set to `reverse` which in this case allows a Hosted IP PBX subscriber to place a call to BroadWorks or the PSTN and hear early media. However, the subscribers are not permitted to send Early Media in the other direction since early-media-allow is set to reverse and not both.

~[]({{ site.baseurl }}/blog/assets/apkt/apkt-early-media03.png)

So far we have statically defined to always always allow `Early Media` from one direction. Now for a scenario that is a little more tricky. Lets say calls originating from the Access realm which route to the ITSP-1 realm/media gateway `are not allowed` to hear Early Media. However, calls originating from the Access realm which route to the ITSP-2 realm/media gateway `are allowed` to hear Early Media. However, ITSP-1 is allowed to send Early Media to other realms (ie. Acces-2, Acces-3, etc.). Only the “Access” realm cannot receive Early Media from ITSP-1.

The trick in this topology is all media gateways are allowed to send Early Media to any realm, and Access is allowed to receive Early Media from any realm. We want to `selectively suppress` only when the Early Media RTP traverses specifically from ITSP-1 to Access.

By using `Realm Groups`, we can essentially build a logical binding of source and destination realms together and customize Early Media settings just for calls flowing across those two realms.

```text

APKT-6300# config t
APKT-6300(configure)# media-manager
APKT-6300(media-manager)# realm-group
APKT-6300(realm-group)# source-realm "Access, ITSP-1"
APKT-6300(realm-group)# destination-realm "Access"
APKT-6300(realm-group)# early-media-allow-direction none

```

Now only calls that are originated from the `Access` realm to `ITSP-1` realm will be prohibited from receiving early media from the ITSP-1 Media Gateway. If the same call routes to `ITSP-2`, Early Media is allowed.

[]({{ site.baseurl }}/blog/assets/apkt/apkt-early-media04.png)

