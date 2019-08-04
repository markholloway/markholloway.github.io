---
layout: post
title: Acme Packet SBC Remote SIP Survivability
tags: [acme,sbc,sip]
---

With the release of Acme Packet 6.4m2 software the SBC now supports `SIP Remote Survivability`. This is applicable for a Service Provider offering `Hosted IP PBX` or `UCaaS` using SIP phones which register to a centralized Data Center or Cloud model.

<!--more-->

In this example I will focus primarily on the Service Provider model, although it’s just as relevant to the Enterprise model mentioned above since we are talking about remote phones registering over the WAN to a `Softswitch` or `IP PBX`. In the diagram below the SIP phones register from the Enterprise site over the Internet or `MPLS` network to the Service Provider core where a Broadsoft `BroadWorks` Softswitch resides. For those note familiar with BroadWorks, think of it as a very large software platform that has the ability to virtualize what looks like many IP PBX’s, each for dedicated customers. Most notably in large deployments it is common to see some sort of SIP enabled Firewall, ALG, or SBC (preferred) on the Enterprise premise. All SIP communication, including SIP registration and originated SIP calls, will egress the Enterprise phones through the SBC up into the Service Provider’s SBC and to BroadWorks. Even if calls are destined for another phone extension in the same Enterprise premise the call must go through the carrier core where CDR’s will be generated and any other Class 5 features may be provided for the call hair pinning back into the Enterprise to a different extension.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-remote-survivability01.png)

One of the biggest challenges is what happens if the SP core is unreachable. All registrations and call processing will fail, even for calls destined to another phone extension in the same Enterprise, since the `SIP Invite` must be able to reach the BroadWorks Softswitch or IP PBX to ring another extension in the same location.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-remote-survivability01.png)

If the Enterprise is using an Acme Packet SBC on premise the `Survivability Mode` will use either the `P-Asserted Identity` from the SIP endpoint or optionally the BroadWorks Survivability method using XML. When the SP Core or Enterprise data center becomes unreachable the Survivability Health Score degrades and the SBC knows to process registration and call traffic locally without sending the traffic to the SP Core.

In Survivability Mode phone A has the ability to call phone C even when the SP Core is unreachable. If the Enterprise normally uses abbreviated dialing such as 4-digit extensions, this will still continue to work, as well as dialing the full phone number.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-remote-survivability03.png)

Some Enterprises may want to have a local `SIP Gateway` (such as a Cisco ISR or Adtran Total Access IAD) on premise and utilize one or more PRI’s connected for PSTN access when the SP Core is unreachable. Depending on the Service Provider, the same SP used for SIP Services may also route to the PRI for overflow/outage scenarios so the Enterprise has both inbound and outbound redundancy on premise. The call originated from the SIP network the PSTN where there is no matching Address of Record for SIP phones, the SBC will route the calls to the SIP-PSTN Gateway.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-remote-survivability04.png)

Below is a basic Remote Survivability configuration.

```text

NNOS-SD# config t
NNOS-SD(configure)# session-router
NNOS-SD(session-router)# sip-interface
NNOS-SD(sip-interface)# service-tag SipTrunk1 <- Your SIP Interface
NNOS-SD(sip-interface)# done
NNOS-SD(sip-interface)# exit
NNOS-SD(session-router)# survivbility
NNOS-SD(survivability)# enabled
NNOS-SD(survivability)# done
NNOS-SD(survivability)# exit
NNOS-SD(sip-interface)# service-health
NNOS-SD(service-health)# service-tag-list
NNOS-SD(serviceTag)# service-tag-string SipTrunk1
NNOS-SD(serviceTag)# sa-health-profile
NNOS-SD(sa-health-profile)# session-agent-hostname VzB-Trunk01 <- Session Agent to Monitor
NNOS-SD(sa-health-profile)# session-agent-health 100 <- Engage Survivability when below 100

```
Best-practice is to enable `SIP Options` ping for each `Session Agent`. This way the SBC will pro-actively know when a Session Agent is in-service or out of service and degrade the health score appropriately.

The following has been a basic introduction to the Acme Packet Remote Survivability feature. There is more functionality and detail that may be applied and is well documented in the E-CX Maintenance Guide. Although a subset of this functionality has existed on other SIP ALG platforms in the past, Acme Packet has introduced many great new features relevant for Remote Survivability that do not exist elsewhere. All the resiliency and High-Availability that is inherent to the Acme Packet platform remains intact even when Remote Survivability is engaged.



