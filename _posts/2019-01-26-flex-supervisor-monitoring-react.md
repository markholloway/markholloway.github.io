---
layout: post
title: How to use “Conditional Logging” on the Acme Packet SBC
tags: [acme,sbc,sip]
---
With the relase of Acme Packet OS 7.x one of the most useful new features is `Advanced Logging`. 

<!--more-->

This is similar to `debug output` in a log file without having to enable full debug, which can drain CPU on just about any system. By setting a `condition` (or set of conditions) the SBC will capture the interesting traffic to a log file.

The Advanced Logging feature was created using Session Plugin Language (SPL). For those not familiar with SPL it is a `LUA` based scripting language for the SBC. SPL provides an easy way to expand the SBC’s capabilities.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-logging01.png)

By adding the additional line below only calls `from 4045551212` that route `to 7815551212` will be logged.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-logging02.png)

When finished it is recommended to `disable` advanced-logging using `spl stop sip advanced-logging`

It is possible to create different Advanced Logging profiles so they may be easily reused at another time without manually entering complex strings each time logging is enabled.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-logging03.png)

The following are the advanced-logging options which may be set.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-logging04.png)