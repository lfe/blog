---
layout: post
title: "LFE Friday - erlang:list_to_atom/1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday covers [erlang:list_to_atom/1](http://www.erlang.org/doc/man/erlang.html#list_to_atom-1).

``erlang:list_to_atom/1`` takes a string, and returns an Erlang atom.

```cl
> (list_to_atom "foo")
foo
> (list_to_atom "Foo")
Foo
> (list_to_atom "foo-bar")
foo-bar
> (list_to_atom "foo bar")
|foo bar|
> (list_to_atom (++ "foo" "-" "bar"))
foo-bar
> (list_to_atom "Erlang")
Erlang
> (list_to_atom "the LFE way")   
|the LFE way|
> (list_to_atom "Erlang and Elixir")
|Erlang and Elixir|
```

This can be useful if you are having to create keys or identifiers based off strings read in from outside the system, such as parsing a CSV style header.

```cl
> (lists:map #'erlang:list_to_atom/1
             (string:tokens "firstName,lastName,age,gender,preferredName,dateOfBirth" ","))
(firstName lastName age gender preferredName dateOfBirth)
```

You do need to be careful when using ``erlang:list_to_atom/1`` on strings acquired from the outside world of your program, as it only handles strings with character values under 256. But any character value[^1] under 256 is fair game to be turned into an atom.

```cl
> (list_to_atom "Joe, Mike and Robert")
|Joe, Mike and Robert|
> (list_to_atom "it's")
it's
> (list_to_atom "hey\n")
|hey\n|
> (list_to_atom (++ "with-supported-char-" [255]))
with-supported-char-ÿ
> (list_to_atom (++ "with-supported-char-" [256]))
exception error: badarg
  in (: erlang list_to_atom (119 105 116 104 45 115 117 112 112 111 ...))
```

-Proctor, Robert

----

[^1]: Remember that character values are non-negative integer values as well, 0-255 inclusive.
