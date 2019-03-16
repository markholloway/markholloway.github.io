---
layout: post
title:  SMS phone number and message body redaction using Twilio
tags: [bash]
---
Twilio Programmable SMS provides the option to `redact` phone number and message body data and prevents the information from being stored at the account level and message request level.
<!--more-->

Access to the redaction feature must be requested by submiting a form [here](https://ahoy.twilio.com/message-body-redaction?_ga=2.114374407.109597969.1552660807-50235969.1532381789). Once access has been granted the redaction options will appear under Programmable SMS.

With redaction enabled the full message body and MMS attachments will not be stored on Twilio. Phone number redaction removes the `SLI` or Subscriber Line Identifider from a phone number and only the `NPA-NXX` are present. 


## Default settings

When permission is granted to the master account the default action is SMS does not redact data. The console adminstrator has permission to change this setting at any time. Message body and phone number redaction are managed independently. 

## Sub-accounts
Sub-accounts created prior to redaction being added will not inherit the master account settings. Sub-accounts created after redaction being added will inherit the master account behavior. Settings can still be changed for each sub-account.


## Redacting on selected messages

Whether redaction is set as the default action or not, it is possible to include two parameters to perform the opposing action. For example, if redaction is disabled as the default action and there is a need to redact a particular SMS, passing the additional options  in the API request will enforce phone number and message body redaction for that message.

Note the following in the CURL script which enforces redaction for the API request. 

`ContentRetention=discard` removes the message body

`AddressRetention=obfuscate` removes the phone number

```
curl -X POST 'https://api.twilio.com/2010-04-01/Accounts/{SID}/Messages.json' \
--data-urlencode 'To=+19737219507'  \
--data-urlencode 'From=+12133194095'  \
--data-urlencode 'ContentRetention=discard' \
--data-urlencode 'AddressRetention=obfuscate' \
--data-urlencode 'Body=You cannot see what I am sending!' \
-u {SID}:{AuthToken} 

```
Using `retain` will not redact on a per API request basis if redaction is the default action. This is helpful during development and troubleshooting.

```
curl -X POST 'https://api.twilio.com/2010-04-01/Accounts/{SID}/Messages.json' \
--data-urlencode 'To=+19737219507'  \
--data-urlencode 'From=+12133194095'  \
--data-urlencode 'ContentRetention=retain' \
--data-urlencode 'AddressRetention=retain' \
--data-urlencode 'Body=Now you can see what I am sending!' \
-u {SID}:{AuthToken} 

```
At the time of writing the Twilio helper libraries do not include the redaction form data. Use http `POST` instead.

Here is a `Node.js` example with redaction enabled for a single API request.

```javascript

const request = require('request');

var options = {
    method: 'POST',
    url: 'https://api.twilio.com/2010-04-01/Accounts/{SID}/Messages.json',
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

