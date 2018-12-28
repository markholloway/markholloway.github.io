---
layout: post
title: Using Twilio SMS redaction to discard a phone number and message body
tags: [bash]
---

Twilio supports the option of phone number and message body `redaction` when sending SMS or MMS messages. The following examples show what `flags` are required to support redaction.

<!--more-->

## Using `curl` 

In a previous [`post`](https://markholloway.github.io/2018/12/22/twilio-sms-curl/) I showed how to send outbound text messages from your Twilio number using `BASH` and `curl` with macOS Terminal or Linux. 

### Refresher

For easy editing copy the script below to a plain text editor and modify the URL by placing your SID where `ABCD1234` is shown. Replace the `-u` option `ABCD1234:EFGH5678` with your own SID and AUTH TOKEN. They must be separated by `:` or verification will fail. 

Replace `From=+1xxxxxxxxxx` with a Twilio number and `To=+1xxxxxxxxxx` with a mobile number. 

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
## Twilio message redaction options

Message redaction requires users are granted access to the feature in their Twilio console by completing [`this`](https://ahoy.twilio.com/message-body-redaction) sign-up form. 

There are two significant `data` settings used for redaction.

## Redaction examples

Setting `AddressRetention=obfuscate` redacts the last 4 digits of the phone number and only the NPA-NXX are stored. The number `+15554229999` is stored as  `+1555422XXXX`

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=obfuscate"
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```

Setting `ContentRetention=discard` redacts the SMS message body. If the message includes MMS media it will be discarded as well.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "ContentRetention=discard"
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```

Including both options redacts the phone number, message body, and media (if applicable). 

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=obfuscate"
    --data-urlencode "ContentRetention=discard"
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
The above examples assume the Twilio Console settings do not redact messages by default which is why it is necessary to include the additoinal flags.

It is possible to set the `default behavior` in the console to `always` include redaction for either of the options. In the event there are messages which should not be redacted, there are flags for `retaining` both the phone number and message body.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "AddressRetention=retain"
    --data-urlencode "ContentRetention=retain"
    --data-urlencode  "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```
If `sub-accounts` are created they will inherit the current redaction setting of the parent account. The sub-account settings can be changed at any time.

Happy texting!