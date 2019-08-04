---
layout: post
title: Using a Cisco router as a TFTP server
tags: [cisco]
---
The ability to use a router as a `TFTP` server can be very useful. Whether hosting router images, ringtones, or other bulk files, it's less time consuming than configuring a server for the same purpose.
<!--more-->

The first thing I'll mention is TFTP is not a secure protocol. There is no encryption within the TFTP protocol itself. Do not transmit sensitive data over TFTP, ever.

Using the `tftp-server` command and specifying the file in flash to share makes the file accessible to any inbound TFTP requests for the file name.

```
router# config t
router(config)# tftp-server flash:c7200-adventerprisek9-mz.152.bin
router(config)# end
```

If I want to restrict TFTP access so only device on a specific network can access the image I can create and `access list` and reference it in the tftp-server configuration.

```
router# config t
router(config)# no tftp-server flash:c7200-adventerprisek9-mz.152.bin
router(config)# access-list 40 permit 172.16.32.0 0.0.0.255
router(config)# access-lkst 40 deny any
router(config)# tftp-server flash:c7200-adventerprisek9-mz.152.bin 40
router(config)# end
```
By creating access-list `40` I have defined what IP network is permitted access to the image and what should be denied. I then applied the access list number `40` at the end of the `tftp-server` statement which enforces the new `ACL` rules. 



