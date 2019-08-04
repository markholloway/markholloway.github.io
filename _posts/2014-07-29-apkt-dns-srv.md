---
layout: post
title: Acme Packet SBC and DNS-SRV Load Balancing “ping-all-addresses”
tags: [acme,sbc,sip]
---
The Acme Packet SBC supports the ability to `load balance SIP traffic` several difference ways. Simply stated, a SIP invite will ingress to the SBC. The SBC will lookup the destination and if it results in a Session Agent Group or `SAG` configuration with two or more `Session Agents`, the SBC will egress the SIP invite using one of the selected load balancing algorithms such as Least Busy.

<!--more-->

The SBC also supports `DNS SRV` service records for load balancing. For those not familiar with DNS SRV, it’s a form of DNS that allows a single domain name (associated with a service and protocol) to resolve to many possible destinations. The destinations may be `equal` or `weighted differently`. The following is an example of a DNS SRV record for SIP over UDP looks like. In this case all records have an equal weight of 10.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-dns-srv01.png)

The domain name `sip.apkt.com` will resolve to five different A records. The lookup must be a DNS SRV lookup for this to resolve correctly. In this case we are using `SIP over UDP` as the service which has been defined in Bind.

Here is how to `enable` DNS SRV load balancing on the SBC. Note this complies with RFC 3263 “Locating SIP Servers”. Once the config has been saved and actives the SBC will `ping` the address resolved by sip.apkt.com to see which IP’s are in service.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-dns-srv02.png)

Now when a SIP Invite `ingresses` the SBC and matches a `local-policy` where the destination next-hop utilizes DNS SRV load balancing the traffic will be balanced across `all nodes`.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-dns-srv03.png)
