---
layout: post
title: Active Directory based Call Routing on the Acme Packet SBC
tags: [acme,sbc,sip]
---
Many Enterprises have migrated to `SIP Trunking` for PSTN access. For an Enterprise with a single IP PBX platform and an SBC on the edge, call routing from the PSTN to the internal network is typically very straight forward because all DID’s point to one IP platform.

<!--more-->

Example of a common `SIP Trunk` model

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad01.png)

When another SIP communication platform is introduced into the Enterprise topology it raises the question of what IP platform is considered the call routing decision maker for calls coming from the PSTN SIP Trunk.

This is an example of a less-than-desirable implementation.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad02.png)

Usually one of these is the common way an Enterprise integrates their IP PBX with another IP platform (such as Lync):

* All calls go to the IP PBX and then `fork` to Lync

* All calls go to Lync and use Lync’s `Simultaneous Ring` feature to ring the IP PBX

* SBC `forks` the SIP Invite to the IP PBX and Lync simultaneously

Although many IP PBX’s deployed with Lync use one of the above methods, there is a much better way for this integration to occur.

The Acme Packet SBC supports `Active Directory` integration for call routing decisions. The beauty of this is in most organizations Active Directory is already used to store various phone numbers for users within the Enterprise.

When the `local-policy` is configured to support Active Directory (LDAP) and a SIP Invite is received from the PSTN, the SBC will query Active Directory to see if the phone number is assigned to a user.  If it is, the SBC will see if it’s part of the Active Directory field attribute `telephoneNumber` for a desk phone, or `msRTCSIP` for a Lync phone number. Other attributes are supported and are explained further in this discussion.

This is an example of an Active Directory query from the SBC to determine if the call should be sent to CUCM or Lync.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad03.png)

In a similar regard to the above diagram, if the dialed digits are the Lync phone number and the Active Directory query shows the dialed digits belong to the msRTCSIP attribute, the Acme Packet SBC knows the `next hop` should be the realm and session agent for Lync.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad04.png)

This is where the power of Active Directory integration in the SBC becomes very interesting..

The Acme Packet SBC’s `local-policy` may be configured in such a way that if the dialed digits +1-404-555-1000 match telephoneNumber in Active Directory, but msRTCSIP is also populated with a separate Lync phone number (in this case +1-404-555-9595) the SBC’s local-policy preference will route the call to Lync instead of the IP PBX. If msRTCSIP is not populated, the call will simply route the to the IP PBX. This is a very flexible way of handling call routing. What this comes down to in this particular case is an environment where some users are exclusively on CUCM and others are CUCM and Lync, but the Enterprise may want Lync users to always receive calls on Lync first regardless of the dialed digits coming from the PSTN.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad05.png)

Now for even more flexibility..

The Acme Packet SBC may also be configured in such a way that it recognizes both `telephoneNumber` and `msRTCSIP` being populated, each with their own phone numbers, but if the SIP Invite to the first platform experiences a SIP Invite timeout or failure, a SIP Invite may be sent to the `next destination`. You are not limited to just two destinations.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad06.png)

Finally, having calls `reroute` to the `PSTN` during an internal network outage is also possible by using the Active Directory attribute field `mobile`. If this field is populated and the SBC’s local-policy is setup to recognize the digits in the mobile field, calls that fail to setup internally (in this case, to Lync and the IP PBX) may route back out the PSTN SIP Trunk to the user’s mobile phone.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad07.png)

Configuration examples:

The two critical configuration elements to examine for Active Directory integration are `local-policy` and `ldap-config`.

First we will look at local-policy. This is very straight forward as the only difference when using Active Directory integration is the next-hop policy-attribute will reference ldap.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-adconf01.png)

The next configuration element to talk about is `ldap-config`. This is where you define the Active Directory criteria and how call routing should be handled. You may have have more than one ldap-config on the SBC.

The example below is similar to our simple SIP Trunk diagram at the start of this blog post. There is a single IP PBX platform on the internal network. However, the mobile field in Active Directory is also populated with digits. The way this local-policy is configured, if a SIP Invite timeout occurs to CUCM, the `policy` will `reroute` the failed call back out the SIP Trunk to the Active Directory user’s mobile number.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-adconf02.png)

In this next example the local-policy uses the `attribute order`. This means if the dialed digits match an IP PBX phone number (telephoneNumber) but the user also has a Lync phone number populated in Active Directory under msRTCSIP, send the SIP Invite to Lync.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-adconf03.png)

As you can see from the above example one of the most useful elements in the ldap-cfg-attributes is the use of regular expressions for phone number formatting.

Other cool features in 6.4f1:

Support for `RFC 6341` (SIP-based Media Recording – aka SIPREC) on the Linux version of the Acme Packet SBC.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-ad08.png)