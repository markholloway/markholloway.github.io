---
layout: post
title: How to Fix "No Schema Found" in Broadsoft
tags: [acme,sbc,sip]
---
Broadworks failed to create the patch database on my primary application node after the R13 to R14 upgrade completed. When accessing the patching menu in `bwcli` or `listpatch.pl` in Linux, it returns `No Schema Found`.  

<!--more-->

The second AS node in the cluster is ok and recognizes the `patch bundle`, but this is irellevant since the first node needs to be patched before patching to second node.   There is a way to recover from this by executing the following commands.

```text

bwadmin@as1$ cd /usr/local/broadworks/patchtool/sbin
bwadmin@as1$ ./listPatch.pl

Patch Name State
====================

No schema found.
bwadmin@as1$ ./createDSN.pl WS_Rel_14.sp8_1.57/createDSN.pl AS_Rel_14.sp8_1.57

bwadmin@as1$ ./listPatch.pl
Patch Name State
======================
listPatch command successfully executed.

AS_CLI/Maintenance/Patching> 8
Please wait while the database is updating (this could take up to a few
minutes depending on the number of patches and the activity on the server).

…………………………………………………
AS_CLI/Maintenance/Patching> listBundle
Patch Bundle Name
=========================
PB.as.14.sp8.57.pb20081201
1 entry found.

```

The same procedure may be used with `any` of the Broadworks servers.  I had the same issue with both external web servers as well.



