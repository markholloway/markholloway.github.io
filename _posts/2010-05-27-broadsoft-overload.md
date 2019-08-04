---
layout: post
title: Broadsoft Extreme Overload Controls
tags: [broadsoft,sbc,sip]
---
The `BroadWorks` platform uses an enhanced algorithm called Overload Control to offer protection when a cluster node is under severe conditions. The goal is that during an overload period of 150% the throughput will be no less than 90%. 

<!--more-->

Behavior of the `Application Server` is dependent upon a series of configuration parameters configured through `bwcli`.  Extreme overload control provides message throttling at the decoding and encoding queues. The maximum packet age used during overload is different from that used during non-overload. Both the maximum packet age and maximum packet age during overload are configurable via the CLI.

Example:

```text

AS_CLI/System/OverloadControls> get
enabled = true
mgcpOverloadAction = error
sipOverloadAction = error
percentMemoryInUseToEnterYellow = 85
percentMemoryInUseToEnterRed = 90
percentMemoryInUseToLeaveYellow = 85
percentMemoryInUseToLeaveRed = 85
allowEmergencyCallsInOverload = true
maxPacketAgeInMsecs = 3000
maxPacketAgeDuringOverloadInMsecs = 1500

```

One of the most critical parameters to configure is the `sipOverloadAction`.  This determines how Broadworks will respond during a period of an Overload. The three possible options are:

* drop (silently discarded)
* redirect (302 Move Temp)
* error (503 Service Unavailable)

I do not recommend using `drop` as this is the least graceful approach and will cause the User Agent Client to rely on its SIP expiration timer before initiating additional SIP messages.  While `error` should be a viable option it does not guarantee the UAC will reattempt another SIP invite upon receiving a SIP 503 Service Unavailable message.  My recommendation and current best-practice is to use `redirect`.  The Broadworks Application Server (AS1) will respond to the UAC with the address of the secondary Application Server (AS2) in the `SIP contact header`. The remaining dialog between the UAC and UAS will be carried out through AS2.

** NOTE: Registration Time Extension

During overload a `SIP REGISTER` messages may be discarded. To reduce the chances that a user’s registration is no longer valid (and cannot receive or possibly make calls), the extension should be set based on expected overload time, which is typically at least twice the non-callp minimum time in zone.

** Emergency Calls

If the system is configured to allow emergency calls during overload, then originations matching the call type `Emergency` in the system calling plan are allowed to progress.

** Summary

Extreme Overload Controls are an important element for all Broadworks deployments. Setting the proper thresholds between the `Yellow` and `Red Zones` will provide the appropriate alarming and graceful call redirection while at the same time notifying an administrator when the platform is reaching its capacity for growth.

