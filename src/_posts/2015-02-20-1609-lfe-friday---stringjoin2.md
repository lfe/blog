---
layout: post
title: "LFE Friday - string:join/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is on [string:join/2](http://www.erlang.org/doc/man/string.html#join-2).

``string:join/2`` takes a list of strings as its first argument, and a string separator used to join the strings together into a single string.

```cl
> (string:join '("a" "b" "c") "")
"abc"
> (string:join '("a" "b" "c") "-")
"a-b-c"
```

The separator string can be a string of any length, and doesn't just have to be a single character.

```cl
> (string:join '("a" "b" "c") "___")
"a___b___c"
> (string:join '("a" "b" "c") " ")  
"a b c"
```

And as with any string, a list of characters, or even integers, can be used as the separator string.

```cl
> (string:join '("a" "b" "c") '(#\A))
"aAbAc"
> (string:join '("a" "b" "c") '(52)) 
"a4b4c"
```

-Proctor, Robert
