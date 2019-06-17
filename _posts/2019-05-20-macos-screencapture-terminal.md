---
layout: post
title: Automate screenshots and video capture in macOS using with Terminal
tags: [macos,bash]
---
Apple includes a command line utility called `screencapture` which allows macOS to take any number of screenshots silently in the background, hands-free, while the user is working. 
<!--more-->

Keyboard shortcuts such as `Command+Shift+4` will save a screencapture to the desktop and save the file as a PNG.  Another frequently used shortcut `Command+Control+Shift+4` copies the screencapture to the clipboard.

Beyond keyboard shortcuts there is a Screenshot utility located in Applications > Utilities. This places a panel at the bottom of the desktop providing more control of individual screencaptures.

The above methods assume the user doesn't need their hands at the time of taking the screencapture. It may also feel tedious to manually take screenshots one at a time if needing more then a few. The `screenshot` command line utility solves this problem while providing significant flexibility.

### Viewing `screencapture` options

Open macOS Terminal and run screencapture from the command line to see the optional arguements.

A few nice options worth noting are capturing the Touch Bar on a MacBook Pro, passing screencaptures directly to Mail, Preview, Messages, or the Clipboard, capturing desktop video and passing it to Quicktime, and Interactive Mode which allows changing what part of the screen should be captured.

```
mbp2018:~ mh$ screencapture -h
usage: screencapture [-icMPmwsWxSCUtoa] [files]
	-c         force screen capture to go to the clipboard
	-b         capture Touch Bar - non-interactive modes only
	-C         capture the cursor as well as the screen. only in 
			   non-interactive modes
	-d         display errors to the user graphically
	.
	.
	.
	.
	.etc
```

## Build a script to automatate repetitive screencapture tasks

I want to write a script that takes 45 screencaptures of my desktop every 30 seconds and saves them as `.jpg`. 

Open your preferred IDE or use macOS TextEdit. If using TextEdit it is important to save the file in plain text format. Save the file using the `.sh` extension rather than `.txt` since our goal is writig a `bash` script and we will execute from the `shell`

```bash
#!/bin/bash
# script to run screencapture every one second

screenshot="$(which screencapture) -x -m -C"
freq=30		#take a screenshot every 30 seconds
maxshots=45	#take 45 screenshots then quit

while getopts "af:m" opt; do
	case $opt in
	f ) freq=$OPTARG;		;;
	m ) maxshots=$OPTARG;	;;
	? ) echo "Usage: $0 [-f frequency] [-m maxcaps]" >&2
		exit 1
	esac
done

counter=1 	#set startng number; incrementally append to filename

while [ $counter -lt $maxshots ] ; do
	$screenshot screenshot${counter}.jpg
	counter=$(( counter + 1 )) 
	sleep $freq 
done

exit
```

## How it Works

Before executing and testing the script I would like to explain what is happening. When the script runs it will take a screenshot of the desktop every 30 seconds and quit after 45 screenshots. This is set by the value `freq=30` and `maxshots=45`. 

## Making `screencap.sh` executable

In order to run the shell script we must change its permission so it is excutable.

```bash
mbp2017:~ mh$ pwd
/Users/mh/Desktop

mbp2017:~ mh$ ls screen*
screencap.sh

mbp2017:~ mh$ chmod +x screencap.sh
```

Execute the file. It will run silently in the background.

```bash
mbp2017:~ mh$ ./screencap.sh
```

Once the script has finished there will be 45 `.jpg` files in the folder where the script was run.

```
mbp2017:~ mh$ ls

screenshot1.jpg
screenshot2.jpg
screenshot3.jpg
screenshot4.jpg
screenshot5.jpg
screenshot6.jpg
```

## Overide the settings in the script

View the script and notice `f` and `m` allow for optional arguements using `$OPTARG`. Whatever arguements are passed from the command line they will override the pre-configured settings.

This will change the frequency from 30 seconds to 8 seconds. Everything else remains at their default settings referenced in the script.

```bash
mbp2017:~ mh$ ./screencap.sh -f 8
```

Building on top of this script with additional default parameters and command line arguements makes the `screencapture` utility convenient and powerful.


