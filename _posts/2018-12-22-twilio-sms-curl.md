---
layout: post
title: Use BASH to send texts with Twilio
tags: [twilio,bash]
---

This is a short note on how to send SMS messages using `BASH` and `curl` in macOS and Linux. Windows users can use [GIT BASH](https://gitforwindows.org). 

<!--more-->

## Working with `curl`

Copy the script to a text editor for modification. 

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/{AccountSID}/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text from a Twilio number." \
    --data-urlencode "To=+1xxxxxxxxxx" \
    -u "{AccountSID}:{AuthToken}"

```
Replace {AccountSID} in the `URL` portion with a valid SID. Repalce the `-u` credentials {AccountSID:AuthToken} with the matching SID and Token.  They must be separated by `:` or verification will fail. Replace `From=+1xxxxxxxxxx` to with the Twilio number and replace `To=+1xxxxxxxxxx` with the destination number. 

Adding `> sms-test.json` at the end of the script will allow the response to be easily read in a `JSON` viewer. Otherwise the response is squashed together in the BASH terminal and difficult to read.

Below is the final format of the script to paste and send a text message.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/1a2b3c4d5e6f7g8h9i0j/Messages" \
    --data-urlencode "From=+15552392613" \
    --data-urlencode "Body=I'm using curl to send a text from a Twilio number." \
    --data-urlencode "To=+15554345978" \
    -u "1a2b3c4d5e6f7g8h9i0j:l0k9j8h7g6f5d4s3a2q1" > sms-test.json

```