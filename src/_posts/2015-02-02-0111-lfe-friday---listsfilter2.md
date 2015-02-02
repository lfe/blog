---
layout: post
title: "LFE Friday - lists:filter/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday is on [lists:filter/2](http://www.erlang.org/doc/man/lists.html#filter-2).

``lists:filter/2`` takes two arguments, a predicate function and a list to iterate over. The return value is a list of items for which the predicate function returns ``true`` for that item.

```cl
> (lists:filter (lambda (x) (=:= (rem x 2) 1)) '(1 2 3 4 5))
(1 3 5)
> (lists:filter #'erlang:is_atom/1 '(1 a 3 #(a b) World foo))
(a World foo)
> (lists:filter (lambda (x) (> x 0)) '(1 0 -3 foo -13 43))
(1 foo 43)
> (lists:filter (lambda (x) (> x 0)) ())
()
> (lists:filter (lambda (x) 'false) '(1 2 3 4 5))
()
> (lists:filter (lambda (x) 'true) '(1 2 3 4 5)) 
(1 2 3 4 5)
```

–Proctor, Robert
