---
layout: post
title: Using macOS screen cli app to manage serial console access to Cisco devices
tags: [cisco]
---
Today brought me one step closer to being completely dongle free on my Mac and standardizing on one type of cable connection. Upon receiving my USB-C Cisco console cable I decided to experiemnt using the `screen` terminal app and go beyond  the basics of console port connectivity to understanding screen's other features.
<!--more-->

## Displaying the device name

The first thing to do when connecting the USB-C console cable is identify the device name of the cable itself. The command `ls /dev` will list all devices connected to my MacBook Pro but since this is a USB serial cable I will use `*usbser*` to minimize the results.

Without the cable connected to my Mac

```bash
ls /dev/*usbser*

ls: /dev/*usbser*: No such file or directory
```

With the cable connected to my Mac

```bash
ls /dev/*usbser*

/dev/cu.usbserial-AH06ORDE
```
And there it is! 

## Console connectivity

This tells terminal to use 9600 baud rate. Note that 8N1 is already the default asynchronous mode.

```bash
/dev/cu.usbserial-AH06ORDE 9600
```

Time to power on the router.

```
System Bootstrap, Version 16.9(1r), RELEASE SOFTWARE
Copyright (c) 1994-2018  by cisco Systems, Inc.


Current image running: Boot ROM0

Last reset cause: PowerOn
C1111-8PWB platform with 4194304 Kbytes of main memory
```

Success! Screen has an active console connection to my router 

![]({{ site.baseurl }}/blog/assets/2018-12-27/1.png)


Pressing `CTRL-A` then `?` shows the screen menu

![]({{ site.baseurl }}/blog/assets/2018-12-27/2.png)

## Additional screen commands

`CTRL-A` then `c` will create another console window

`CTRL-A` then `SHIFT-A` will allow renaming the current console

`CTRL-A` then `"` display both terminals

`CTRL-A` then `n` or `p` moves to next or previous windows

`CTRL-A` then `SHIFT-S` displays the terminals as split screen

`CTRL-A` then `Tab` toggles between split screen windows

`CTRL-A` then `i` identifies which is the active window

Open another terminal window to list all active screen sessions

```bash
$ screen -list
There is a screen on:
	93529.ttys001.2594	(Attached)
1 Socket in /var/folders/sb/7dkxrqcs32z948hv4zpxjzfx5cxpbq/T/.screen.
```

`CTRL-A` then `d` detaches from the session and display the terminal prompt

To re-attach to a screen session, or if you accidentally close terminal and need to get back to your console session.

```bash
$ screen -r
```

Create `.screenrc` if it does not exist

```bash
cd ~
touch .screenrc
```

Edit `.screenrc` to add custom startup message or disable with `startup_message off`.


