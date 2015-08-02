---
layout: post
title: "LFE Friday - ordsets:subtract/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday comes from a sunny Gotland and is on [ordsets:subtract/2](http://erlang.org/doc/man/ordsets.html#subtract-2).

``ordsets:subtract/2`` takes two ordered sets as its arguments, and returns a ordered set containing the items of the first ordered set that are not in the second ordered set.

```lisp
> (set set-1 (ordsets:from_list '(5 4 3 2 1)))
(1 2 3 4 5)
> (set set-2 (ordsets:from_list '(1 1 2 3 5 8 13)))
(1 2 3 5 8 13)
> (set set-3 (ordsets:from_list '(2 -2 4 -4 16 -16)))
(-16 -4 -2 2 4 16)
> (set empty-set (ordsets:new))
()
> (ordsets:subtract set-1 set-2)
(4)
> (ordsets:subtract set-1 empty-set)
(1 2 3 4 5)
> (ordsets:subtract set-2 empty-set)
(1 2 3 5 8 13)
> (ordsets:subtract empty-set set-1)
()
> (ordsets:subtract set-2 set-3)
(1 3 5 8 13)
```

And note that ``ordsets:subtract/2`` is not commutative, unlike ``ordsets:union/2`` or ``ordsets:intersection/2``.

```lisp
> (ordsets:subtract set-1 set-3)
(1 3 5)
> (ordsets:subtract set-3 set-1)
(-16 -4 -2 16)
```

And again, your friendly reminder if you haven't been following along, just because Ordered Sets in LFE are represented as a List, doesn't mean that Lists are Ordered Sets.

-Proctor, Robert
