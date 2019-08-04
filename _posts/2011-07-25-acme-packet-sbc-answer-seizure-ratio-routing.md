---
layout: post
title: Acme Packet SBC Answer Seizure Ratio Based Routing
tags: [acme,sbc,sip]
---

Answer to Seizure Ratio `(ASR)` is a term used in Telecommunications and helps determine when new call setup attempt should be routed to an alternate destination. The definition of ASR is the number of successfully answered calls divided by the total number of calls attempted `(seizures)` multiplied by 100. The formula is (Answer / Seizure) * 100 = AnswerSeizureRatio.

<!--more-->

Normally when an SBC initiates a SIP Invite to a peer and receives a `SIP 503 Service Unavailable` message in return the SBC will attempt another call setup to a secondary destination (Session Agent) automatically.  However, using an example such as busy signals, they not considered “failures” by a SIP device, yet there could be an upstream outage somewhere causing an unexplained amount of SIP 600 Busy messages being returned that is starving the Telecom network from completing calls. Since the Acme Packet SBC has the ability to route based on a configured ASR threshold, call may easily be routed to another destination if the configured ASR value falls below a specified threshold. Nice!

The place to `configure ASR` is within a `Session Agent`.  By defining a minimum (acceptable) ASR value, the SBC computes ASR as it makes routing decisions.  Using the formula first mentioned above, the SBC is calculating the number of successfully answered calls on a Session Agent and dividing by the total number of calls attempted. If the ASR constraints are exceeded, the Session Agent goes out of service for a configurable period of time and all traffic is routed to a secondary Session Agent (via a Local Policy which has the same Next-Hop but with a higher cost).

The two ASR parameters within a Session Agent are `minimum seizure` and `minimum ASR`.

Minimum Seizure determines if the Session Agent is within it’s normal constraints. For example, if 5 call attempts (seizures) have been made to a Session Agent and none have been answered, and the min seizures is set to 5, then on the 6th failed attempt the Session Agent will be marked as having exceeded its constraints and will be marked out of service.

Minimum ASR is considered when making routing decisions. If some or all of the calls to the Session Agent have been answered, the min ASR value is considered to make the routing decision. For example, if you set the Minimum ASR to 50% and the Session Agent’s ASR for that window falls below 50%, the Session Agent is marked as having exceeded its constraints and calls will not be routed to it until the time-to-resume has elapsed.

The time-to-resume element tells the SBC how long (in seconds) a `Session Agent` should be considered out of service once constraints have been exceeded.

```text

session-agent
...
    hostname        sip.markholloway.com
    min-seizures    5
    min-asr         50
    time-to-resume  300

```

Possible values for min-seizures range from 1 to 999999999. The default value is 5.

Possible percentage values for min-asr range from 0 to 100. The default is set to 0.

Networks where two or more egress paths exist on the VoIP network should consider using ASR based routing to provide the greatest level of network availability during a potential network congestion-outage related issue.
