---
layout: post
title: Use macOS or Linux to send texts from your Twilio number
tags: [twilio]
---

Quick tip on testing outbound SMS messages with your `Twilio` number or short code using macOS or Linux and `curl`

<!--more-->


## Working with `curl`

We will use a command line utility called `curl` that is included with macOS and Linux. Curl can establish an `HTTP` connection to Twilio's REST API using the `-X` flag and pass along data with the `POST` action.

The `-d` flag represents the data we will POST. For verification the `-u` flag passes the SID and Auth Token. Note the `:` betwen the SID and Auth Token. Without this verification will fail.

I recommend creating the script in a text editor first then pasting the script to macOS terminal or a Linux command prompt.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -u "ABCD1234:EFGH5678"

```

After sending the text you will receive a response from Twilio. If the text did not go through there will be errors presented. As long as no errors are indicated the text should have been delivered successfully.

## Phone number and message body redaction

If you use `redaction` for privacy reasons this can also be tested with curl. Redaction must be enabled in your Twilio console for the flags to work.

Only the NPA-NXX are stored in the log files. The remaining digits are redacted.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -d "AddressRetention=obfuscate"
    -u "ABCD1234:EFGH5678"

```

This redacts the message body.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -d "ContentRetention=obfuscate"
    -u "ABCD1234:EFGH5678"

```

This redacts the digits and the message body.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -d "ContentRetention=obfuscate"
    -d "AddressRetention=obfuscate"
    -u "ABCD1234:EFGH5678"

```

Using [`Postman`](https://www.getpostman.com/) provides a readable view of SMS transaction history. 

Here is the URL we need to paste in the `GET` field of Postman. Replace `{AccountSid}` with your actual SID.

```bash

https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

```
Configure `Postman` with your SID and Auth Token credentials. 

![]({{ site.baseurl }}/blog/assets/postman/postman_settings.png)

Press `Send` in Postman and the appropriate `JSON` should be returned. This is for a simple SMS.

![]({{ site.baseurl }}/blog/assets/postman/postman_sms_log.jpg)

Happy texting!
