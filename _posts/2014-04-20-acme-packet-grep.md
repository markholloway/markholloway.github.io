---
layout: post
title: How to “grep” the Acme Packet SBC Configuration (ACLI)
tags: [acme,sbc,sip]
---
The grep tool is a very popular Unix command line utility used to match a regular expression. Although `grep` doesn’t specifically exist on the Acme Packet SBC the `find` command serves a similar purpose.  This feature was introduced in ACLI release 6.4.

<!--more-->

```text
NNOS-SD# find [configuration | running-config | command]  [attribute]

NNOS-SD# find ?

<string>                find the specified string
command                 find command within menus
configuration           find in editing configuration
running-config          find in running configuration

```

My SBC has a `realm` called `Access` and I want to know where Access resides in the configuration

```text

NNOS-SD# find running-config Access

session-router -> local-policy [Access; *; *]
source-realm Access
description Access to Core

system -> network-interface [s0p0:0]
description Access

media-manager -> realm-config [Access]
identifier Access

session-router -> sip-interface [Access]
realm-id Access

media-manager -> steering-pool [72.12.135.250=16384+Access]
realm-id Access

Found 6 instances

NNOS-SD# find running-config Core

session-router -> local-policy [Access; *; *]
description Access to Core

session-router -> local-policy [Access; *; *] -> local-policy-attribute [Core; SAG:BW-APP-SERVERS]
realm Core
realm Core

system -> network-interface [s1p0:0]
description Core

media-manager -> realm-config [Core]
identifier Core

session-router -> session-agent [as1]
realm-id Core

session-router -> sip-config
home-realm-id Core

session-router -> sip-interface [Core]
realm-id Core

media-manager -> steering-pool [10.12.135.250=16384+Core]
realm-id Core

```

I want to know what configuration elements support `local-policy`

```text

NNOS-SD# find local-policy
Command menu
(root) show configuration local-policy
(root) show running-config local-policy
(configure) session-router local-policy

Running configuration

Found 3 instances
NNOS-SD#

NNOS-SD# find force
Command menu
(root) halt force
(root) reboot force
(root) reboot fast force
(root) show configuration enforcement-profile
(root) show running-config enforcement-profile
(configure) media-manager realm-config enforcement-profile
(configure) session-router enforcement-profile
(configure) session-router session-agent enforcement-profile
(configure) session-router session-router force-report-trunk-info
(configure) session-router sip-config enforcement-profile
(configure) session-router sip-interface enforcement-profile

```