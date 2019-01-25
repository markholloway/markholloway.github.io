---
layout: post
title: Using tcpdump to troubleshoot SIP traffic
tags: [acme,sbc,sip]
---
Linux and macOS include `tcpdump` which is used to capture live network traffic. With the right command options it's easy to capture SIP call flows to view in Wireshark.

<!--more-->

The following command is run on Red Hat Linux and listens for SIP traffic on `port 5060` of the `eth1` interface.

```text

bwadmin@as1$ su
Password: ********
[root@as1 bwadmin]# tcpdump eth1 -w sip.pcap port 5060

```

Open the pcap in Wireshark and all SIP traffic captured will be displayed. Use the following filters to view specific calls.

```text

sip:+4045551000@telepacific.com;tag=887s

```

```text

tel:411

```

```text

#show SIP packets To or From this number
sip contains 4045551000

#show SIP packets To this number
sip.To contains 4045551000

#show SIP packets From this number
sip.From contains 4045551000

```

Filter by SIP call-id

```text

sip.Call-ID==20badbbf750c497a80d63ebb8a74a213

```

To save a specific call flow to its own pcap file user `Save As > Displayed`

If you need to view SIP calls in real-time on an IP PBX or SIP Softswitch platform you can use the `tail` command on the system's log file that writes the SIP messages.

Here is an example with Broadsoft BroadWorks and the XSLog file.

```text

bw_as1$ tail -f /var/broadworks/logs/appserver/XSLog2009.08.12-16.05.34.txt

```

As BroadWorks writes to the log file the output will be displayed in real-time in the Unix shell. 
