---
layout: post
title: Install composer and globally initialize php projects in macOS
tags: [php, bash]
---

Apple includes `php` with macOS. The `composer` package manager initializes php projects and installs dependencies locally in the project folder. Use php's built in web server to locally test your project.

<!--more-->

## PHP version

Check the php version macOS is using

```bash

macbookpro:~ mh$ php -v
PHP 7.1.19 (cli) (built: Aug 17 2018 20:10:18) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies

```
## Which PHP

Check the `php` binary macOS executes by default using the `which` command. In most cases it will be `/usr/bin/php` unless a separate php install exists. 

```bash

macbookpro:~ mh$ which php
/usr/bin/php

```
Adding the `-a` will indicate if there is more than one version of php installed.

```bash

macbookpro:~ mh$ which -a php
/usr/bin/php
/usr/locall/bin/php

/usr/local/bin/php -v 

PHP 7.3.4 (cli) (built: Nov 27 2018 09:10:18) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies

```

Assuming `/usr/bin/php` copy `php.ini.default` and name it `php.ini` which will be used by `composer`

```bash

macbookpro:~ mh$ sudo cp /private/etc/php.ini.default php.ini

```
Download `composer` with `curl` and move the file to `/usr/local/bin`

```bash

curl -sS https://getcomposer.org/installer | php

macbookpro:~ mh$ sudo mv composer.phar /usr/local/bin

```
Add the following line to `.bash_profile` in your home directory.  This allows `composer` to run from folder.

```bash

echo alias composer="/usr/local/bin/composer.phar" >> ~/.bash_profile

```
Close terminal and re-open it.  Make a new folder called `myphp` for the new php project.

```bash

macbookpro:~ mh$ mkdir ~/Projects/myphp

```
Initialize the project with `composer`

```bash

mbpbookpro:myphp mh$ composer init

                                            
  Welcome to the Composer config generator  
                                            
This command will guide you through creating your composer.json config.

Package name (<vendor>/<name>) [mh/myphp]: 
Description []: My PHP Project
Author [Mark Holloway, n to skip]: 
Minimum Stability []: 
Package Type (e.g. library, project, metapackage, composer-plugin) []: project
License []: 

Define your dependencies.

Would you like to define your dependencies (require) interactively [yes]? 
Search for a package: twilio/sdk
Enter the version constraint to require (or leave blank to use the latest version): 
Using version ^5.27 for twilio/sdk
Search for a package: 
Would you like to define your dev dependencies (require-dev) interactively [yes]? 
Search for a package: 

{
    "name": "mh/myphp",
    "description": "My PHP Project",
    "type": "project",
    "require": {
        "twilio/sdk": "^5.27"
    },
    "authors": [
        {
            "name": "Mark Holloway"
        }
    ]
}

Do you confirm generation [yes]? 
Would you like to install dependencies now [yes]? 
Loading composer repositories with package information
Updating dependencies (including require-dev)
Package operations: 1 install, 0 updates, 0 removals
  - Installing twilio/sdk (5.27.0): Loading from cache
Writing lock file
Generating autoload files

```
Use the internal php web server for testing during development.

```bash

macbookpro:~ mh$ php -S 127.0.0.1:5000

```
