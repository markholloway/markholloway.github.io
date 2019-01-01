---
layout: post
title: Using Apple python and pip2 in macOS
tags: [python, bash]
---

Apple includes `python 2.7` with macOS. Although `python 3` is widely adopted it is not backwards compatible with python 2 and many industries such as visual fx still rely on python 2 for it's speed, flexibility, and compatibly.

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

Adding `-a` will indicate if there is more than one version of python installed such as an installation from a [`homebrew`](gttp://brew.sh)

```bash

which -a python
/usr/bin/python
/usr/local/opt/python/libexec/bin/python

```

Assuming `/usr/bin/python` ensure the pip package manager is installed

```bash

which -a pip
/usr/bin/pip

```
If pip is not present run `easy_install`

```bash

sudo easy_install pip

```

Add the following line to `.bash_profile` in your home directory. This will install packages locally and avoids using sudo or running into permission problems. 

```bash

export PATH="$HOME/Library/Python/2.7/bin:$PATH"

```
Close terminal and re-open it or source the file.

```bash

source ~/.bash_profile

```

Install `pylint` which is used for code analysis, error detction, and support by many IDEs. 

```bash

pip install pylint
Installing pylint in /Users/mh/Library/Python/2.7/lib/python/site-packages (1.9.3)

```

Apple python 2.7 should now be ready for developer use. Next we will look at using `pipenv`