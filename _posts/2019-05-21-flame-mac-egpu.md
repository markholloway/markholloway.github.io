---
layout: post
title: Configuring Autodesk Flame to use an eGPU on macOS
tags: [mac,flame]
---
There is currently a lack of documentation on how to configure `Flame` to use an `eGPU` on macOS. The following steps quickly show the proper way to set this up. 
<!--more-->

### Finding the Flame launch application


Note the default Flame icon located in `Applications > Autodesk` is an `alias` that points to the Flame application in another location. 

Press and hold `command` and `spacebar` to open Spotlight. Enter the path `/opt/Autodesk`

Navigate to the appropraite Flame folder such as `Flame 2020` and navigate to the `bin` folder.

The full path for Flame 2020 would be `/opt/Autodesk/Flame 2020/bin`


### Prefer External GPU

Right click the Flame application and select `Get Info`

Tick the box `Prefer External GPU`

Flame will now prefer using an eGPU if one is present. If no eGPU is connected Flame will use the default GPU.


### Validating Flame is using the eGPU

Open the Activity Monitor application in Applications > Utilities

Press and hold `command` and `4` to display the GPU History floating window. The window will be visible on top of other applications and float in front of Flame.

Both the internal and external GPUs are displayed in the GPU History window. When using Flame there will be GPU cycles calulated for the eGPU showing it is in use.

