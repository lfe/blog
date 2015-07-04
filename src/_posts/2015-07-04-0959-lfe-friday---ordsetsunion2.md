---
layout: post
title: "LFE Friday - ordsets:union/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday comes from PolyConf in a sunny Poznan and is on [ordsets:union/2](http://erlang.org/doc/man/ordsets.html#union-2).

``ordsets:union/2`` takes two ordered sets and returns an merged ordered set of the arguments.

```lisp
> (set set-a (ordsets:from_list '(1 1 2 3 5)))
(1 2 3 5)
> (set set-b (ordsets:new))
()
> (set set-c (ordsets:from_list '(3 1 4 1 5 9)))
(1 3 4 5 9)
> (set set-d (ordsets:from_list '(e d c b a)))
(a b c d e)
> (set union-ab (ordsets:union set-a set-b))
(1 2 3 5)
> (set union-ac (ordsets:union set-a set-c))
(1 2 3 4 5 9)
```

And because a string in LFE is just a list of characters, we can also create ordered sets from strings, and then get a union of the unique characters that are in two strings.

```lisp
> (ordsets:from_list "Kermit")
"Keimrt"
> (ordsets:from_list '(75 101 114 109 105 116))
"Keimrt"
> (ordsets:from_list "Mississippi")
"Mips"
> (ordsets:union (ordsets:from_list "Kermit") (ordsets:from_list "Mississippi"))
"KMeimprst"
```

The ``ordsets`` modules also contains [ordsets:union/1](http://erlang.org/doc/man/ordsets.html#union-1), which takes a list of ordered sets and returns the union of all the ordered sets in the list.

```lisp
> (set union-ac (ordsets:union (list set-a set-c)))
(1 2 3 4 5 9)
> (set union-abc (ordsets:union (list set-b set-c set-a)))
(1 2 3 4 5 9)
> (set union-abcd (ordsets:union (list set-b set-c set-a set-d)))
(1 2 3 4 5 9 a b c d e)
> (set union-cd (ordsets:union (list set-c set-d)))              
(1 3 4 5 9 a b c d e)
```

WARNING: While the representation for an ordered set is just a list, if you pass a list to ``ordsets:union/2`` you will not get what you expect, as it expects the items in each "ordered set" to actually be *ordered* and a *set*.

```lisp
> (ordsets:union '((1 2 3) (a b c)))
(1 2 3 a b c)
> (ordsets:union '((1 1 2 3 1 2) (a b c)))
(1 1 2 3 1 2 a b c)
> (ordsets:union '((1 1 2 3 1 2) (1 a b c)))
(1 1 2 3 1 2 a b c)
> (ordsets:union '((1 1 2 3 1 2) (1 a b c 1)))
(1 1 2 3 1 2 a b c 1)
```

-Proctor, Robert
