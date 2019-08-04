---
layout: post
title: Acme Packet SBC Command Line “more” Option for “show running-config”
tags: [acme,sbc,sip]
---
This short tip helps if you prefer not to have your SBC output display all at once simply enable the `more` ACLI element.

<!--more-->

![]({{ site.baseurl }}/blog/assets/apkt/apkt-acme-sbc-more01.png)

Also, you can display just the specific show run element you are looking for. The example below will show whatever `local-policy` elements are configured on the system.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-acme-sbc-more02.png)

There is the ability to filter output based on specific criteria. Options will vary depending on which `running-config` element entered.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-acme-sbc-more03.png)

Either the entire output of the `running-config` or the sub-elements may be output to a file and retrieved through FTP via the management interface.

![]({{ site.baseurl }}/blog/assets/apkt/apkt-acme-sbc-more04.png)

