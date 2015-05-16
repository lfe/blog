---
layout: post
title: "LFE Friday - filelib:is_file/1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is [filelib:is_file/1](http://www.erlang.org/doc/man/filelib.html#is_file-1).

``filelib:is_file/1`` takes a string representing a filename, and returns a ``true`` or ``false`` depending on if the name refers to a file or directory.

This can be useful if you are having to read from a configuration file and need to ensure that the file or directory exists before trying to process it, so that you can give a nice error message before quitting, instead of just causing a system error to be raised.

```lisp
> (filelib:is_file "foo")
false
> (filelib:is_file "tmp")
false
> (filelib:is_file "src")
true
> (filelib:is_file "README.md")
true
> (filelib:is_file "/usr/local/bin")
true
> (filelib:is_file "/usr/local/var")
false
> (filelib:is_file ".")
true
> (filelib:is_file "..")
true
```

``filelib:is_file/1`` can also take a atom, or even a deeplist(), representing the filename as well.

```lisp
> (filelib:is_file 'foo)
false
> (filelib:is_file '("/usr" (/local /bin)))
true
```

-Proctor, Robert
