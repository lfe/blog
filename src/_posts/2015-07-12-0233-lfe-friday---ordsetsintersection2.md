---
layout: post
title: "LFE Friday - ordsets:intersection/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday comes from Gotland and looks some more at that ``ordsets`` module and covers [ordsets:intersection/2](http://erlang.org/doc/man/ordsets.html#intersection-2).

``ordsets:intersection/2`` takes two ordered sets and returns a new ordered set that is the intersection of the two ordered sets provided.  For those who don't have a background with set theory, all a set intersection is is the set of items that all the sets we are intersecting have in common.

```lisp
> (set set-1 (ordsets:from_list '(1 2 1 3 2 4 4 9)))
(1 2 3 4 9)
> (set set-2 (ordsets:from_list '(1 3 5 7 9)))
(1 3 5 7 9)
> (ordsets:intersection set-1 set-2)
(1 3 9)
> (ordsets:intersection set-2 set-1)
(1 3 9)
```

Because ``ordsets:intersection/2`` looks for the common elements in the ordered sets, it is commutative, and as we see above, we get the same result regardless of which order we pass in the two ordered sets as arguments.

If there are no items in common, the returned result is an empty ordered set (really an empty list, but see [last week's post on ordsets:union/2](http://blog.lfe.io/tutorials/2015/07/04/0959-lfe-friday---ordsetsunion2/) on the dangers of just using a list as a ordered set).

```lisp
> (set evens (ordsets:from_list (lists:seq 2 20 2)))
(2 4 6 8 10 12 14 16 18 20)
> (set odds (ordsets:from_list (lists:seq 1 20 2)))
(1 3 5 7 9 11 13 15 17 19)
> (ordsets:intersection set-2 (ordsets:new))
()
> (ordsets:intersection evens odds)
()
```

Erlang also provides [ordsets:intersection/1](http://erlang.org/doc/man/ordsets.html#intersection-1), that takes a list of ordered sets as its argument, and returns the intersection of all the ordered sets in that list.

```lisp
> (set set-3 (ordsets:from_list '(1 1 2 3 5 8)))
(1 2 3 5 8)
> (ordsets:intersection (list evens odds set-1))
()
> (ordsets:intersection (list odds set-2 set-1))
(1 3 9)
> (ordsets:intersection (list evens set-1 set-3))
(2)
> (ordsets:intersection (list odds set-1 set-3))
(1 3)
```

-Proctor, Robert
