---
layout: post
title: Retrieve Music on Hold files from CUCM and stream from router flash
tags: [cisco]
---
This is a brief explanation of how to retrieve the `MoH` or Music on Hold files from Cisco Unified Communications Manager 7 and load the files into a router’s flash for remote-site streaming directly from the router.  
<!--more-->

Alternatively, if you have `CME` or Call Manage Express and do not care about using a `G729` audio file then you may use music-on-hold.au file which makes this entire task much simpler. The only difference between audio files from UCM versus CME is the actual music that is played.  UCM plays a style of music that is along the lines of the New Age genre and CME uses a song where a piano is the main instrument.

## Part 1:

In order to complete this process you must have `SFTP` or Secure FTP server available on your network and reachable by the UCM Publisher or Subscriber.  If you don’t already have an SFTP server on your network you can use CentOS, FreeBSD, RHEL, Mac OS X, or any Unix-based platform where SFTP is natively part of the OS.

The same principle applies whether you want the `G711` or `G729` file.  In this example I show how to retrieve the G729 file.

Perform the following steps.

1. SSH to the UCM Publisher or Subscriber node.
2. Enter the following command file list activelog mohprep/* and note the list of files displayed.
3. In this case we want to SFTP the file SampleAudioSource.g729.wav to our SFTP server
4. Enter the following command file get activelog mohprep/SampleAudioSource.g729.wav
5. The following information will be displayed. Enter the appropriate SFTP information when prompted.

```

Please wait while the system is gathering files info …done.
Sub-directories were not traversed.
Number of files affected: 1
Total size in Bytes: 2702728
Total size in Kbytes: 2639.3828
Would you like to proceed [y/n]? y

SFTP server IP: 177.1.10.2
SFTP server port [22]:
User ID: mark
Password: *********

.
Transfer completed.

```

At this point the file SampleAudioSource.g729.wav now resides on the SFTP server.  Copy this file to a TFTP server and issue the command copy tftp flash on the router the file should reside on.  In my case the same Linux server used for SFTP is also a TFTP server.  Any Unix-like OS is capable of supporting SFTP and TFTP.

```
router# copy tftp flash
Address or name of remote host []? 177.1.10.2
Source filename []? SampleAudioSource.g729.wav
Destination filename [SampleAudioSource.g729.wav]?
Accessing tftp://177.1.10.2/SampleAudioSource.g729.wav…
Loading SampleAudioSource.g729.wav from 177.1.10.2 (via Serial0/3/0.1): !!
[OK - 332600 bytes]

332600 bytes copied in 51.848 secs (6415 bytes/sec)

```

## Part 2:

In the event the branch router should stream MoH directly from the router’s flash rather than utilize the WAN to support unicast or multicast MoH between UCM and the branch site, you must configure SRST and the relevant multicast and moh parameters on the router.  It is important to note that in order to accomplish this there must be a MoH Server configured on UCM to support multicast.  This server should have a Max Hop of 1 and be assigned to a Media Resource Group (such as MRG_BR1) which should be assigned to a Media Resource Group List (MRGL_BR1) and the MRGL should be assigned to the Device Pool for BR1 (DP_BR1). Make sure the MoH server in UCM uses 239.1.1.1 in order to match the example router configuration below.  Increment multicast by IP rather than port.

On the router:

Voice VLAN Interface IP = 172.16.1.1
Loopback 0 Interface IP= 172.16.254.254

Enter config mode on the router and enable multicast routing

```

ip multicast-routing
interface vlan 4 < Voice VLAN
ip pim dense-mode
interface loopback0
ip pim dense-mode

Enable call-manager-fallback or use telephony-service in SRST mode

call-manager-fallback
max-ephones 1
max-dn 1
ip source-address <voice vlan>
moh music-on-hold.au
multicast moh 239.1.1.1 port 16384 route 172.16.1.1 172.16.254.254

ccm-manager music-on-hold bind loopback 0

```

UCM believes the multicast stream only requires one hop to reach the destination.  Since this is not possible because the branch router is more than one hop from UCM, the audio file referenced in Flash by SRST will begin a multicast stream.  When phones put a call on hold the music streamed from Flash is what the held party will hear (including PSTN callers). For sites with low bandwidth requirements this helps reduce overall bandwidth consumption.  It also provides flexibility for the branch site to use their own custom audio files without the extra work of importing them into UCM.

If the branch router is configured as an H323 Gateway with CUCM then perform the following additional steps and add relevant dial-peers that include G711.  This is required if the MoH stream in CUCM in configured for G711 and the router thinks in needs to stream multicast G711 MoH from CUCM even though we are doing it from flash because we have invoked it through SRST.

```

voice class codec 1
codec preference 1 g711ulaw
codec preference 2 g729r8

dial-peer voice 10 voip
description TO UCM SUBSCRIBER NODE
preference 1
destination-pattern 2…$
voice-class codec 1
session target ipv4:10.10.10.1
dtmf-relay h245-alphanumeric
no vad

dial-peer voice 11 voip
description TO UCM PUBLISHER NODE
preference 2
destination-pattern 2…$
voice-class codec 1
session target ipv4:10.10.10.2
dtmf-relay h245-alphanumeric
no vad

```

Issue the following debug command to validate the MoH multicast stream:

```
debug ephone moh
```
