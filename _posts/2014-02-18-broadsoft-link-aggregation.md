---
layout: post
title: Configure 802.3ad Link Aggregation for Broadsoft
tags: [acme,sbc,sip]
---
The BroadWorks Software Management Guide provides an example for configuring active/standby Ethernet interfaces (called mode 1) when configuring `bonded` Ethernet transmission on a single Red Hat Enterprise server.  

<!--more-->

Unfortunately with `mode 1` only one Ethernet interface is transmitting and receiving traffic at a time while the other interface is in standby mode.  My preferred approach is `802.3ad` Link Aggregation Control Protocol (LACP). `LACP` creates aggregation groups that share the same speed and duplex settings across Ethernet interfaces on a server. It utilizes all slaves in the active aggregate according to the 802.3ad specification.  802.3ad requires an Ethernet switch that is capable of supporting LACP.

## Red Hat Enterprise Linux

```text

#vi /etc/modprobe.conf
alias eth0
alias eth1
alias bond0 bonding
options bonding miimon=50 mode=4   (note: miimon = frequency in milliseconds to monitor interfaces)

==AS1==
#vi /etc/sysconfig/network
NETWORKING=yes
NETWORKING_IPV6=no
HOSTNAME=as1
NETWORKDELAY=25

#cd /etc/sysconfig/network-scripts
#vi ifcfg-bond0
DEVICE=bond0
BOOTPROTO=static
ONBOOT=yes
USERCTL=no
BROADCAST=192.168.126.255
IPADDR=192.168.126.145
NETMASK=255.255.255.0
NETWORK=192.168.126.0
GATEWAY=192.168.126.1

#vi ifcfg-eth0
# Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes

#vi ifcfg-eth1
# Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet
DEVICE=eth1
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes

```

## Cisco Switch

```text

interface Port-channel30
description Port-Channel to as1
switchport
switchport access vlan 12
switchport mode access
spanning-tree portfast

interface GigabitEthernet3/24
description [as1] IBM x3650 m2 – eth0
switchport access vlan 12
switchport mode access
spanning-tree portfast
channel-group 130 mode active

interface GigabitEthernet6/24
description [as1] IBM x3650 m2 – eth1
switchport access vlan 12
switchport mode access
spanning-tree portfast
channel-group 130 mode active

```

Using active/standby `mode 1` does not require any additional configuration beyond RHEL, so while it is more convenient and simplistic, this configuration does not fully maximize the capability of the servers.  This can be especially useful for the Media Servers, Conference Servers, or the Application Servers where Broadworks log files or Radius CDR’s are being offloaded to a separate server.