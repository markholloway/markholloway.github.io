---
layout: post
title: Broadsoft incompatible with sudo 1.7
tags: [broadsoft,linux]
---
As of this writing the latest version of `sudo` is not compatible with BroadWorks.  Version 1.6 and below will work appropriately although Broadsoft is working to fix this.  In the event 1.7 is inadvertently installed and Broadworks will not start then the sudo application must be downgraded.
<!--more-->

Broadsoft has provided an advisory for customers running RHEL 5.  I have summarized the steps and provided steps for those running RHEL 4 (which Broadsoft did not provide information for).

RHEL5:

Execute the following: 

```
rpm –qa | grep sudo
```

The output should be like the following: 

```
sudo-1.6.7p5-30.1.5
```

If it shows version 1.7.2 you will need to revert to the previous supported version via: 

```
yum downgrade sudo
```

RHEL 4 (uses up2date instead of yum):

Login to the Red Hat web site and visit the download section.  You must download a version of sudo that is part of 1.6. One you have downloaded the appropriate version you must execute the following:

```
rpm –oldpackage sudo**.rpm
```