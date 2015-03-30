---
layout: post
title: "LFE Friday - ordsets:is_disjoint/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday covers [ordsets:is_disjoint/2](http://www.erlang.org/doc/man/ordsets.html#is_disjoint-2).

There are times in your in your coding day where you have problems where you need to know if given a list of items that none of those items appear in a secondary list.

Your first intuition might be to write out the code as described, like such:

```cl
> (not (lists:any (lambda (item) (lists:member item '(1 3 5 7))) '(2 4 6)))
true
```

And while that is accurate, if you redefine your problem in more mathematical terms, you can start to think in sets.  When you start to think in terms of sets, you realize that you can check to see if the intersection of the two sets is the empty set.

```cl
> (=:= (ordsets:intersection '(1 3 5 7) '(2 4 6)) ())
true
```

This is becoming not only more concise, but also more explicit about what you are trying to check.

We can do better still, by checking if the lists are disjoint sets.  Enter ``ordsets:is_disjoint/2``.

``ordsets:is_disjoint/2`` takes two lists, and returns ``true`` if no elements are in common.

```cl
> (ordsets:is_disjoint '(1 3 5 7) '(2 4 6))
true
> (ordsets:is_disjoint '(1 2 3 5 7) '(2 4 6))
false
```

Because ``ordsets:is_disjoint/2`` operates against two lists, we do not have to make sure the elements are unique prior to calling ``ordsets:is_disjoint/2``.

```cl
> (ordsets:is_disjoint '(1 1 3 5 7 5 3) '(2 4 2 2 6))
true
> (ordsets:is_disjoint '(1 2 3 5 7) '(2 4 2 2 6))
false
```

And if either list passed to ``ordsets:is_disjoint/2`` is an empty list, the result is that the lists are disjoint.

```cl
> (ordsets:is_disjoint '(1 2 3 5 7) '())         
true
> (ordsets:is_disjoint '() '(2 4 6))                 
true
> (ordsets:is_disjoint '() '())     
true
```

And if you are curious, by running ``ordsets:is_disjoint/2`` through ``timer:tc/3``, we can see that as soon as Erlang knows that the sets are not disjoint, it returns ``false``.  And if you remember from the previous [LFE Friday on timer:tc/3](http://blog.lfe.io/tutorials/2015/01/10/2201-lfe-friday---timertc3/), the return value is a tuple with the first element being the number of *micro*seconds it took to complete.

```cl
> (timer:tc 'ordsets 'is_disjoint (list (lists:seq 1 1000000) (lists:seq 2000000 3000000)))         
#(13627 true)
> (timer:tc 'ordsets 'is_disjoint (list (lists:seq 1 1000000) (lists:seq 1 3000000)))      
#(1 false)
```

-Proctor, Robert
