---
layout: post
title: Resizing the Broadsoft Datastore
tags: [acme,sbc,sip]
---
As the database grows on the BroadWorks Application and Network servers there will be a need to change the `memory allocation` for the `TimesTen` datastore. 

<!--more-->

The rule of thumb is the allocated `perm` size should not exceed more than 25% of total system memory and the `temp` size should be equal to 25% of the perm size.

The following example assumes 8GB of memory on both AS1 and AS2.

```text

1. SSH to AS1 as bwadmin
2. stopbw
3. repctl stop
4. su as root
5. cd /usr/local/broadworks/bw_base/bin
6. timesten.pl unload
7. ./resizeDSN (perm=2048; temp=512)
8. exit (return to bwadmin)
9. repctl start
10. startbw

– Wait 10 minutes for buffered replication changes from AS2 –

1. SSH to AS2 as bwadmin
2. stopbw
3. repctl stop
4. su as root
5. cd /usr/local/broadworks/bw_base/bin
6. timesten.pl unload
7. ./resizeDSN (perm=2047; temp=512)
8. exit (return to bwadmin)
9. importdb.pl AppServer as1 AppServer (replace as1 with your primary AS hostname or IP)
10. repctl start
11. startbw

```

If everything went smoothly you should be able to run `sychcheck_basic.pl -a` on AS2 and the database should show synchronized. If the `importdb.pl` command in step 9 was unable to import the database, you will need to manually perform the backup and restore procedure as shown below.

```text

1. On AS1: bwBackup.pl AppServer dbBackup.db
2. scp the file to AS2: scp dbBackup.db bwadmin@as2:dbBackup.db
3. On AS2: stopbw
4. repctl stop
5. bwRestore.pl AppServer dbBackup.db
6. repctl start
7. startbw

```

On one other occasion AS1 would not start `replication` after resizing the `DSN` due to an error which stated AS2 was on a different patch version than AS1. The two nodes were patched identical, but the patch tool was not responding on AS2 and therefore AS1 could not verify appropriately thus reporting the error. The solution was simply `restarting` the patch tool. 

```text

as2$ stoppt.pl
as2$ startpt.pl

```
