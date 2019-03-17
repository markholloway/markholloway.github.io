---
layout: post
title: Fixing Broadsoft cluster nodes that do not sync
tags: [broadsoft,linux,sip]
---
I am in the process of fixing two cluster installations which were originally performed by a third party consulting group.  The `peerctl` lists were not setup correctly and thus replication is not working from the primary `as1`` to the secondary `as2` node on either platform. 
<!--more-->

There are a few tasks you can perform to validate whether replication to your secondary nodes are healthy.  First, ensure dbSyncCheck is running in the maintenance scheduler for all AS/NS nodes.  Second, verify whether you are receiving alarms from your cluster nodes stating the datbase is out of sync.  Third, see if you can perform an importdb.pl on the secondary node without it failing.  In the event your platform is not in sync or importdb.pl fails, you must reconfigure the peerctl list on the primary server.  This example assumes your are setting the peerctl list for an application server cluster.

## On the primary AS

```bash

peerctl set <old peerctl name> <hostname> <ipaddress> | example: peerctl set as1.markholloway.com as1 192.168.1.10
peerctl set <old peerctl name> <hostname> <ipaddress> | example: peerctl set as2.markholloway.com as2 192.168.1.11
peerctl setprimary as1
repctl restart
bwBackup.pl AppServer db-JAN-11-2009.db
scp db-JAN-11-2009.db as bwadmin to as2

```
 

## On the secondary AS

```bash

repctl stop
stopbw
bwRestore.pl AppServer db-JAN-11-2009.db
importdb.pl AppServer 192.168.1.10 | Verifies importdb.pl works as expected

```
