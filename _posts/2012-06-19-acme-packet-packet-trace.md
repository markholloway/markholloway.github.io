---
layout: post
title: Configuring “packet-trace” SIP on the Acme Packet SBC
tags: [acme,sbc,sip]
---

The `packet-trace` ACLI command allows the Acme Packet SBC (Session Director) to capture SIP signaling communication between two endpoints and send the capture to external server such as Wireshark.The SBC uses the network interfaces (ie. media interfaces) to send the capture. 

<!--more-->

The first step is to configure a capture receiver.  This tells the SBC what interface is used for the mirrored packets and the target IP of the `Wireshark` server. The network-interface is the SBC’s `network-interface` and `sub-port ID`.

```text

capture-receiver
    state                   enabled
    ip-address              10.12.135.150
    network-interface       m00:0

```

The next step is to identify what `IP` and `ports` the SBC should listen to in order to send the packets to Wireshark. If no ports are identified then the SBC listens on all ports.

```text

PHOEN?IX# packet-trace start Access:0 217.154.63.10 5060 5060 
Trace start for 217.154.63.10

```

Even though it is not required to specify the local and remote TCP/UDP ports  it’s always a good idea to be as specific as possible when defining captures so only the required data is captured. At this point any calls coming into the SBC that involve the `IP 217.154.63.10` on `TCP` or `UDP` port `5060` are going to trigger the capture and packets will be sent to Wireshark. Sixteen concurrent traces can be running at once.

One thing to note is the capture is sent to Wireshark using RFC 2003 (IP to IP encapsulation) as opposed to relaying SIP on port 5060. This means Wireshark needs to be configured to listen for RFC 2003 packets and then it will decode them. Use the ip.src filter to display only the encapsulated SIP packets
