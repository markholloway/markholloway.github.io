---
layout: post
title: Send texts from your Twilio number using BASH and curl with macOS or Linux
tags: [twilio,bash]
---

The `curl` utiliy is an extremely powerful command line program bundled with `macOS` and `Linux`. Let's write a script that allows us to send text messages from a Twilio phone number.

<!--more-->

## Working with `curl`

The curl utility supports many protocols. For this example we will use `HTTP` to `POST` information to the `Twilio` `REST API` so we can send outbound SMS messages.

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

If all went will you should receive a text on your mobile device. There should also be an `XML` response from Twilio that includes `200 OK` displayed in BASH along with several XML headers. Otherise check [`here`](https://www.twilio.com/docs/usage/your-request-to-twilio) to see a descriptive list a error codes.

Happy texting!
