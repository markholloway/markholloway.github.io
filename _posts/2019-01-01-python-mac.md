---
layout: post
title: Using Apple python 2.7 and pip in macOS
tags: [python, bash]
---

Apple includes `python 2.7` with macOS. This brief overview explains how to use python 2.7 without the need for `sudo` or installing to system folders.

<!--more--> 
 Most users install python 2.7 using the [homebrew](http://brew.sh) package manager or by directly downloading python 2.7 from [python.org](http://python.org). This results in two or more versions of python 2 installed on the same machine. Below is a third option that uses python 2.7 included with macOS and safely installs pip packages in a user directory rather than systems folders requiring `sudo` privilages. 

## Python version

Check the python version in macOS

```bash

python -v
Python 2.7.10

```
## Which Python

Check the `python` binary file macOS executes by default using the `which` command. In most cases it will default to `/usr/bin/python` unless another version of python has been installed. 

```bash

which python
/usr/bin/python

```

Adding `-a` will indicate if there is more than one version installed.

```bash

which -a python
/usr/bin/python
/usr/local/opt/python/libexec/bin/python

```

Assuming `/usr/bin/python` ensure the `pip` package manager is installed

```bash

which -a pip
/usr/bin/pip

```
If pip is not installed run `easy_install`. 

```bash

sudo easy_install pip
Password:
Searching for pip
Best match: pip 18.1
Adding pip 18.1 to easy-install.pth file
Installing pip script to /usr/local/bin
Installing pip3.7 script to /usr/local/bin
Installing pip3 script to /usr/local/bin

Using /Library/Python/2.7/site-packages
Processing dependencies for pip
Finished processing dependencies for pip

```

Add the following line to `.bash_profile` in your home directory. This follows best practices and will install packages in a local user folder without the need for root privilages or accessing system folders. 

```bash

export PATH="$HOME/Library/Python/2.7/bin:$PATH"

```
Close terminal and re-open it, or `source` the file.

```bash

source ~/.bash_profile

```

Installing `pylint` helps with code analysis, error detection, and is supported by many editors. 

```bash

pip install pylint --user
Installing pylint in /Users/mh/Library/Python/2.7/lib/python/site-packages (1.9.3)

```

Install `pipenv` for managing python projects in a virtual environment. Highly recommended.

```bash

pip install pipenv --user

```
Make a new directory for a python project and run `pipenv` and sepcify the python version the project will use.

```bash

cd ~/Documents/GitHub
mkdir myproject
cd myproject

pipenv --python 2.7
Creating a virtualenv for this project...
Pipfile: /Users/mh/Documents/GitHub/myproject/Pipfile
Using /usr/bin/python (2.7.10) to create virtualenv...
⠹ Creating virtual environment...Already using interpreter /usr/bin/python
New python executable in /Users/mh/.local/share/virtualenvs/myproject-MzfeKDeP/bin/python
Installing setuptools, pip, wheel...
done.

✔ Successfully created virtual environment! 
Virtualenv location: /Users/mh/.local/share/virtualenvs/myproject-MzfeKDeP
Creating a Pipfile for this project...

```

Read more on [`pipenv`](https://pypi.org/project/pipenv/) and check [this](https://gist.github.com/bradtraversy/c70a93d6536ed63786c434707b898d55) handy list of common commands from [Brad Traversy](http://traversymedia.com).