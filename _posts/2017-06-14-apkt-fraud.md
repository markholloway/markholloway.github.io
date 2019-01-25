---
layout: post
title: Acme Packet SBC “fraud-protection” ACLI Command Configuration
tags: [acme,sbc,sip]
---
Acme Packet ECZ730m1 software introduces the ACLI command `fraud-protection`

<!--more-->

This allows the SBC to store multiple black lists, white lists, SIP redirect lists, and `rate limit` entries for fraud prevention and call control. Multiple lists may exist where entries are stored in separate XML files.

Lists (XML files) may be initially created through `ACLI` or web interface. If the preference is to manage lists manually then once a list is created it will need to be downloaded and the `XML` file(s) edited with a text editor, similar to managing Local Route Tables (LRT). Otherwise, all entries may be added, modified, or deleted using the web interface.

Below is an example of the GUI configuration elements for managing fraud-protection.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-fraud01.png)

![]({{ site.baseurl }}/blog/assets/apkt/apkt-fraud02.png)

![]({{ site.baseurl }}/blog/assets/apkt/apkt-fraud03.png)

Below is an example of creating a new fraud-protection `XML` file in the ACLI called `fraudProtect.xml`

```text

sbc# config t
sbc(configuration)# system
sbc(system)# fraud-protection
sbc(fraud-protection)# select
sbc(fraud-protection)# show
fraud-protection
    mode                            local
    file-name                       fraudProtect.xml
    options
    allow-remote-call-terminate     disabled

```

In the example below, the `Whitelist` section permits all calls based on the `From header` matching acmepacket.com through the realm called `peer`. Calls based on the `To header` to a specific UK phone number on any realm is represented by a wildcard `*`. 

The `Blacklist` section rejects calls based on a variety of criteria. Note that even though calls are blocked to `+44` based on the To header, calls to `+441189240000` are permitted since this is a more specific match in the Whitelist.

```text

<?xml version='1.0' standalone='yes'?>
<oracleSbcFraudProtectionApi version="1.0">
    <call-whitelist>
        <userEntry>
            <from-hostname>acmepacket.com</from-hostname>
            <realm>peer</realm>
        </userEntry>
        <userEntry>
            <to-hostname>+441189240000</to-hostname>
            <realm>*</realm>
        </userEntry>
    </call-whitelist>
    <call-blacklist>
        <userEntry>
            <from-hostname>robodialer.com</from-hostname>
            <realm>peer</realm>
        </userEntry>
        <userEntry>
            <from-hostname>208.57.21.10</from-hostname>
            <realm>peer</realm>
        </userEntry>
        <userEntry>
            <from-hostname>+14045551000</from-hostname>
            <realm>peer</realm>
        </userEntry>
        <userEntry>
            <from-hostname>+44</from-hostname>
            <realm>*</realm>
        </userEntry>
    </call-blacklist>
    <call-redirect>
    </call-redirect>
    <call-rate-limit>
    </call-rate-limit>
</oracleSbcFraudProtectionApi>

```

The command `show fraud-protection all` will show  fraud definitions and if any matches exist.

```text

sbc# show fraud-protection all

List Type   To/From     Match Value     Ingress Realm   No. of Hits
                                                        Recent  Total
.....................................................................
Blacklist   From        robodialer.com  level3          3       7
Blacklist   From        208.57.21.10    gx              10      23
Blacklist   From        +14045551000    orange          1       3
Blacklist   From        +44             bt              0       0
Whitelist   From        acmepacket.com  att             32      128
Whitelist   From        +441189240000   bt              5       7

             Total hits: 168
          Total entries: 6
Total displayed entries: 6
              File name: fraudProtect.xml

```

The command `show fraud-protection stats` show a summary version of matches.

```text

Fraud Protection Engine State   ---- Lifetime ----
                                 Recent   Total   
Blacklisted Calls                     14       33
Whitelisted Calls                     37      135
Ratelimited Calls                      0        0
Redirected Calls                       0        0
Blacklist Rejected Calls               0        0
Ratelimit Rejected Calls               0        0

```

