---
layout: post
title: Cisco IOS hidden gatekeeper debug command
tags: [cisco]
---
The following undocumented command is useful for `debugging H323` messages.  This command cannot be found in the help-context of IOS as noted below.
<!--more-->

```
router# debug gatekeeper main 10

router# debug gatekeeper ?
gup Gatekeeper GUP messages
load Gatekeeper load-balancing messages
servers Gatekeeper Servers

The great thing about this command is the simplicity in the debug output.

```