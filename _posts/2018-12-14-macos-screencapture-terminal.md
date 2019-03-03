---
layout: post
title: Automating macOS Screencaptures with BASH
tags: [macos,bash]
---
Taking a `screencapture` in macOS is straightforward using keyb unless you want the screencapture to take place while typing or working. The solution is using a lesser known command line tool that is native to macOS to automate taking screenshots. 
<!--more-->

macOS screencaptures can be quickly captured using keyboard shortcuts. `Command+Shift+4` will save the screencapture to the desktop as a `.png` file and `Command+Control+Shift+4` copies the screencapture to the clipboard.

Beyond keyboard shortcuts there is a Screenshot utility located in Applications > Utilities > Screenshot. This places a small panel at the bottom of the desktop providing more control of screencaptures.

While both options work great they assume the user doesn't need their hands for something else. It can also become tedious to manually take screenshots if needing more then a few. This is where the `screenshot` command line utility is helpful and provides hands-free continuous screencapturing with a variety of customization arguements.

### Viewing `screencapture` options

Open macOS Terminal and run screencapture from the command line 

```
mbp2018:~ mh$ screencapture -h
usage: screencapture [-icMPmwsWxSCUtoa] [files]
	-c         force screen capture to go to the clipboard
	-b         capture Touch Bar - non-interactive modes only
	-C         capture the cursor as well as the screen. only in non-interactive modes
	-d         display errors to the user graphically
	-i         capture screen interactively, by selection or window
							 control key - causes screen shot to go to clipboard
							 space key   - toggle between mouse selection and
														 window selection modes
							 escape key  - cancels interactive screen shot
	-m         only capture the main monitor, undefined if -i is set
	-D<display> screen capture or record from the display specified. -D 1 is main display, -D 2 secondary, etc.
	-o         in window capture mode, do not capture the shadow of the window
	-p         screen capture will use the default settings for capture. The files argument will be ignored
	-M         screen capture output will go to a new Mail message
	-P         screen capture output will open in Preview or QuickTime Player if video
	-I         screen capture output will open in Messages
	-B<bundleid> screen capture output will open in app with bundleid
	-s         only allow mouse selection mode
	-S         in window capture mode, capture the screen not the window
	-J<style>  sets the starting of interfactive capture
							 selection       - captures screen in selection mode
							 window          - captures screen in window mode
							 video           - records screen in selection mode
	-t<format> image format to create, default is png (other options include pdf, jpg, tiff and other formats)
	-T<seconds> take the picture after a delay of <seconds>, default is 5
	-w         only allow window selection mode
	-W         start interaction in window selection mode
	-x         do not play sounds
	-a         do not include windows attached to selected windows
	-r         do not add dpi meta data to image
	-l<windowid> capture this windowsid
	-R<x,y,w,h> capture screen rect
	-v        capture video recording of the screen
	-V<seconds> limits video capture to specified seconds
	-A<id>    captures audio during a video recording using default input. Optional specify the id of the audio source
	-k        show clicks in video recording mode
	-U        Show interactive toolbar in interactive mode
	-u        present UI after screencapture is complete. files passed to command line will be ignored
	files   where to save the screen capture, 1 file per screen
```

## Building a script to automatate screencapture

I want to write a script that takes a screencapture of my desktop every one second. 

Open your preferred IDE or use macOS TextEdit. If using TextEdit it is important to save the file in plain text format. I saved my file as `screencap.sh` since it is a `bash` script and we will execute from the `shell`

```bash
#!/bin/bash
# script to run screencapture every one second

screenshot="$(which screencapture) -x -m -C"
freq=1		#take a screenshot every one second
maxshots=6	#take six screenshots then quit

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

Before executing and testing the script I would like to explain what is happening. When the script runs it will take a screenshot of the desktop every one second and quit after the sixth screenshot. This is set by the value `freq=1` and `maxshots=6`. 

## Making `screencap.sh` executable

In order to run the shell script we must change its permission so it is excutable

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

Once the script has executed there should be six `.jpg` files in the folder where the scripts was run

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

View the script and notice `f` and `m` allow for optional arguements using `$OPTARG`. Whatever arguements are added to the launch of the script will be passed with the executable and override the pre-configured settings.

This will change the frequency from one second to eight seconds

```bash
mbp2017:~ mh$ ./screencap.sh -f 8
```

Building on top of this script with additional default parameters and command line arguements makes the `screencapture` app extremely powerful with many supported use cases. Capture you progress in [TwilioQuest](http://twilio.com/quest) and show off your high score to all your friends.


