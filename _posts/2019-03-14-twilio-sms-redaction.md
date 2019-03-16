---
layout: post
title:  SMS phone number and message body redaction using Twilio
tags: [bash]
---
Twilio Programmable SMS offers the option to `redact` phone number and message body data so it is never stores in log files. This includes MMS data as well.
<!--more-->

In order to use redaction a form must be submitted for requesting access [here](https://ahoy.twilio.com/message-body-redaction?_ga=2.114374407.109597969.1552660807-50235969.1532381789). Once access has been granted the redaction options will appear in Programmable SMS.


## Default settings

When permission is granted to the account the default action for SMS does not redact data. This may be toggled in the console so the default action enforces redaction on every SMS message. Phone number and message body redaction may be toggled independently. This can also be turned off at any time by the user.


## Redacting on selected messages

Whether redaction is set as the default action or not, it is possible to include two parameters to perform the opposing action. For example, if redaction is disabled as the default action and there is a need to redact a particular SMS, passing the additional options  in the API request will enforce phone number and message body redaction for that message.

Note the following in the CURL script which enforces redaction for the API request. 

`ContentRetention=discard` removes the message body

`AddressRetention=obfuscate` removes the phone number

```
curl -X POST 'https://api.twilio.com/2010-04-01/Accounts/{Sid}/Messages.json' \
--data-urlencode 'To=+19737219507'  \
--data-urlencode 'From=+12133194095'  \
--data-urlencode 'ContentRetention=discard' \
--data-urlencode 'AddressRetention=obfuscate' \
--data-urlencode 'Body=You cannot see what I am sending!' \
-u {SID}:{AuthToken} 

```
Using `retain` will not redact on a per API request basis if redaction is the default action. This is helpful during development and troubleshooting.

```
curl -X POST 'https://api.twilio.com/2010-04-01/Accounts/{Sid}/Messages.json' \
--data-urlencode 'To=+19737219507'  \
--data-urlencode 'From=+12133194095'  \
--data-urlencode 'ContentRetention=retain' \
--data-urlencode 'AddressRetention=retain' \
--data-urlencode 'Body=Now you can see what I am sending!' \
-u {SID}:{AuthToken} 

```
At the time of writing the Twilio helper libraries do not include the redaction form data. Instead use http `POST` within your code.

The example demonstrates performing redaction for a single API request using `Node.js`

```javascript

const request = require('request');

var options = {
    method: 'POST',
    url: 'https://api.twilio.com/2010-04-01/Accounts/' + accountSid + '/Messages.json',
    auth: {
        user: {SID},
        pass: {AuthToken}
    },
    formData: {
        To: '+19737219507',
        From: '+12133194095',
        Body: 'You cannot see what I am sending!',
        ContentRetention: 'discard',
        AddressRetention: 'obfuscate'
    }
};

request(options, function (error, response, body) {
    if (error) throw new Error(error);

    console.log(body);
});

```

