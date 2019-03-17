---
layout: post
title: Cisco IOS, DNS lookups, and typos
tags: [broadsoft,linux,sip]
---
If you have ever logged into a Cisco router and mis-typed a command such as `pign` instead of `ping` you know it can be frustrating while the router attempts to resolve the typo by performing a dns lookup. 
<!--more-->

Adding `no ip-domain lookup` is the first configuration change most people think of as a way to prevent the issue. However, if your router relies on dns this permentnatly disables the capability.

The reason `IOS` tries to resolve a mis-typed word using dns is the default behavior of the router is to try and connect using `telnet` and it's attempting to reolve the name to an IP address. 

The best way to fix the dns issue is change `vty` so telnet is not the default action. 

```

router# config t
router(config)# line vty 0 4
router(config-line)# transport preferred none

```

This allows the router to continue to use dns, but if the first entry in the command line is not a valid IOS command the router will return `invalid input detected` rather than trying to resolve it with dns.
