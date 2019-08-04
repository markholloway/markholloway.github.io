---
layout: post
title: Testing SIP Header Manipulation Rules from the Acme Packet (ACLI) Command Line
tags: [acme,sbc,sip]
---

SIP Header Manipulation provides the flexibility to add, remove, or modify any attribute in a SIP message on the Acme Packet SBC. The most common reason for doing this is to fix an incompatibility problem between two SIP endpoints. This could range from anything such as Softswitch/PSTN incompatibility or an issue between two different IP PBX platforms in a multi-site Enterprise where calls between them fail due to issues in the SIP messaging.

<!--more-->

In the past there was no straight forward way to test SIP Header Manipulation Rules other than performing save/activate and manually placing test calls to see if the HMR worked.

The example below is a case where an HMR needed to be written to route calls based on the Charge Number in the SIP Invite rather than routing on the Request-URI, TO, or FROM numbers. Because BroadWorks R14 uses a proprietary charge number header it is required to have one rule that looks at the number in the charge number header and stores that value using a store-action, then through the use of a second rule pastes the number as cn=4804563000 into the Request-URI then use a local-policy to route the call based on the cn= value.

The original SIP Invite from BroadWorks looks like this.

```text

INVITE sip:+18005551212@sip.markholloway.com:5060;user=phone SIP/2.0
From:”John Smith”<sip:4804814001@voip.markholloway.com;user=phone>;tag=1121176714-1301523646656-
To:<sip:+18005551212@sip.markholloway.com:5060;user=phone>
Call-ID:BW1520466563003111177145372@10.12.135.140
CSeq:74277985 INVITE
Contact:<sip:10.12.135.100:5060>
Privacy:none
Allow:ACK,BYE,CANCEL,INFO,INVITE,OPTIONS,PRACK,REFER,NOTIFY
Accept:multipart/mixed,application/media_control+xml,application/sdp
Charge:<tel:4804563000>;noa=clgp-ani-natl-num
Supported:
Max-Forwards:10
Content-Type:application/sdp
Content-Length:255

```

The goal is to Route based on the Charge Number not the Request URI, To, or From numbers.  An HMR on the Session Director must be created to extract 4804563000 from the Charge Number header and insert it in the Request URI as a cn=4804563000.

Here is the HMR for copying the number from the Charge Number header and inserting it as a cn= parameter in the Request URI. Note this is one sip-manipulation that contains two rules.

![]({{ site.baseurl }}/blog/assets/apkt/test-hmr-01.png)

The HMR may be tested directly within the ACLI by pasting in ASCII text that contains the original message of which the SD will manipulate.

![]({{ site.baseurl }}/blog/assets/apkt/test-hmr-02.png)

The next step is set debugging enabled (from within test-sip-manipulation), show the sip-manipulation you are about to test (always good for verification), and then execute the test.

![]({{ site.baseurl }}/blog/assets/apkt/test-hmr-03.png)

The SD shows the debug output of the original SIP Invite that was pasted in ASCII.

![]({{ site.baseurl }}/blog/assets/apkt/test-hmr-04.png)

The SD now presents the newly manipulated SIP Invite.

![]({{ site.baseurl }}/blog/assets/apkt/test-hmr-05.png)
