---
layout: post
title: "LFE Friday - lists:dropwhile/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s Erlang Thursday is [lists:dropwhile/2](http://www.erlang.org/doc/man/lists.html#dropwhile-2).

``lists:dropwhile/2`` takes a predicate function and a list, and returns a list where the first series of items for which the predicate function returned ``true`` have been removed.

```cl
> (lists:dropwhile #'erlang:is_atom/1 '(hello World 1 3 4))
(1 3 4)
> (lists:dropwhile (lambda (x) (> x 0)) '(-1 0 1 2 3))       
(-1 0 1 2 3)
> (lists:dropwhile (lambda (x) (> x 0)) '(-2 -1 0 1 2 3))
(-2 -1 0 1 2 3)
> (lists:dropwhile (lambda (x) (< x 0)) '(-2 -1 0 1 2 3))
(0 1 2 3)
> (lists:dropwhile (lambda (x) (< x 0)) '(0 -1 -2 -3 -4 -5))
(0 -1 -2 -3 -4 -5)
> (lists:dropwhile (lambda (x) 'true) '(hello World 1 3 bar 4))
()
> (lists:dropwhile (lambda (x) 'false) '(hello World 1 3 bar 4))
(hello World 1 3 bar 4)
```

Unlike [lists:filter/2](http://blog.lfe.io/tutorials/2015/02/02/0111-lfe-friday---listsfilter2/), ``lists:dropwhile/2`` stops checking the list as soon as the predicate function returns ``false``. This means that elements for which the predicate function would return ``true`` can still appear in the result list, as if they occur after an element for which the predicate function returns ``false``.

```cl
> (lists:dropwhile #'erlang:is_atom/1 '(hello World foo 1 3 bar 4))
(1 3 bar 4)
> (lists:filter (lambda (x) (not (is_atom x))) '(hello World foo 1 3 bar 4))   
(1 3 4)
> (lists:dropwhile (lambda (x) (< x 0)) '(-2 -1 0 1 -5 3 7))                   
(0 1 -5 3 7)
> (lists:filter (lambda (x) (>= x 0)) '(-2 -1 0 1 -5 3 7))                  
(0 1 3 7)
```

–Proctor, Robert
