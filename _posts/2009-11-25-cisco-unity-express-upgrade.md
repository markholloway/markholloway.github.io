---
layout: post
title: CUE Upgrade (Cisco Unity Express 7)
tags: [cisco]
---
I acquired a used `CUE` module running CUE 2.1.2 and wanted to proceed upgrading the module to CUE 7.0.3.  The only way to upgrade CUE is through FTP.  Here is the procedure.
<!--more-->

First thing I needed to do was install `vsftpd` on my RHEL 5 Client Workstation.  If you are running CentOS or Fedora you may already have vsftpd installed or you can easily install it using YUM.  The yum repository for RHEL5 Client Workstation does not include the option to install vsftpd through yum but you can login to your Red Hat account on their web site and search ‘vsftpd’ and there is an RPM you may download and install (with no dependency problems).

```bash

rpm -ivh vsftpd-2.0.5-16.el5.x86_64.rpm to install vsftpd

man vsftp to read the very short manual

chkconfig vstpd on to start vsftpd on bootup

service vsftpd stop|start|restart to reload the service at any time

#Default ftp root directory is /var/ftp

cd /etc/vsftpd

```

Open vsftpd.conf and allow anonymous users (not required but makes things easier)

From Cisco’s CCO page navigate to Cisco Unity Express 7.0.3 and download `cue-vm-k9.nm-aim.7.0.3.zip`. This file is for NM-CUE and AIM modules and there is a different zip file for NME-CUE. You also must download the appropriate license files for the number of mailboxes you are using and the IVR ports if applicable. I also had to include the specific language file cue-vm-en_US-langpack.nm-aim.7.0.3.prt1 in my FTP folder or the installation would fail regardless of the language pack being present. Extract all the zip files into the /var/ftp folder on your FTP server.

Log in to your CME router populated with the CUE module.  You will need to open a session through enable mode (not config mode). You should already have your service-engine and service-module parameters configured. IP 177.3.11.1 is the default gateway on my router and 177.3.11.254 is the IP I have assigned to my CME service module.

```

interface Service-Engine1/0
ip unnumbered Vlan11
service-module ip address 177.3.11.254 255.255.255.0
service-module ip default-gateway 177.3.11.1

router# service-module service-engine 0/1 session
Trying… Open

cue# show software version
Cisco Unity Express version 2.1.2

Be sure you can ping your FTP server form the CUE command prompt.

cue# ping 177.3.11.2
PING 177.3.11.2 (177.3.11.2) 56(84) bytes of data.
64 bytes from 177.3.11.2: icmp_seq=1 ttl=255 time=0.506 ms
64 bytes from 177.3.11.2: icmp_seq=2 ttl=255 time=0.287 ms
64 bytes from 177.3.11.2: icmp_seq=3 ttl=255 time=0.252 ms
64 bytes from 177.3.11.2: icmp_seq=4 ttl=255 time=0.257 ms
64 bytes from 177.3.11.2: icmp_seq=5 ttl=255 time=0.272 ms

— 177.3.11.2 ping statistics —
5 packets transmitted, 5 received, 0% packet loss, time 2ms
rtt min/avg/max/mdev = 0.252/0.314/0.506/0.098 ms, ipg/ewma 0.551/0.407 ms

In this particular scenario I am performing a clean install. CUE offers the option of doing an upgrade instead of a clean install but you must refer to the Cisco Unity Express 7.0 Installation and Upgrade Guide to make sure the the existing version of CUE is at the correct version.

cue# software install clean url ftp://177.3.11.2/cue-vm-k9.nm-aim.7.0.3.pkg username anonymous password anonymous@

```

The file cue-vm-k9.nm-aim.7.0.3.pkg is downloaded by CUE which then proceeds to download the remaining files from the CUE zip files that was extracted in to the FTP folder. You will be prompted to choose a language and this is where you must have the specific language pack in your FTP folder (referred to as language payload by CUE). CUE will run through a series of steps to install CUE 7.0.3 and prompt you to reload the module.

```

cue# show software version
Cisco Unity Express version (7.0.3)
Technical Support: http://www.cisco.com/techsupport Copyright (c) 1986-2008 by Cisco Systems, Inc.

Components:

- CUE Voicemail Language Support version 7.0.3

The license files must now be loaded. Be sure you downloaded the correct ones as one is for CCM and the other CME. Once you install one license type you cannot change the system to a different license unless you perform a clean install.

cue# software install clean url ftp://177.3.11.2/cue-vm-license_12mbx_cme_7.0.3.pkg username anonymous password anonymous@

cue# software install clean url ftp://177.3.11.2/cue-vm-license_4port_ivr_7.0.3.pkg username anonymous password anonymous@

cue# reload

cue# show software licenses
Installed license files:
- voicemail_lic.sig : 50 MAILBOX LICENSE
- ivr_lic.sig : 4 PORT IVR BASE LICENSE

Core:
- Application mode: CCME
- Total usable system ports: 8

Voicemail/Auto Attendant:
- Max system mailbox capacity time: 6000
- Default # of general delivery mailboxes: 15
- Default # of personal mailboxes: 50

- Max # of configurable mailboxes: 65

Interactive Voice Response:
- Max # of IVR sessions: 4

Languages:
- Max installed languages: 5
- Max enabled languages: 5

```

As I go through my CCIE Voice tasks I frequently need to wipe the CUE configuration and start with a fresh CUE 7 initialization:

```
cue# offline
cue# restore factory default
```

To wipe the config and reboot into a fresh system prompt with the initialization questions do the following:

```
cue# erase startup-config
```

The first time you log into the web interface of CUE you will need to associate the administrator credentials of the router with CUE so CUE may access CME.

```
r3-br2(config-telephony)#web admin system name admin password cisco

r3-br2(config)#ip http path flash:/gui
```

If you forget the last statement containing ip http path flash:/gui then CUE will fail to validate the admin/cisco credentials when entered in the CUE web interface.  CUE requires administrator access to CME.

