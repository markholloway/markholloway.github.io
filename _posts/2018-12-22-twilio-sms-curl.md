---
layout: post
title: Send texts from your Twilio number using macOS or Linux with bash and curl
tags: [bash]
---

It doesn't get any easier than this to quickly send sending outbound text with your Twilio number. Perfect for testing if something isn't working. 

<!--more-->


## The goal

`BASH` is the default Unix shell for macOS and Linux and includes a powerful utility called `curl`. With curl we are going to `POST` data Twilio's `REST API` and send outbound text message from a Twilio number. 

## Working with curl

There no arguing that `curl` is a swiss army knife for common protocols such as SFTP, SCP, LDAP, and many more. One of its greatest strengths is `HTTP Scripting`. Below are the curl `flags` we will use in out scripts.  

`curl -X POST` tells curl to POST to a particular URL

`curl --data-urlencode` the actual `data` that `Twilio` will process

`curl -u` provides authentication credentials to the server

`NOTE` Twilio expects the account `SID` separated by a `:` and the Auto Token. Without this verifications will fail.

Twilio requires phone numbers to be in global [`E.164`](https://www.twilio.com/docs/glossary/what-e164) format.

Copy the script to a plain text editor and inthe HTTPS URL replace `ABCD1234` with your account `SID` and in the `-u` option replace `ABCD1234:EFGH5678` with your own `SID` and `AUTH TOKEN`. Replace `From=+1xxxxxxxxxx` with your Twilio number and `To=+1xxxxxxxxxx` with your mobile number. 

For easier reading each curl element is on its own line. if you use this form keep the `\` at the end of each line as this tells curl to POST the information as one string wihtout line breaks.

```bash

curl -X POST \
    "https://api.twilio.com/2010-04-01/Accounts/ABCD1234/Messages" \
    --data-urlencode "From=+1xxxxxxxxxx" \
    --data-urlencode "Body=I'm using curl to send a text with a Twilio number!" \
    --data-urlencode "To=+1xxxxxxxxxx" \
    -u "ABCD1234:EFGH5678"

```

If all went will you should receive a text on your mobile device. There should also be an `XML` response from Twilio that includes 200 OK displayed in BASH along with several XML headers. 

If the text did not work and you like have received a `4xx` such as `401 Unauthorized` pr `404 Not Found`. The most common issue is incorrect SID:AUTH credentials for Twilio project the phone number belongs to. The list of possible status codes may be viewed `here`(https://www.twilio.com/docs/usage/your-request-to-twilio). 

Happy texting!
