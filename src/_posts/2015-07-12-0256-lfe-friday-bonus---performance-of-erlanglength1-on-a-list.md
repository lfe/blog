---
layout: post
title: "LFE Friday Bonus - Performance of erlang:length/1 on a list"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

A bonus LFE Friday for everyone.

Giving the Dallas/Fort Worth Erlang User group presentation last week, there were a couple of people new to Erlang make it to our meeting, and the question was raised:

<blockquote>Do lists have any smarts around knowing their length, or does it have to run through all the items to calculate the length?</blockquote>

I was 99% sure that Erlang has to run through the list every time, since it uses linked lists style data structures for it's list, but wasn't sure if there might be something smart in the implementation that I wasn't aware of to speed up that functionality.

In putting together the regularly scheduled [LFE Friday](http://blog.lfe.io/tags.html#lfe%20friday-ref) post for today, I realized I should have busted out ``timer:tc`` to demonstrate the behavior of ``erlang:length/1`` by showing how long it takes to get the length of different lists.

So in honor of that question, and as a reminder to review it at the next user group meeting, I am documenting the behavior here. And remember, that the first item in the result tuple is the time in microseconds the operation took.

```lisp
> (timer:tc 'erlang 'length (list (lists:seq 1 10)))
#(1 10)
> (timer:tc 'erlang 'length (list (lists:seq 1 1000)))
#(4 1000)
> (timer:tc 'erlang 'length (list (lists:seq 1 10000)))
#(47 10000)
> (timer:tc 'erlang 'length (list (lists:seq 1 100000)))
#(309 100000)
> (timer:tc 'erlang 'length (list (lists:seq 1 1000000)))
#(2750 1000000)
> (timer:tc 'erlang 'length (list (lists:seq 1 10000000)))
#(28235 10000000)
> (timer:tc 'erlang 'length (list (lists:seq 1 100000000)))
#(287389 100000000)
```

After about 1000 items in a linked list, we start growing linearly in the time it takes to count the items, so if it is not doing an actual traversal of all the items, it has the same scale of doing so as far as the order of operations (Big-O) goes.

I can confirm that lists don't have any smarts about their length and that ``erlang:length/1`` actually does traverse the whole list. Trying to be smart about the length would slow down adding new elements to the front of the list, and there are no requirements or checks that the tail of a list is a list. It can be anything:

```lisp
> (cons 'a '(b c))
(a b c)
> (cons 'a 'b)
(a . b)
```

-Robert
