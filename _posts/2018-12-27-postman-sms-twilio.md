---
layout: post
title: Configuring Postman to send SMS messages from your Twilio number
tags: [twilio]
---

[`Postman`](https://www.getpostman.com) is a [free](https://www.getpostman.com) application for macOS, Linux, and Windows, that simplifies `API` development and testing. The following `screenshots` shows how to configure Postman to work with `Twilio` and send SMS messages.

<!--more-->

## Adding the Twilio URL and Authentication Credentials

Click the `+` symbol next to `...` in the tab section. The new tab defaults to `GET`. This must be changed to `POST` by clicking the drop down arrow.

Click `Auth` and verify the green circle is lit. Add the Twilio account `SID` as the username and `Auth Token` as the password. Set the `Type` to `Basic Auth` in the dropdown list. 

![]({{ site.baseurl }}/blog/assets/postman/postman-add-auth.png)

## Adding phone numbers and message data

Click `Body` and enter the `Key` values representing `To` and `From` phone numbers and `Body` for message content. 

![]({{ site.baseurl }}/blog/assets/postman/postman-body.png)

## Send a text message

Click the `SEND` button to `POST` the `HTTP` request to Twilio.

![]({{ site.baseurl }}/blog/assets/postman/postman-send.png)

## Twilio JSON response

Twilio responds to HTTP Requests in `JSON` format. If the text was sent successfully the response from Twilio provides details about the SMS transaction. Click the `Pretty` option in Postman and the JSON data will be presented in a readable format.

![]({{ site.baseurl }}/blog/assets/postman/postman-json.png)
