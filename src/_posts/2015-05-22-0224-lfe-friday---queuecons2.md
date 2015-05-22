---
layout: post
title: "LFE Friday - queue:cons/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday digs a little into the ``queue`` module, and we cover [queue:cons/2](http://www.erlang.org/doc/man/queue.html#cons-2) from the Okasaki API.

``queue:cons/2`` takes a item and a queue, and will return a new queue with the item at the head of the queue.

```lisp
> (queue:cons 7 (queue:new))
#(() (7))
> (queue:cons 3 (queue:cons 7 (queue:new)))
#((7) (3))
> (queue:cons 'nil (queue:new))
#(() (nil))
> (queue:cons 5 (queue:from_list '(7 9 13 21)))
#((21) (5 7 9 13))
```

If we try to pass a list in to ``queue:cons/2``, we see that it does want a queue, and will not do an implicit conversion of a list to a queue.

```lisp
> (queue:cons 5 '(1 2 3 4))                    
exception error: badarg
  in (: queue in_r 5 (1 2 3 4))

```

As the queue is setup to be a double ended queue, the Okasaki API also provides a counter function [queue:snoc/2](http://www.erlang.org/doc/man/queue.html#snoc-2), that adds an item to the tail of the queue passed in.  Note that the argument order is swapped between ``queue:snoc/2`` and ``queue:cons/2``; ``queue:snoc/2`` takes the queue as the first argument, and the item to add at the tail as the second argument.

```lisp
> (queue:snoc (queue:new) 5)
#((5) ())
> (queue:snoc (queue:from_list '(7)) 5)
#((5) (7))
> (queue:snoc (queue:snoc (queue:new) 7) 5)
#((5) (7))
> (queue:snoc (queue:from_list '(7 9 13 21)) 5)
#((5 21) (7 9 13))
```

-Proctor, Robert
