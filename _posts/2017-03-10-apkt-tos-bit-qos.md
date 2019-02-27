---
layout: post
title: QoS Media Policy on the Acme Packet SBC
tags: [acme,sbc,sip]
---
When configuring `QoS` for SIP and RTP on an Acme Packet SBC it is critical to set `ToS HEX` to correct alues. This is accomplished through a Media Policy.

<!--more-->

The first step is to create a Media Policy as shown.

```text

sd4500-02# config t
sd4500-02(configure)# media-manager
sd4500-02(media-manager)# media-policy
sd4500-02(media-policy)# name QoS-Audio

```

The signaling `media-type` should be set to `message` and the proper `tos-value` is `0×60` (CoS 3, DSCP 24). For RTP the media-type value should be set to `audio` and the proper tos-value for RTP traffic is `0xb8` (Cos 5, DSCP 46).

```text

media-policy
    name                QoS-Audio
    tos-settings        
        media-type          audio
        media-sub-type      
        tos-value           0xb8
        media-attributes
    tos-settings
        media-type          message
        media-sub-type      sip
        tos-value           0x60
        media-attributes

```

Setting these values in the `Media Policy` does not invoke QoS. This is simply a set of instructions of what should be applied to signaling and RTP packets but we need to tell the SBC where to apply it.  This is done on a `realm`.  

```text

realm-config
    identifier          Access
    description         Public Facing-Untrusted
    addr-prefix         208.57.21.0/24
    network-interface   m00:226
...
    dns-realm           
    media-policy        QoS-Audio
    media-sec-policy

```

With the` media policy` assigned to the `realm` this answers the question of where to apply QoS so the policy is `enforced`. Any traffic which passes through this realm will be marked, or re-marked, with the appropriate QoS values.


