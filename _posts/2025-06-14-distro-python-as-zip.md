---
layout: post
title:  Distribute python scripts as a zip file
tags: [python,maya,nuke]
---
Easily distribute a Python package to be run in applications such as Maya or Nuke by doing the following.
<!--more-->

Python can import  modules or packages even when zipped. Example, where b is our package and c.py is our actual program we want to run:

## Example zip file structure

```
a.zip
└── b <directory>
    ├── c.py
    └── __init__.py
```

The zip file will be imported like:

```python
import sys
sys.path.append('a.zip')
import b
from b import c
```

Users can drop the zip file into their local scripts folder (e.g. ~/Documents/maya/scripts for Maya or ~/.nuke for Nuke) and to run the following code, which will locate the a.zip, import it and execute the program:

```python
import sys
import os

_zipfile = 'a.zip'
for _path in sys.path:
    if os.path.isdir(_path) and _zipfile in os.listdir(_path):
        sys.path.append(os.path.join(_path, _zipfile))
        import b

from b import c
```

Bonus: add a __main__.py to the zip file's root and you can execute it with python a.zip.

In Maya users can create a Shelf button or even bundle a shelf MEL file, to be placed in e.g. ~/Documents/maya/2025/prefs/shelves