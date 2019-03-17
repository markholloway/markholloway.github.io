---
layout: post
title: Cisco CME join and leave tones for a MeetMe Conference
tags: [cisco]
---
`MeetMe` conferencing with Call Manager Express allows a CME phone to go off hook, press the MeetMe softkey, and dial the MeetMe bridge number to start a conference. Any other CME subscriber or off-net party may dial the MeetMe number to join the conference.
<!--more-->

  By default CME does not play `tones` when participants join or leave the bridge. Adding this capability requires the creation of a `voice class` for both the join tones and leave tones where tone frequencies are defined and then later referenced in the `dspfarm` profile.  In order to perform the following configuration you should already have hardware conferencing configured on CME. 

## Configure a number to be a MeetMe Conference Bridge

```
ephone-dn  10  octo-line
number 4454 no-reg primary
conference meetme
```

## Configure an ephone template that includes the MeetMe Softkey. This is so CME subscribers can easily start a conference.

```
ephone-template  1
softkeys remote-in-use  CBarge Newcall
softkeys seized  Redial Endcall Meetme Pickup Gpickup Cfwdall Callback
softkeys connected  Hold Endcall LiveRcd Park Trnsfer Confrn

ephone  1
privacy-button
mac-address 0022.90BA.2CC0
ephone-template 1
busy-trigger-per-button 4
button  1:1 2:2
```

## Configure the appropriate voice class to define Join/Leave tones

```
voice class custom-cptone conf-leave
dualtone conference
frequency 300 900
cadence 300 150 300 100 300 50

voice class custom-cptone conf-join
dualtone conference
frequency 600 900
cadence 300 150 300 100 300 50
```

## Assign each voice class to the dspfarm profile used for conferencing

```
dspfarm profile 1 conference
codec g711ulaw
codec g711alaw
codec g729ar8
codec g729abr8
codec g729r8
codec g729br8
maximum sessions 2
conference-join custom-cptone conf-join
conference-leave custom-cptone conf-leave
associate application SCCP
```
