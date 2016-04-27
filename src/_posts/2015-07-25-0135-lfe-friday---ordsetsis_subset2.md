---
layout: post
title: "LFE Friday - ordsets:is_subset/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday again comes from Gotland and covers [ordsets:is_subset/2](http://erlang.org/doc/man/ordsets.html#is_subset-2).

``ordsets:is_subset/2`` takes two Ordered Sets, and checks if the ordered set passed in as the first argument is a subset of ordered set passed in as the argument.  For a given set, Set A, to be a subset of another set, Set B, every item in Set A must also be a member of Set B.

```lisp
> (set set-a (ordsets:from_list (lists:seq 1 10)))
(1 2 3 4 5 6 7 8 9 10)
> (set set-b (ordsets:from_list (lists:seq 2 10 2)))
(2 4 6 8 10)
> (set set-c (ordsets:from_list (lists:seq 1 15 3)))
(1 4 7 10 13)
> (set empty-set (ordsets:new))
()
> (ordsets:is_subset set-b set-a)
true
> (ordsets:is_subset set-a set-b)
false
> (ordsets:is_subset set-c set-a)
false
```

And for those who aren't as familiar with set theory, a few quick facts about sets. First, the empty set is a subset of all sets; second, a set is considered a sub-set of itself; and lastly, a given Set B is a superset of Set A, if Set A is subset of Set B.

```lisp
> (ordsets:is_subset empty-set set-a)
true
> (ordsets:is_subset empty-set set-b)
true
> (ordsets:is_subset empty-set set-c)
true
> (ordsets:is_subset empty-set empty-set)
true
> (ordsets:is_subset set-a set-a)        
true
```

Observant readers may have have noticed that there are actually two different set modules in the Erlang/LFE libraries, [ordsets](http://erlang.org/doc/man/ordsets.html) and [sets](http://erlang.org/doc/man/sets.html). These two modules have exactly the same interface but different internal implementations, ``ordsets`` uses an ordered list while ``sets`` uses a hash-table.

Using ``sets`` the first example group becomes:

```lisp
> (set set-a (sets:from_list (lists:seq 1 10)))   
#(set 10 16 16 8 80 48
  #(() () () () () () () () () () () () () () () ())
  #(#(() (3) (6) "\t" () () (2) (5) "\b" () () (1) (4) (7) "\n" ())))
> (set set-b (sets:from_list (lists:seq 2 10 2)))
#(set 5 16 16 8 80 48
  #(() () () () () () () () () () () () () () () ())
  #(#(() () (6) () () () (2) () "\b" () () () (4) () "\n" ())))
> (set set-c (sets:from_list (lists:seq 1 15 3)))
#(set 5 16 16 8 80 48
  #(() () () () () () () () () () () () () () () ())
  #(#(() () () () () () () () () () () (1) (4) (7) "\n" "\r")))
> (set empty-set (sets:new))                           
#(set 0 16 16 8 80 48
  #(() () () () () () () () () () () () () () () ())
  #(#(() () () () () () () () () () () () () () () ())))
> (sets:is_subset set-b set-a)
true
> (sets:is_subset set-a set-b)
false
> (sets:is_subset set-c set-a)
false
```

While ``sets`` is more efficient for large sets, greater than say 20 elements, the internal form is definitely harder to interpret.

-Proctor, Robert
