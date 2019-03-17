---
layout: post
title: How to fix Broadosft up2date when upgrading from R13 to R14.SP8
tags: [broadsoft,linux,sip]
---
Just over two months ago I started a project to upgrade `BroadWorks` from Release 13 to Release 14.SP8.  BroadWorks R13/R14 requires RHEL4 and there is a snag I ran into when running the `up2date` process on the lab instance.
<!--more-->

 During the initial Broadworks install the application changes `/bin/nice` so `nice` may be run by bwadmin and thus change application priority.  
 
 The issue is up2date process installs files which change the permission of /bin/nice to be exclusively accessed by root. This means bwadmin cannot access /bin/nice through its startup scripts.  The appropraite fix for this is executing `chmod ug+s /bin/nice` as root.  After working through this issue I took the time to understand more about the nice and re-nice process so I could have a better understanding as to why it broke.