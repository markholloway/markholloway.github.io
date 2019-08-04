---
layout: post
title: Acme Packet SBC “load-limit” Command Option
tags: [acme,sbc,sip]
---

The Acme Packet SBC has an optional parameter that may be added under `sip-config` that allows the SBC to gracefully handle traffic in the event the SBC’s main processor reaches a certain threshold. 

<!--more-->

There are several reasons as to why this may occur, but at the most basic level it’s a good idea to draw a line in the sand and define at what point to you want to start gracefully `rejecting calls` if the CPU reaches a certain threshold. Every SIP appliance should have this option but unfortunately most do not.

What separates the Acme Packet SBC from others is that when this threshold is reached the SBC will reply with a `SIP 503 Service Unavailable` message which tells the originator to try an alternate destination.  In most other SIP appliances once the CPU threshold reaches a certain point the traffic is disrupted by means of calls dropping, loss of RTP (if media is flowing through), or registrations becoming corrupted.

It is worth mentioning that the purpose of setting the load-limit is to avoid an unforeseen event that would cause any network device to experience excessive utilization and effect production traffic.  This is not a replacement for proper `SROP` (SIP Registration Overload Protection) and DDoS (Distributed Denial of Service) configuration on the SBC.  With the proper SROP and DDoS settings you are ensuring the Acme Packet SBC is running optimally and protecting your network while gracefully shedding unwanted or dangerous traffic.

The following is a shortened output of my sip-config with no options applied.  Adding the load-limit option is a matter of entering the following command.

```text

sip-config
    state                   enabled
    operation-mode          dialog
    dialog-transparency     disabled
    home-realm-id           Core
    egress-realm-id         
...
    options

PHOENIX(sip-config)# options load-limit=<cpu-percentage>
PHOENIX(sip-config)# done

sip-config
    state                   enabled
    operation-mode          dialog
    dialog-transparency     disabled
    home-realm-id           Core
    egress-realm-id
...
    options                 load-limit=90

```
At this point the Acme Packet SBC will gracefully reject incoming calls if the CPU reaches or `exceeds 90%`. Of course this value may be set higher or lower.  More than likely more options will be applied in your `sip-config`. If you follow the same process to add another option it will overwrite the option that already exists.  Prepending the `+` symbol in front of the option will add it in addition to any existing options.

In this example the `load-limit` is the first configured option. In addition, the `max-udp-length` is going to be set to 0 which allows the SBC to fragment UDP packets. Otherwise the maximum size a UDP packet may be is 1500 bytes before having to use SIP TCP.  Setting this in `sip-config` applies globally on the SBC but it is possible to configure this on a per sip-interface basis if desired.  The last option is reg-cache-mode=none which tells the SBC to retain the userinfo (post NAT) in the Contact. In most environments (such as Broadsoft BroadWorks) none is the value to use. This is also required when configuring SIP Registration Overload Protection (this will be a separate blog post in the near future.

```text

PHOENIX(sip-config)# options +reg-cache-mode=none
PHOENIX(sip-config)# options +max-udp-length=0
PHOENIX(sip-config)# done

sip-config
    state                   enabled
    operation-mode          dialog
    dialog-transparency     disabled
    home-realm-id           Core
    egress-realm-id
...
    options                 load-limit=90 reg-cache-mode=none
                            max-udp-length=0

```
Based on applying the load-limit to the sip-config this provides one additional line of defense that safeguards your platform from suffering a total outage. There have been many occasions noted in the past where other platforms do not employee this method and the end result is a complete and total network outage.  Once the outage starts it becomes very difficult to recover because endpoints will begin retransmitting. Using this feature in combination with alarm-thresholds plus the appropriate SROP and DDoS settings, there is always awareness of what’s occurring on the network while at the same time gracefully handling any overflow.
