---
layout: post
title: Area Code lookup using BASH
tags: [bash]
---
This is a script that looks up an area code in the United States or Canada and returns the city and state it is assigned to by the North American `NPA-NXX` Wire Center 
<!--more-->

I wrote this script after becoming frustrated each time I needed to look up an area code to see what state it belongs to and realizing I'm wasting time searching. I kept telling myself I'll write a script to do it. Well, I finally got around to it.

## Service Provider Lesson of the Day

In the United State and Canada the first 3 digits of a 10 digit phone number are referred to as the Number Plan Area or `NPA`. That's what the rest of us call an Area Code. The second set of 3 digits are the Exchange, or Central Switching Office Designation, and referred to as `NXX`. The last 4 digits of a phone number are `XXXX` and referred to as the `SLI` or Subscriber Line Identifier. 

Standard formatting is represented as `NPA-NXX-XXXX`. In the number `415-523-8886` the NPA is 415 and the NXX is 523. The SLI is 8886.

Last item to note is the reason for `NPA-NXX` is for carriers to know what `LATA` (Local Access and Transport Area) the NPA-NXX originates from. In telco terminology this is the `rate center` your number belongs to. The LATA is the invisible line that determines when your call is local or long distance. There's more to it than that, but I'll save the rest for another day.


## View the completed script

Below is the shell script `npa.sh` in its final form.

```bash
#!/bin/bash
#United States and Canada NPA Lookup
#
#To run this script execute npa.sh followed by the three digit NPA
#
# npa.sh 404
# NPA 404 =  N Georgia: Atlanta and suburbs 


source="https://www.bennetyee.org/ucsd-pages/area.html"

if [ -z "$1" ] ; then
	echo "Include a three digit NPA: npa.sh XXX"
	exit 1
fi

if [ "$(echo $1 | wc -c)" -ne 4 ] ; then
	echo "NPA must be three digits."
	exit 1
fi

if [ ! -z "$(echo $1 | sed 's/[[:digit:]]//g')" ] ; then
	echo "Letters are are not compliant with NPA formatting."
	exit 1
fi

result="$(curl -s -dump $source | grep "name=\"$1" | \
	sed 's/<[^>]*>//g;s/^ //g' | \
	cut -f2- -d\ | cut -f1 -d\()"
	
echo "NPA $1 =$result"

exit
```

## Example

I run the `npa.sh` script and want to know what city and state NPA 404 belongs to. I immediately receive a result that says it's North Georgia and includes Atlanta and the greater surrounding area. 

```bash
mbp2018$ npa.sh 404

NPA 404 =  N Georgia: Atlanta and suburbs
```

## How the Script Works

First we assign the variable name `source` to the `URL` which is the source of our data where we extract the answer for the NPA query.

```bash
source="https://www.bennetyee.org/ucsd-pages/area.html"
```

The next three sections validate proper NPA formatting otherwise the result will fail. The NPA is referenced by the variable `$1`

```bash
if [ -z "$1" ] ; then
	echo "Include a three digit NPA: npa.sh XXX"
	exit 1
fi

if [ "$(echo $1 | wc -c)" -ne 4 ] ; then
	echo "NPA must be three digits."
	exit 1
fi

if [ ! -z "$(echo $1 | sed 's/[[:digit:]]//g')" ] ; then
	echo "Letters are are not compliant with NPA formatting."
	exit 1
fi
```

The next section is the core of the script. I will break it down into smaller components.

```bash
result="$(curl -s -dump $source | grep "name=\"$1" | \
	sed 's/<[^>]*>//g;s/^ //g' | \
	cut -f2- -d\ | cut -f1 -d\()"
```

A variable `result` is assigned to whatever the final output will be from the rest of the script. When returning the answer to the query we simply tell it to `echo` the `result` back tot he user.

```bash
result=
```

`curl` is a command line utility which supports many protocols including HTTPS to send and receive data. In this case curl is `-silently` recevieving a `-dump` of information from our `$source` variable we identified (https URL).  

```bash
"$(curl -s -dump $source"
```

Paste the line below in your terminal to see what's happening in realtime. This will return data in HTML format to your terminal window. 

```bash
curl -dump https://www.bennetyee.org/ucsd-pages/area.html"
```

Once the source has dumped the data back to us we must `grep` (search and match) the NPA we are looking for.

```bash
"$(curl -s -dump $source | grep "name=\"$1"
```

If you run the raw curl script above the results provide NPA data that looks like the following. This is what `grep` is looking for.

```html
<a name="404">404</a>
```

Below is an example of the full section from the source that contains information about NPA 404. It's more than we need and would not make for usable output on the terminal.

```html
<tr>
  <td align=center><a name="404">404</a></td>
  <td align=center>GA</td>
  <td align=center>-5</td>
  <td> N Georgia: Atlanta and suburbs </td>
  <td><a href="#678">678</a>, split <a href="#770">770</a></td>
</tr>

```

`sed` is a standard Unix utility which uses regular expressions to manipulate interesting data. In this case remove the unnecessary HTML. 

`cut` is another standard Unix utility used to extract specific alphanumeric content and write to a file or pipe to another output.  

```bash
sed 's/<[^>]*>//g;s/^ //g'
cut -f2- -d\ | cut -f1 -d\()"
```

Once again everything in the last section shown together as a multi-stage script. 

```bash
result="$(curl -s -dump $source | grep "name=\"$1" | \
	sed 's/<[^>]*>//g;s/^ //g' | \
	cut -f2- -d\ | cut -f1 -d\()"
```

The final line in the script takes the data stored in the `result` variable to `echo` the output on the screen. 

```bash
echo "NPA $1 =$result"
```

## Executing `npa.sh` from macOS Terminal

I prefer to keep the script in `/usr/local/bin` for faster execution. Otherwise there's little to gain over using a web browser and searching online. 

```bash
mbp2018$ npa.sh 404

NPA 404 =  N Georgia: Atlanta and suburbs 
```
