---
layout: post
title: "LFE Friday - timer:tc/3"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday is on [timer:tc/3](http://www.erlang.org/doc/man/timer.html#tc-3).

I am sure we have all written some timing code where we capture the current time, do something, capture the current time again and then find the difference to find out how long something took to execute. In Erlang, that generally looks something like the following:


```cl
> (set time1 (now))
#(1420 910649 803027)
> (timer:sleep 4000)    ;Do something
ok
> (set time2 (now))
#(1420 910653 804244)
> (timer:now_diff time2 time1)                                             
4001217
```

Note that we have to use [timer:now_diff/2](http://www.erlang.org/doc/man/timer.html#now_diff-2), since the ``now/0`` function returns the timestamp as a tuple, and we can’t just do normal subtraction on that tuple like we might be able to in other languages.

Of course as good "engineers", we know that since we need to do timings in various places of the app we can just create our own function to do that, and have that live in just one place.

The downside is: the wise people on the Erlang language team have done that for us already and provided it in the form of ``timer:tc/3``.

``timer:tc/3`` takes the module name, function name, and a list of the arguments to be passed to the function. And since we usually want the result of the function we are calling, in addition to the timing, the return value is a tuple of the time in microseconds, and the result of applying the function passed to ``timer:tc/3``.

```cl
> (timer:tc 'timer 'sleep '(4000))
#(4000480 ok)
> (timer:tc 'lists 'foldl (list (lambda (x accum) (+ x accum)) 0 (lists:seq 1 2000000)))
#(3533603 2000001000000)
```

There is also ``timer:tc/1`` which takes just a function and applies it, and ``timer:tc/2`` which takes a function and applies it with the given arguments.

```cl
> (timer:tc (lambda () (lists:foldl (lambda (x accum) (+ x accum)) 0 (lists:seq 1 2000000))))       
#(3693260 2000001000000)
> (timer:tc #'lists:foldl/3 (list (lambda (x accum) (+ x accum)) 0 (lists:seq 1 2000000)))
#(3529578 2000001000000)
```

–Proctor, Robert
