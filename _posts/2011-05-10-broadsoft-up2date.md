---
layout: post
title: Broadsoft Updgrade with Red Hat "up2date"
tags: [broadsoft,sbc,sip]
---
Just over 2 months ago I started a massive project to upgrade Broadworks from Release 13 to `Release 14.SP8`.  R13/R14 requires RHEL4 and there is an issue I ran into when running the `up2date` process on my `dev` system. 

<!--more-->

During the initial BroadWworks installation the application changes `/bin/nice` so nice may be run by `bwadmin` and thus change application priority.  The up2date process installs files which change the permission of /bin/nice to be exclusively accessed by `root`. This means bwadmin cannot access /bin/nice through its startup scripts. 

The appropraite fix for this is executing `chmod ug+s /bin/nice` as `root`.  After working through this issue I took the time to understand more about the `nice` and `renice` process so I could have a better idea as to why it broke.

