---
layout: post
title: "LFE Friday - queue:peek/1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

For today's LFE Friday we continue looking at the ``queue`` module and look at [queue:peek/1](http://erlang.org/doc/man/queue.html#peek-1) from the Extended API.

``queue:peek/1`` takes a queue as it's argument and returns either the atom ``empty`` if the queue is empty, or ``#(value item)`` where ``item`` is the item at the head of the queue.

```lisp
> (set queue-one (queue:from_list '(1 2 3 4 5)))
#((5 4) (1 2 3))
> (queue:peek queue-one)
#(value 1)
> (set empty-queue (queue:new))
#(() ())
> (queue:peek empty-queue)     
empty
```

``queue:peek/1`` does not modify the existing queue at all either, so we can call it once as seen above, or multiple times as below, and the queue we peeked at doesn't change.

```lisp
> (set queue-two (queue:from_list '(a b c d e f)))
#((f e) (a b c d))
> (queue:peek queue-two)
#(value a)
> (queue:peek queue-two)
#(value a)
> (queue:peek queue-two)
#(value a)
> queue-two
#((f e) (a b c d))
```

And unlike we saw in the previous [LFE Friday on queue:head/1](http://blog.lfe.io/tutorials/2015/05/29/0345-lfe-friday---queuehead1/), we can safely peek at an empty queue instead of getting an exception.

```lisp
> (queue:head empty-queue)
exception error: empty
  in (: queue head #(() ()))

> (queue:peek empty-queue)
empty
```

Erlang's ``queue`` module also contains [queue:peek_r/1](http://erlang.org/doc/man/queue.html#peek_r-1) which will peek at the element at the rear of the queue.

```lisp
> (queue:peek_r empty-queue)                      
empty
> (queue:peek_r queue-one)      
#(value 5)
> (queue:peek_r queue-one)
#(value 5)
> (queue:peek_r queue-one)
#(value 5)
> (queue:peek_r queue-two)
#(value f)
> queue-two               
#((f e) (a b c d))
> queue-one
#((5 4) (1 2 3))
> empty-queue
#(() ())
```

-Proctor, Robert
