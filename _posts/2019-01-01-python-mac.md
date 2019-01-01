---
layout: post
title: Using Apple python 2.7 and pip in macOS
tags: [python, bash]
---

Apple includes `python` with macOS. Although `python 3` is well adopted it is not backwards compatible with python 2 and many industries continue relying on python 2 for it's speed, flexibility, and libraries.

<!--more-->

## Python version

Check the python version in macOS

```bash

python -v
Python 2.7.10

```
## Which Python

Check the `python` binary macOS executes by default using the `which` command. In most cases it will be `/usr/bin/python` unless another version of python has been installed. 

```bash

which python
/usr/bin/python

```

Adding `-a` will indicate if there is more than one version of python installed. This may be from [python.org](http://www.python.org) or a package manager such as [homebrew](gttp://brew.sh) which allows a isolate Python 2.7 and 3.7 installation to co-exist. 

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

Add the following line to `.bash_profile` in your home directory. This will install packages locally and avoids permission problems. It is not recommend to install packages in macOS system folders as `sudo`. 

```bash

export PATH="$HOME/Library/Python/2.7/bin:$PATH"

```
Close terminal and re-open it, or `source` the file.

```bash

source ~/.bash_profile

```

Install `pylint` which is a linter used for code analysis, error detection, and is supported by many IDEs. 

```bash

pip install pylint --user
Installing pylint in /Users/mh/Library/Python/2.7/lib/python/site-packages (1.9.3)

```

Install `pipenv` for managing a python project and virtual environment, as well as adding/removing packages within the project folder itself rather than in macOS folders.

```bash

pip install pipenv --user

```
Make a new directory for a python project and run `pipenv` and sepcify the python version the project will use.

```bash

cd ~/Documents/GitHub
mkdir myproject

mbp2017:myproject mh$ pipenv --python 2.7
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

Read more on [`pipenv`](https://pypi.org/project/pipenv/) and check [this](https://gist.github.com/bradtraversy/c70a93d6536ed63786c434707b898d55) handy list of common commands.