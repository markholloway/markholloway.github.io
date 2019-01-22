---
layout: post
title: QoS Routing on the Acme Packet SBC
tags: [acme,sbc,sip]
---

QoS based Routing is a feature of the Acme Packet SBC (Session Director) that pro-actively observes and measures RTP quality on a given network path (realm) by using R-Factor (QoS measurement) to determine if quality is acceptable. If the R-Factor falls below a certain threshold then new calls are re-routed on another network path using a different realm. This works for both inbound and outbound calls.

<!--more-->

The example diagram show calls being received inbound from an ITSP. It is common for customers to deploy multiple SBC’s in different physical locations for geographic redundancy. Most people think of redundancy and failover occurring when the network is completely down or unreachable, but another factor to consider is a network condition where route flapping, DoS attacks on a router, or bad cabling play a role in an outage and there is intermittent network connectivity. In many cases having intermittent connectivity is actually worse than the network being completely unreachable. For example, if a SIP Invite is successfully setup, yet within seconds the network experiences flapping, the RTP traffic will be lost momentarily. This is where QoS based Routing can save the day.

This  diagram displays a primary and secondary SBC with two SIP paths from an ITSP to the customer’s network. In this case there is no service disruption occurring.



In order to utilize QoS based Routing on the SBC it requires the qos-enable value to be set to enabled under media-manager/realm-config. QoS based Routing uses R-Factor to measure quality on a per-realm basis to either cut back the traffic allowed through a realm or alternatively shut down all traffic on that realm.

When configuring QoS constraints per realm there are two categories: major and critical. The constraints set in the major category rejects a certain percentage of calls with a SIP 503 Service Unavailable message. The percentage value is configurable by the user using the call-load-reduction context entry with a value between 0 and 100 (0 represents no call reduction and 100 represents all calls rejected). Calls originating on the customer’s network towards the ITSP will automatically use another realm if there are other routes configured on the customer’s SBC, otherwise calls will be rejected if there are no alternative routes. The critical behavior functions very similar to major, however the user may specify when calls should resume on the realm based on a time-to-resume value which tells the SBC to wait until the R-Factor has achieved acceptable performance for a specific period of time.