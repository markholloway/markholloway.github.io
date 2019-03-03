---
layout: post
title: Twilio Autopilot CLI
tags: [twilio,autopilot]
---
![]({{ site.baseurl }}/blog/assets/2019-03-03/ap-cli.png)
<!--more-->

`Autopilot` is Twilio's artificially intelligent bot platform for Voice, SMS, WhatsApp, Facebook Messenger, IVR, Slack, Alexa, and Google Assistant, while using natural langauge understanding and machine learning frameworks.


Everything required to build an Autopilot Assistant is provided in the Twilio [Console](http://www.twilio.com/console). Once I received word there is a CLI option I was immediately all over it. I love working in CLI mode.

## Install Autopilot CLI using Node Package Manager

Autopilot CLI is installed using `npm`

```bash
mark$ sudo npm install -g @twilio/autopilot-cli
```

In your terminal window enter `ta` to see output like the picture above.

## Configure Twilio Credentials

Autopilot CLI needs the SID and Auth Token for the account where Assistants will reside. Use the `--credentials` option when more than one account should be accessed from Autopilot CLI.

```bash
mark$ ta init

Please visit https://www.twilio.com/console
Fill in the Twilio ACCOUNT SID and Twilio AUTH TOKEN below 
to save/modify your Twilio credentials.

? Twilio ACCOUNT SID:
 ACXXXXXXXXXXXXXXXXXXXXXXXXXX

? Twilio AUTH TOKEN:
 feXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Once credentials are successfully added the Autopilot CLI will communicate with the Twilio platform to perform CLI actions.

## List Current Assistants Associated with the Account SID

```bash
mark$ ta list

UA52e35a7976b5fea8e544ba8 Make_a_Reservation
UA1c59d8db97e01531ecc5d65 Schedule_an_Appointment
UAda134911d1bce1aa68f2698 SMS_WhatsApp_FB_Customer_Service_Bot 
```

To try a demo of `Schedule an Appointment` dial `+1-213-319-4095`

## Exporting an Assistant Schema

I would like to check `Make a Reservation` and see if there is more work to be done building the Assistant. To do this I must export the schema as JSON

```bash
mark$ ta export
? Choose your assistant:  (Use arrow keys)
❯   Make_a_Reservation 
    Schedule_an_Appointment
    SMS_WhatsApp_FB_Customer_Service_Bot

Exporting Assistant......

File exported in Make_a_Reservation.json 
```

## View Exported JSON

```bash
mark$ more Make_a_Reservation.json
```

Below is the conents that makes up the `Make a Reservation` Assistant. It will be easiest to copy and paste into another application to view the entire contents of the file without scrolling.

```json
{
	"friendlyName" : "Restaurant",
	"logQueries" : true,
	"uniqueName" : "Restaurant",
	"defaults" : {
		"defaults" : {
			"assistant_initiation" : "task://initiation-task",
			"fallback" : "task://initiation-task",
			"collect" : {
				"validate_on_failure" : "task://initiation-task"
			}
		}
	},
	"styleSheet" : {
		"style_sheet" : {
			"collect" : {
				"validate" : {
					"on_failure" : {
						"repeat_question" : false,
						"messages" : [
							{
								"say" : "I'm sorry, can you please say that again"
							},
							{
								"say" : "hmm I still did'nt catch that, can you please repeat"
							},
							{
								"say" : "Let's give it one more try. Please say it one more time"
							}
						]
					},
					"on_success" : { "say" : "" },
					"max_attempts" : 4
				}
			},
			"voice" : {
				"say_voice" : "Polly.Matthew"
			}
		}
	},
	"fieldTypes" : [],
	"tasks" : [
		{
			"uniqueName" : "confirm-reservation",
			"actions" : {
				"actions" : [
					{
						"redirect" : {
							"uri" : "https://sand-mallard-4168.twil.io/deep-table-make-reservation"
						}
					}
				]
			},
			"fields" : [],
			"samples" : [
				{
					"language" : "en-US",
					"taggedText" : "confirm reservation"
				}
			]
		},
		{
			"uniqueName" : "make-reservation",
			"actions" : {
				"actions" : [
					{
						"collect" : {
							"on_complete" : {
								"redirect" : "task://confirm-reservation"
							},
							"name" : "make_reservation",
							"questions" : [
								{
									"type" : "Twilio.FIRST_NAME",
									"question" : {
										"say" : "Great, I can help you with that. What's your first name?"
									},
									"name" : "first_name"
								},
								{
									"type" : "Twilio.DATE",
									"question" : {
										"say" : "When day would you like your reservation for?"
									},
									"name" : "date"
								},
								{
									"type" : "Twilio.TIME",
									"question" : {
										"say" : "Great at what time?"
									},
									"name" : "time"
								},
								{
									"type" : "Twilio.NUMBER",
									"question" : {
										"say" : "For how many people"
									},
									"name" : "party_size"
								}
							]
						}
					}
				]
			},
			"fields" : [],
			"samples" : [
				{
					"language" : "en-US",
					"taggedText" : "How do I make a reservation?"
				},
				{
					"language" : "en-US",
					"taggedText" : "Can I make a reservation?"
				},
				{
					"language" : "en-US",
					"taggedText" : "I would like to make a reservation"
				},
				{
					"language" : "en-US",
					"taggedText" : "reservation tonight"
				},
				{
					"language" : "en-US",
					"taggedText" : "can i make a reservation"
				},
				{
					"language" : "en-US",
					"taggedText" : "reservations"
				},
				{
					"language" : "en-US",
					"taggedText" : "reservation for"
				},
				{
					"language" : "en-US",
					"taggedText" : "i would like to make a reservation"
				}
			]
		},
		{
			"uniqueName" : "get-specials",
			"actions" : {
				"actions" : [
					{
						"say" : "Today's special is seasoned prime rib with roasted mashed potatoes, super recommended, is there anything else I can help you with?"
					},
					{ "listen" : true }
				]
			},
			"fields" : [],
			"samples" : [
				{
					"language" : "en-US",
					"taggedText" : "the specials for today"
				},
				{
					"language" : "en-US",
					"taggedText" : "specials"
				},
				{
					"language" : "en-US",
					"taggedText" : "get today's special"
				},
				{
					"language" : "en-US",
					"taggedText" : "today's special"
				},
				{
					"language" : "en-US",
					"taggedText" : "dinner special"
				},
				{
					"language" : "en-US",
					"taggedText" : "I want today's special"
				},
				{
					"language" : "en-US",
					"taggedText" : "What's the special going on right now"
				},
				{
					"language" : "en-US",
					"taggedText" : "I would like to know what the specials are"
				},
				{
					"language" : "en-US",
					"taggedText" : "Doyou have any specials today?"
				},
				{
					"language" : "en-US",
					"taggedText" : "What's today's specials?"
				}
			]
		},
		{
			"uniqueName" : "initiation-task",
			"actions" : {
				"actions" : [
					{
						"say" : "Welcome to Deep Table, the worlds smartest restaurant, I'm Deep Table's Virtual Assistant, I can tell you about todays special or help you make a reservation, What would you like to do today?"
					},
					{ "listen" : true }
				]
			},
			"fields" : [],
			"samples" : [
				{
					"language" : "en-US",
					"taggedText" : "Hi there"
				},
				{
					"language" : "en-US",
					"taggedText" : "Hello"
				}
			]
		}
	],
	"modelBuild" : { "uniqueName" : "v0.10" }
}
```

## Modify Schema and Publish to Twilio

Once changes have been completed it is very easy to publish them to Twilio

```bash
markh$ ta update --schema Make_a_Reservation.json

Updating assistant.....

Assistant "Make_a_Reservation" was updated
```

## Handoff

It is possible to set a specifc number of times where Autopilot and the user are not progressing forward and the call should be re-routed to a live person. 

If the call setup should occur on Programmable Voice modify the following code

```json
{
	"actions": [
		{
			"say": "Hold on, we are connecting you with an agent"
		},
		{
			"handoff": {
				"channel": "voice",
				"uri": "INSET YOUR TWIML_URL HERE",
				"method": "POST"
			}
		}
	]
}
```

If the call should route to Twilio Taskrouter modify the following code

```json
{
	"actions": [
		{
			"handoff": {
				"channel": "voice",
				"uri": "taskrouter://WW0123456789abcddef"
			}
		}
	]
}
```

If using Flex and the call should route to a Flex queue modify the following code

```json
{
	"actions": [
		{
			"handoff": {
				"channel": "voice",
				"uri": "taskrouter://WW0123456789abcdef0",
				"wait_url": "https://myapp.com/music.php",
				"wait_url_method": "GET",
				"action": "https://myapp.com/survey.php",
				"priority": "5",
				"timeout": "200"
			}
		}
	]
}
```

Working with Autopilot CLI cranks up the fun to a new level. Enjoy!
 