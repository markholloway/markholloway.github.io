---
layout: post
title: Install composer and globally initialize php projects on macOS
tags: [php, bash]
---

Apple includes `php` with macOS. Use the `composer` package manager to initialize php projects and install dependencies locally in the project folder. Run php's web server locally to test your project.

<!--more-->

## PHP version

Check the php version

```bash

macbookpro:~ mh$ php -v
PHP 7.1.19 (cli) (built: Aug 17 2018 20:10:18) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies

```
## Which PHP

To see what version of `php` macOS is using run the `which` command. 

```bash

macbookpro:~ mh$ which php
/usr/bin/php

```
There may be multiple php versions installed.  If `/usr/local/bin/php` is shown there is a chance another version of php has been installed with a package manager such as [`homebrew`](https://brew.sh).

```bash

macbookpro:~ mh$ which -a php
/usr/bin/php
/usr/locall/bin/php

```

Copy `php.ini.default` and name it `php.ini`.

```bash

sudo cp /private/etc/php.ini.default php.ini

```
Download `composer` with `curl` and move the file to `/usr/local/bin`

```bash

curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/local/bin

```
Add the following line to `.bash_profile` in your home directory.  This allows `composer` to run from folder.

```bash

echo alias composer="/usr/local/bin/composer.phar" >> ~/.bash_profile

```
Close terminal and re-open it.  Make a new folder called `myphp` for the new php project.

```bash

mkdir ~/Projects/myphp

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

php -S 127.0.0.1:5000

```
