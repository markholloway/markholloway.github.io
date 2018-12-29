---
layout: post
title: Send texts from your Twilio number using BASH and curl with macOS or Linux
tags: [twilio,bash]
---

The `curl` utiliy is a powerful command line program bundled with `macOS` and `Linux`. The following script provides a quick method to send text messages from a `Twilio` phone number to a mobile device. This is ideal for development and testing.

<!--more-->

## Working with `curl`

The curl utility supports many protocols. The example script uses `HTTP` to `POST` information to the `Twilio` `REST API` and sends an outbound SMS message.

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
Paste the above script in a `BASH` shell to send the text. Twilio should respond with `XML` headers and include a `2xx` response code for successful delivery. If the message did not go through check [`here`](https://www.twilio.com/docs/usage/your-request-to-twilio) for a descriptive list of `4xx` error codes.

Happy texting!
