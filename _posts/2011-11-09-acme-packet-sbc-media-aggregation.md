---
layout: post
title: Acme Packet SBC Media Aggregation
tags: [acme,sbc,sip]
---

The Acme Packet 3800 and 4500 series Session Border Controllers come with an NIU (Network Interface Unit) that includes four Gigabit ports.  In rare cases one may need to support `Media Aggregation` where two of the Gigabit interfaces need to be look like they are “bonded” to accommodate a large number of calls (with media anchored).  

<!--more-->

For example, a wholesale SIP Peering Service Provider may need to handle upwards of 16,000 concurrent calls on one single Realm on the SBC.  If  calls are using the G.711 codec this would require 1.5GB of bandwidth.

The process used to support Media Aggregation is to assign the same Realm name to two different `Steering Pools`.  For example, on the realm named `Access` it would have more than one steering pool which would reference two different network-interfaces.  The same is true for the Core.  In the following example NIU ports 0 and 1 are used for Access (public facing) and 2 and 3 are used for Core (private).  Note the NIU is considered slot 0 and the ports are 0, 1, 2, 3.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-media-agg01.png)
![]({{ site.baseurl }}/blog/assets/apkt/apkt-media-agg02.png)

The next step is to verify you have your `Access` and `Core` realms configured.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-media-agg03.png)

The final step is to create the `Steering Pools` and define the `network-interfaces` for each.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-media-agg04.png)

At this point the SBC will utilize two ports assigned to Access and two ports assigned to Core to support media thus providing Media Aggregation. SIP signaling continues to only traverse on the sip-interfaces assigned to the Access and Core realms (s0p0 and s0p2).

![]({{ site.baseurl }}/blog/assets/apkt/apkt-media-agg05.png)

At this point the Acme Packet SBC is fully prepared to handle traffic that exceeds 1GB on a single Realm.

