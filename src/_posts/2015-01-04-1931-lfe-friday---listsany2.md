---
layout: post
title: "LFE Friday - lists:any/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday function of the week is [lists:any/2](http://www.erlang.org/doc/man/lists.html#any-2).

``lists:any/2`` takes a predicate function as the first argument, and a list to iterate over as its second argument. ``lists:any/2`` returns ``true`` if the predicate function returns ``true`` for any of the elements in the given list, otherwise, ``lists:any/2`` returns ``false``.

```cl
> (lists:any #'erlang:is_atom/1 '(1 2 3 4 5 6 7))
false
> (lists:any #'erlang:is_atom/1 '(1 2 3 4 a 6 7))
true
> (lists:any #'erlang:is_atom/1 '(#(1 2) 3 4 a 6 7))
true
> (lists:any (lambda (x) (== (rem x 2) 1)) '(1 2 4))
true
> (lists:any (lambda (x) (== (rem x 2) 1)) '(0 2 4))
false
```

``lists:any/2`` is eager, and will return with a result of ``true`` as soon as it is found, and will ignore processing the rest of the list.

```cl
> (timer:tc 'lists 'any (list (lambda (x) (== (rem x 2) 1)) (lists:seq 2 200000 2))) 
#(171661 false)
> (timer:tc 'lists 'any (list (lambda (x) (== (rem x 2) 0)) (lists:seq 2 200000 2)))
#(19 true)
```

The ``lists`` module also contains a function [lists:all/2](http://www.erlang.org/doc/man/lists.html#all-2), similar to ``lists:any/2``, but checks if the predicate function returns ``true`` for every element in the supplied list.

```cl
> (lists:all #'erlang:is_number/1 '(1 2 3 4 a 6 7))
false
> (lists:all #'erlang:is_number/1 '(1 2 3 4 5 6 7))
true
```

``lists:all/2`` is also eager, and will return with a result of ``false`` as soon as it is found, and will ignore processing the rest of the list.

```cl
> (timer:tc 'lists 'all (list (lambda (x) (== (rem x 2) 0)) (lists:seq 2 200000 2)))
#(170436 true)
> (timer:tc 'lists 'all (list (lambda (x) (== (rem x 2) 1)) (lists:seq 2 200000 2)))
#(18 false)
```

–Proctor, Robert
