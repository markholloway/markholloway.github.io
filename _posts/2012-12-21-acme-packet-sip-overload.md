---
layout: post
title: Acme Packet SBC IP Endpoint Registration (avoiding SIP overload and registration flooding)
tags: [acme,sbc,sip]
---
BGP Route flaps, accidental fiber cuts, equipment failure, these are all things that trigger `outages` and cause traffic to behave erratically and unpredictably. 

<!--more-->

In the moment of crisis, a five minute voice outage feels like an eternity. What many people do not realize is, just when the network begins to `normalize` itself, this will cause a massive SIP registration flood pouring into the network as potentially hundreds of thousands of endpoints (or more) will send their SIP registrations which would typically severely spike CPU on the Softswitch infrastructure, thus causing a second outage for the VoIP network.

There are ways to protect the core network with the Acme Packet SBC. The Acme Packet `Net-SAFE` architecture definitely warrants its own deep dive discussion and is the official word on SBC security. It’s not my intention to try and cover it here. However, having worked with similar topologies and dealing with short, bursty outages where endpoints disappear for anywhere from 3 to 15 minutes then come back in massive waves, there are a couple of simple steps one can take to keep the network healthy and avoid a second outage due to a SIP Registration Overload condition occurring after the network layer has resolved itself..

The following is a simple example of a Hosted IP PBX topology where `SIP endpoint registration` is targeted to an Acme Packet Session Load Balancer `(SLB)` which distributes the registrations to multiple SBC cluster members. Typically the cluster members are geographically located in different cities, states, or countries, supporting millions of subscribers (this scenario only shows three cluster members, but more are supported by the SLB).

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb01.png)

Now lets say that all of a sudden the Internet experiences a `BGP route flap`. That’s at least 3 minutes of downtime while the routers converge. The SIP phones will lose the ability to communicate with the SBC and the cached SIP Registrations in the SBC will expire and be flushed out. In Hosted NAT Traversal environments it is common for the SIP registration `expires timer` in the `Contact header` to be set anywhere from 60 – 180 seconds by the SBC.  The reason for the low number is the SBC wants the Firewall to keep the UDP ports open. Firewalls tend to close them quick and since the SBC detects that the phone is behind NAT, it forces the registration to occur more frequently. Otherwise, if the Firewall close the UDP ports, the phone will not be able to receive calls.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb02.png)

Without utilizing any additional `sip-config` options in the SBC configuration, the SBC will forward all the registrations it receives from the SIP Endpoint to the core Softswitch when network service is back up and running. Note that if recommended DDoS security settings are in place (ie. Net-SAFE) the SBC will gracefully throttle the traffic entering the core so the Softswitch infrastructure does not get overwhelmed. The important things to note here is if a SIP registration cache entry expires, the SBC will forward the “new” registration to the core Softswitch once the network has normalized (as shown below). This could easily result in a flood of registrations happening all at once and put the Softswitch at risk.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb03.png)

By utilizing the `register-grace-timer` option under sip-config, the Acme Packet SBC will extend the life of the cached registration entries. Typical settings are between 600 and 900 seconds. The result is that when there is a network outage and SIP endpoints lose their connectivity to the SBC, the SBC will keep the binding of the endpoint in its cache. When the network is restored and all the SIP endpoints are able to communicate successfully with the SBC again (within the register-grace-timer period) there is no need for the SBC to forward all these registrations to the core Softswitch again. The Softswitch has no knowledge that an outage on the Public network occurred since the SBC is doing all the topology hiding and registration management that interfaces to the core.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb04.png)

Adding the following will enable the `register-grace-timer` value for `900 seconds`.

--pic

So far the solution outlined above work great when SIP endpoints have a single ingress point into the network (Session Load Balancer) and the SBC cluster members are geographically dispersed in different cities, states, or countries.

The next example shows a topology where the Service Provider may have two different SBC pairs in two different geographic locations. In this case SIP Endpoints rely on `DNS SRV records` (or multiple static IP entries in the phone configuration files) to reach these SBC’s. The condition to consider here is intermittent network behavior. The network isn’t necessarily down hard where all endpoints would simply fail over to the second site. Instead, the primary site is flapping up and down, so phones are intermittently flapping their SIP registration between the primary and secondary sites.

The following is an example of a deployment where each site has its own independent High Availability pair of Acme Packet SBC’s. SIP Endpoints rely on DNS SRV records to support registration failover between Site 1 and Site 2.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb05.png)

The unfortunate and somewhat dysfunctional behavior in this topology is some SIP endpoints do not honor the `expires= timer` value sent by the SBC in a `200 OK` response to their SIP registration. For example, if the SBC sends expires=180 seconds for the registration refresh, some endpoints reduce the value by as much as 50% and  send their registration at 90 seconds instead of 180 seconds. The law of SIP (RFC 3261) states that a SIP Endpoint should attempt the primary IP each time it tries to register. During an intermittent outage what will happen is the SIP endpoint is already registered with a cached entry at the primary site, then 90 seconds later fails to the secondary site, then 90 seconds later may fail back to the primary site again, then perhaps a fourth time to the secondary site again. Of course this leads to issues if the register-grace-timer is set since the registrations are cached and as a result will not be forwarded to the Softswitch again.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-slb06.png)

If the `register-grace-timer` is set to a value higher than 0 like the previous example where we used a value of 900, the SBC maintains the registration cache entry even though it has expired. For this particular topology, the register-grace-timer should be set to 0. This is critical when the SIP Endpoint flaps back and forth between the two sites, the registration will now be seen as a “new” entry anytime the SIP Endpoint is moving between sites. It’s not the ideal behavior we would like to see, but at minimum the SIP Endpoint is able to support Inbound and Outbound calls without completely failing.

Depending on which Softswitch vendor you are using, it may also be useful to add the `force-unregistration` option in sip-config. This way when the registration cache entry expires in the SBC, the SBC will also notify the Softswitch of the expired entry so it is removed and no SIP Invites are forked to both SBC’s when the subscriber receives a call.

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

