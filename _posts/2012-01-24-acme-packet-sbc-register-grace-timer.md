---
layout: post
title: Acme Packet SBC Register Grace Timer
tags: [acme,sbc,sip]
---

The Acme Packet SBC contains an optional parameter that may be added to the configuration which helps avoid a `SIP avalanche` from occurring.  

<!--more-->

One instance of a SIP avalanche is when a very large number of SIP endpoints consecutively send SIP registrations to an SBC which then forwards them to a SIP registrar. This can be dangerous for both the registrar and the SBC depending on how many endpoints are attempting to register. Assuming `DDoS` is applied to the SBC configuration, it will protect itself as well as the SIP registrar from being negatively impacted by the avalanche.

The following scenario shows how endpoints typically behave when they NAT through a firewall. Normally the firewall will NAT the layer 3 IP address but the layer 7 (SIP) address remains the private address. Upon receiving the NAT’d registration the SBC forwards the register message to a SIP register platform and after an exchange of a few messages between the registrar and endpoint a `200OK` is sent from the registrar back to the endpoint with a register expires of 3600 seconds (default for Broadworks). The SBC knows the SIP endpoint is behind NAT and changes this timer from 3600 to something shorter (60 seconds is common).

![]({{ site.baseurl }}/blog/assets/apkt/apkt-grace01.png)

Envision a scenario where the Internet is experiencing a route flap which is causing endpoints to lose connectivity to the SBC. If the endpoints should register every 60 seconds and they fail to do so, the SBC will delete them from the registration cache. If perhaps five minutes later the Internet is restored and the endpoints are able to communicate with the SBC again they would have to complete the entire registration process again. This would trigger a `SIP avalanche` that may negatively impact the core SIP network.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-grace02.png)

By implementing the option `register-grace-timer` parameter to the global SIP config and specifying a number of seconds,the SBC will retain the cached entries rather than let them expire even if the endpoint registration isn’t received. Once the endpoints come back after the Internet outage is resolved and they send a SIP registration to the SBC, the SBC will not forward this to the core because the previous registration remains valid in the SBC cache. This prevents the SBC from having to go through the entire registration process thus reducing the overhead involved on both the SBC and SIP registrar.

In this example the timer is set to 300 seconds. If endpoints are supposed to send their registration every 60 seconds but the SBC is not receiving them, it will retain the reg cache entry for another five minutes.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-grace03.png)

The diagram above demonstrates that even though the Internet is restored and endpoint registrations are reaching the SBC, there is no need for the SBC to forward these registrations to the SIP registrar since the `reg-cache` was retained during the outage. This prevents CPU cycles from being unnecessarily used on both the SBC and SIP registrar.

```text

sip-config
    state               enabled
    operations-mode     dialog
    dialog-transparency enabled
    home-realm-id       Core
...
    options             cache-challenges
                        max-register-forward=500
                        max-register-refresh=600
                        max-udp-length=0
                        reg-cache-mode=from
                        reg-overload-protect
                        register-grace-timer=300
                        reject-register-refresh
                        set-inv-exp-at-100-resp

```

![]({{ site.baseurl }}/blog/assets/apkt/apkt-grace04.png)

The diagram above demonstrates that even though the Internet is restored and endpoint registrations are reaching the SBC, there is no need for the SBC to forward these registrations to the SIP registrar since the reg-cache was retained during the outage. This prevents CPU cycles from being unnecessarily used on both the SBC and SIP registrar.
