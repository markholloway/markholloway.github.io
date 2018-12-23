---
layout: post
title: Send texts from your Twilio number using macOS and Linux
tags: [twilio]
---

Here is a quick way to send outbound SMS messages with your `Twilio` number using macOS or Linux and `#!/bin/bash`

<!--more-->


## Working with `curl`

We will use a command line utility called `curl` that is included with macOS and Linux. Curl will establish an `HTTP` connection to Twilio's REST API using the `-X` flag and use the `POST` method to send data the same way an application using a Twilio `helper library` would send TwiML. The benefit of using `curl` is it's quick and we do not need to write an application.

The `-d` option represents the data we will POST to Twilio. Include your own SID and Auth Token in the `-u` option for Twilio verification. They must be seperated by `:` or credentials will fail. Numbers must be formatted as [`E.164`](https://www.twilio.com/docs/glossary/what-e164).
 
```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -u "ABCD1234:EFGH5678"

```

If all went will you should receive a text on your device. Your terminal window will display `JSON` sent by Twilio either confirming your `HTTP` request was successful or it will display an error.

## Phone number and message body redaction

If you use `redaction` for privacy reasons this can also be tested with curl. Redaction must be enabled in your account for the flags to work.

This redacts digits from the phone number. Only the NPA-NXX are in the logs.

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

[`Postman`](https://www.getpostman.com/) is a free and handy tool for more lengthy testing. It's also a great way to view `JSON` files containing SMS transaction details.

Below is the Twilio URL to `GET` SMS records from your Twilio account. Replace `{AccountSid}` with your SID.

```bash

https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

```
Add your SID and Auth Token to `Postman` for Twilio verification. 

![]({{ site.baseurl }}/blog/assets/postman/postman_settings.png)

In Postman press `Send` to query the Twilio URL we added. Postman will display the returned JSON data in a readable format.

![]({{ site.baseurl }}/blog/assets/postman/postman_sms_log.jpg)


Happy texting!
