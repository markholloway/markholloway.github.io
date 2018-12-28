---
layout: post
title: Send texts from your Twilio number using macOS Terminal with bash and curl
tags: [bash]
---

Here is a fast way to send outbound SMS messages with your `Twilio` number using `#!/bin/bash`

<!--more-->


## Working with `curl`

We will use a command line utility called `curl` that is included with macOS and Linux. Curl will establish an `HTTP` connection to Twilio's REST API using the `-X` flag and use a `POST` method to send data the same way an application using a Twilio `helper library` would send TwiML. The benefit of using `curl` is it's quick and convenient, especially for testing.

Below is an example of  our `curl` script. The `-d` options represent the data we will POST to Twilio. Replace your own SID and Auth Token in the `-u` option for Twilio verification. They must be seperated by `:` or credentials will fail. Enter your Twilio number in the `From` field and a mobile number in the `To` field. Numbers must be in [`E.164`](https://www.twilio.com/docs/glossary/what-e164) format.
 
```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    -d "From=+14244881616" \
    -d "To=+18079072252" \
    -d "Body=Price is what you pay. Value is what you get." \
    -u "ABCD1234:EFGH5678"

```

If all went will you should receive a text on your device. Your terminal window will display an `XML` response sent by Twilio either confirming your HTTP request was successful or there was an error.

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
## Using Postman 

This is the swiss army knife of REST API tools. [`Postman`](https://www.getpostman.com/) is free and in this example we will look at the SMS details for a text sent from a Twilio number to a mobile device.

Below is the Twilio URL to `GET` SMS records from your Twilio account. Replace `{AccountSid}` with your SID.

```bash

https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

```
Add your SID and Auth Token to `Postman` for Twilio verification. 

![]({{ site.baseurl }}/blog/assets/postman/postman_settings.png)

In Postman press `Send` to query the Twilio URL we added. Make sure the `Pretty` option under `Body` is selected and Postman will display the returned `JSON` output in a readable format.

![]({{ site.baseurl }}/blog/assets/postman/postman_sms_log.jpg)


Happy texting!
