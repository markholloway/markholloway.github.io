---
layout: post
title:  Using the Lookup API for number validation and fraud prevention
tags: [twilio,lookup]
---
With the Twilio `Lookup` API it's possible to obtain information about a caller such as caller name, carrier name, carrier type, number type, and porting history. 
<!--more-->

Twilio provides the `Lookup` API as a way to validate if a number is real or ficticious and provide additional details associated with the number. The data Twilio provides is real-time. This is critical to knowing if a phone number was stolen and ported or sim-swapped. People who intend to commit fraud operate quickly and having real time data available is critical to fraud prevention. 

## Use cases for Lookup

When users visit a web site and fill out a form they may be required to enter their mobile or home phone number. Lookup can instantly validate the formatting and make sure digits were not inadvertantly mistyped. If a user enters a landline in a mobile number field, which may also have an opt-in for SMS, Lookup will recognize the number entered is not a mobile number. 

In other cases malicious users may obtain numbers in bulk with the intention of using them for fraud. Lookup can differentiate easily obtained `VoIP` numbers from landline and mobile numbers.

Often times Contact Centers would like to know if callers are calling from a mobile phone and will use Lookup to note the information and make the Agent aware the user is calling from a mobile phone and present the "In case we get dropped..." script.

True story. A top C level of a crypto-currency company had his phone number stolen, ported to another carrier, and sim-swapped within minutes. A person with malicious intent began accessing financial accounts to start transferring money. 2FA with authorization codes sent via SMS to the mobile number were not an issue since the number was now controlled by someone else. This all went down within 45 minutes. There are many ways this could have been prevented, but one simple step is when a user's mobile number has been very recently ported, whether minutes, hours, or days, do not allow financial transaction beyond a trivial amount. 


## Using Lookup

To immediately see Lookup in action for Disney World's number `4079395277` log in to the Twilio console and on the left side of the screen select Lookup. If you do not see Lookup click on the three `...` on the bottom left bar. Using Lookup in console is handy for demonstration purposes or manually performing a lookup request.

![]({{ site.baseurl }}/blog/assets/2019-03-16/lookup-console.png)

Here is an example of Lookup using `CURL` for the same phone number. The results are returned by Twilio in JSON format. I use the `-o` option to save the results in a file called `lookup.json`

```

curl -XGET "https://lookups.twilio.com/v1/PhoneNumbers/4079395277?CountryCode=US&Type=carrier" \
-u '{SID}:{AuthToken}' \
-o lookup.json

```

Using `Node.js` with the npm Twilio helper library 

```javascript

const accountSid = '{SID}';
const authToken = '{AuthToken}';
const client = require('twilio')(accountSid, authToken);

client.lookups.phoneNumbers('4079395277')
              .fetch({type: 'caller-name'})
              .then(phone_number => console.log(phone_number.callerName));


```


Results returned in `JSON` format

```json

{
  "caller_name": {
    "caller_name": "DISNEY RESV CTR",
    "caller_type": "BUSINESS",
    "error_code": null
  },
  "country_code": "US",
  "phone_number": "+14079395277",
  "national_format": "(407) 939-5277",
  "carrier": {
    "mobile_country_code": null,
    "mobile_network_code": null,
    "name": "Smart City Telecommunications, LLC dba Smart City Telecom",
    "type": "landline",
    "error_code": null
  },
  "add_ons": null,
  "url": "https://lookups.twilio.com/v1/PhoneNumbers/+14079395277?Type=carrier&Type=caller-name"
}

```