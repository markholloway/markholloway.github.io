---
layout: post
title: Acme Packet SBC and Useful ACLI Commands
tags: [acme,sbc,sip]
---

Recently someone asked what some of the most useful commands are on the Session Director after performing a fresh install/configuration of an SD.  The following was provided by one of the Acme Packet Systems Engineers in response to the inquiry.

<!--more-->

`show sipd sessions all` – Will display all of the active SIP sessions that are currently traversing the SBC, including the To, From, Call-ID

`show sipd invite` – Will display a chart of all recent SIP requests and responses

`notify sipd siplog` – Enables the sipmsg.log which includes all SIP traffic traversing the SBC..only to be used in pre-production/trial environment

`show logfile sipmsg.log` – Will output the contents of the sipmsg.log without having to FTP this file off the SBC

`notify sipd rotate-logs` – Will clear all sipd log buffers

`display-alarms` – Alarm log output

`show running-config` – Outputs all of the configuration elements

`show support-info` -  Outputs all of the system level info, including hardware specifics, licensing info, etc

`show health` – For a standalone system will give a good overview of failover history

I would also like to add the following which I think are useful in some cases.

`show prom-info all` – Displays serial number, hardware revision, manufacturing date

`notify sipd debug` – Enables a subset of the full logging behavior of sipd on the Session Director

`notify sip nodebug` - Turn off debug

`log-level sipd debug` – Enable full debug logs

`log-level sipd notice` – Turn off full debug

`show version` - Displays SBC current software version

The log file generated in both cases is log.sipd


