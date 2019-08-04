---
layout: post
title: Acme Packet SBC and Configuring Codec Policies for SIP Call Flows
tags: [acme,sbc,sip]
---

The Acme Packet Session Director (often referred to as a Session Border Controller) has the flexibility of re-ordering or completely removing certain codecs from SDP (Session Description Protocol) before passing a SIP Invite to the destination SIP endpoint.  

<!--more-->

Codec re-ordering or stripping is useful in cases where the originating device may be sending a particular codec that is not supported (or preferred) by the far.  For example, a SIP peering destination may only allow certain codecs to be contained in SIP Invites originating from your network.  If a device is sending G722, G711, G726, and G729 but the far end explicitly states only G722 and G711 are permitted, a policy must exist somewhere in the network that complies with the requirements of the far end.  Some SIP endpoints provide control over which codecs are permitted in SDP, but this is not always the case and therefore the Acme Session Director is able to provide global enforcement over all endpoints to ensure they comply.  Using the SD also drastically simplifies SIP endpoint management by avoiding tedious configuration of individual configurations for various devices.

The Session Director has the ability to perform codec policy enforcement on an incoming policy or an outgoing policy. The incoming policy is great if you want to achieve the same result for every incoming call regardless of what realm the call will egress.  Configuring on the egress allows customization where perhaps one realm may order the codec list one way while another realm orders the codec list another way as the call leaves the Session Director depending on which destination the SIP Invite is sent to.

The diagram illustrates the scenario above where an endpoint is sending more codec than what is permitted by the far end. The Acme Session Director has the ability to re-write the SDP before sending the SIP Invite to the far end.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-codec-policy.png)

First, start by going into configuration mode and enter the codec-policy configuration.

```text

lab-sd4500# conf t
lab-sd4500(configure)# media-manager
lab-sd4500(media-manager)# codec-policy
lab-sd4500(codec-policy)# <policy name>

```

This very basic example allows all codecs in the SDP to pass through. The * symbol represents a wildcard. This is effectively the same as having no codec policy.

```text

lab-sd4500(codec-policy)# allow-codecs *

```

The next example allows all codecs except for G729 to pass through.

```text

lab-sd4500(codec-policy)# allow-codecs * G729:no

```

The next example removes all codecs from the SDP.  If the far end device is in compliance with RFC 3264 (offer/answer with SDP) it will supply a new SDP in response to the SIP Invite.

```text

lab-sd4500(codec-policy)# allow-codecs * audio:no

```

The next example demonstrates a SIP endpoint that originates a SIP Invite which contains G711 and G729, but only G729 should be passed to the far end. However, if the originating device had sent a SIP Invite that contains G711 but does not contain G729 then G711 is permitted to be included in the SDP to the far end SIP endpoint.  Essentially, the word force is stating that if G729 is present in the original Invite, regardless of whether G711 is present, then only send G729 to the far end. If G729 is not present but G711 is present, go ahead and send G711.

```text

lab-sd4500(codec-policy)# allow PCMU G729:force

```

Next is an example of a codec-policy which needs to be associated with a Session Agent (ie. target SIP endpoint such as a PSTN SIP Peering Provider, also referred to as an ITSP) or a Realm. The purpose of this policy is to strip G726 from SDP as well as strip any video offering. The policy is given a name which references its actual purpose. This is something I tend to do quite frequently on the SD as the configuration can get quite large and this helps keep track of policies. The end result is that G711 will be the preferred codec offered in SDP to the ITSP.

```text

codec-policy
    name s          trip-726-video
    allow-codecs    g726:no pcmu video:no
    order-codecs    pcmu

```

After creating the codec-policy above we may associate it with a Session Agent so it is enforced.

```text

lab-sd4500# configure terminal
lab-sd4500(configure)# session-router
lab-sd4500(session-router)# session-agent
lab-sd4500(session-agent)# select

1. ITSP A
2. ITSP B
3. ITSP C

> 3

lab-sd4500(session-agent)# codec-policy strip-726-video
lab-sd4500(session-agent)# done
lab-sd4500(session-agent)# exit
lab-sd4500(session-router)# exit
lab-sd4500(configure)# exit
lab-sd4500# save-config
lab-sd4500# verify-config
No errors found
lab-sd4500# activate-config

```

Associating the policy with a Session Agent means all calls which traverse through that particular Session Agent will have the codec-policy enforced.  If the policy should be Realm specific rather than Session Agent specific then perform the following instead.

```text

lab-sd4500# configure terminal
lab-sd4500(configure)# media-manager
lab-sd4500(media-manager)# realm-config
lab-sd4500(realm-config)# select

1. Access
2. Core
3. Peering ITSP Core

> 3

lab-sd4500(realm-config)# codec-manip-in-realm strip-726-video
lab-sd4500(realm-config)# done
lab-sd4500(realm-config)# exit
lab-sd4500(media-manager)# exit
lab-sd4500(configure)# exit
lab-sd4500# save-config
lab-sd4500# verify-config
No errors found
lab-sd4500# activate-config

```

The examples provided only scratch the surface and are a basic introduction to the topic of codec policies. All of this and more may be found in the ACLI documentation. The Session Director is an incredibly flexible platform and I continuously find it fascinating how granular one can get when it comes to controlling their voice network.


