---
layout: post
title: Configuring Twilio SMS message body and phone number redaction for PII
tags: [twilio,bash]
---

 Twilio offers `redaction` of Personally Identifiable Information when sending text messages. The following examples show the necessary settings to utilize this feature.

<!--more-->

## Testing with `curl` 

Below is the `curl` script used from a previous [post](https://markholloway.github.io/2018/12/22/twilio-sms-curl/) demonstrating how to send SMS gmessages from a Twilio number using `curl` and `BASH` in macOS, Linux, and Windows.

### Demo `curl` script

It is recommended to copy the script below to a plain text editor for easier editing. Modify the `URL` by replacing `ABCD1234`with a valid `SID`. Replace `-u` credentials `ABCD1234:EFGH5678` with the same account `SID` and a valid `Auth Token`. They must be separated by `:` or verification will fail. 

Replace `From=+1xxxxxxxxxx` with a Twilio number and `To=+1xxxxxxxxxx` with a mobile number. 

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
## Twilio redaction options

`NOTE:` Users must be granted access to the redaction feature in their Twilio console by completing [`this`](https://ahoy.twilio.com/message-body-redaction) sign-up form. 

There are two significant `data` flags used for redaction.

## Redaction examples

Setting `AddressRetention=obfuscate` redacts the last 4 digits of the phone number and only the NPA-NXX are stored. The number `+13074229999` is stored as `+1307422XXXX`

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=obfuscate" \
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```

Setting `ContentRetention=discard` redacts the SMS message body and media (if sent as an MMS).

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "ContentRetention=discard" \
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```

Including both options redacts the phone number, message body, and media. 

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=obfuscate" \
    --data-urlencode "ContentRetention=discard" \
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
The above examples assume the Twilio Console settings do not redact messages by default. Specifying the appropriate flag tells Twilio to redact the data content.

It is possible to set the `default behavior` in the console to `always` include redaction for either option. Therefore there may be messages which should not be redacted. Using `retain` will keep the data content.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=retain" \
    --data-urlencode "ContentRetention=retain" \
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
When `sub-accounts` are created they will inherit the current redaction setting of the parent account. Sub-account redaction settings can be changed.
