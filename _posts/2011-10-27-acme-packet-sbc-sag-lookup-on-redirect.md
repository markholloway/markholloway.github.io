---
layout: post
title: Acme Packet SBC sag-lookup-on-redirect
tags: [acme,sbc,sip]
---

In most cases a SIP Redirect Server simply responds to a SIP Invite with a `302 Moved Temp` message and provides multiple contacts in the Contact Header.  

<!--more-->

When this occurs, the device receiving the 302 Moved Temp message (such as an Acme Packet SBC) will attempt to contact (ie. send a SIP Invite) the first address in the `Contact Header`.  If that fails, it will send a SIP Invite to the next address, and if that fails, the process will continue until there are no more addresses remaining.  Although this provides some form of redundancy it is not necessarily the best approach. Utilizing call flow this way means there is no control over how calls could potentially be load balanced if desired (or required).  Also, if one of the devices in the Contact Header is offline, there is no knowledge of this by the SBC and it will continue to send SIP Invites regardless and wait for the timers to expire. Definitely a less than desirable behavior.  The last item to note is that if you need to send SIP Invites to a potentially large group of servers (20 or more) there is a chance the Contact Header will become so large this is going to cause the SIP message to become fragmented.  All of these pitfalls may be easily avoided.

The Acme Packet SBC has a feature called `sag-lookup-on-redirect`. Simply put, the Redirect Server provides just one address in the Contact Header and the SBC will match that to a Session Agent Group in its configuration.  The result is calls may be load balanced (Hunt, Round Robin, Least Utilized, Least Busy, Proportional Distribution) and the SBC has the benefit of knowing when a target address (Session Agent) is alive and healthy which means it is in-service, or if the target is offline or unhealthy and therefore the SBC demotes it to an out-of-service state.  When a Session Agent is in an out-of-service state the SBC will not to send SIP Invites to that particular destination.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-sag-redirect.png)

The feature sag-lookup-on-redirect is enabled through sip-config.

```text

PHOENIX# configure terminal
PHOENIX(configure)# session-router
PHOENIX(session-router)# sip-config
PHOENIX(sip-config)# sag-lookup-on-redirect enabled
PHOENIX(sip-config)# done

```

In order for the SBC to pro-actively determine if a Session Agent is in-service or out-of-service, configure OPTIONS ping for each Session Agent.

```text

session-agent
…
ping-method                    OPTIONS;hops=0
ping-interval                  60
ping-send-mode                 keep-alive

```

To view what Session Agents are in-service execute the following command:

```text

PHOENIX# show sipd agents

```

Now, when the SBC receives a 302 Moved Temp message it will load balance based on the chosen scheme.  If any Session Agents are out of service the SBC will not attempt to send a SIP Invite.  The SBC waits until three successful OPTIONS pings are received before declaring an agent in service again.  This is great as it helps prevent an endpoint from flapping on the network.

