---
layout: post
title: "LFE Friday - calendar:valid_date/3"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is [calendar:valid_date/3](http://www.erlang.org/doc/man/calendar.html#valid_date-3).

Originally, I was thinking it was going to be ``calendar:time_difference/3``, but then I looked into the Erlang documentation for the [calendar module](http://www.erlang.org/doc/man/calendar.html) and saw that it was marked as obsolete, so today I present ``calendar:valid_date/3``.

The arguments to ``calendar:valid_date/3`` are an integer for the year, integer for the month, and an integer for the day.  ``calendar:valid_date/3`` returns the atom ``true`` if the day passed in is a valid date, and the atom ``false`` if it is not a valid date.

```lisp
> (calendar:valid_date 2015 04 31)
false
> (calendar:valid_date 2015 04 30)
true
> (calendar:valid_date 2015 02 29)
false
> (calendar:valid_date 2012 02 29)
true
> (calendar:valid_date 2015 11 31)
false
> (calendar:valid_date 2015 11 76)
false
> (calendar:valid_date 2015 17 13)
false
```

Just a quick check for our sanity that the day this post was published is a valid date as well.

```lisp
> (calendar:valid_date 2015 04 24)
true
```

Now let's try to break this a bit and test to see how it can handle `0`'s and negative integer values.

```lisp
> (calendar:valid_date -1 04 24)  
false
> (calendar:valid_date 2015 -7 21)
false
> (calendar:valid_date 2015 7 -13)
false
> (calendar:valid_date 0 0 0)     
false
```

As one might hope, unless you deal with B.C. era dates often, a date with a negative value is not a valid date.

Erlang also provides a ``calendar:valid_date/1`` that takes a tuple of the year, month, and day values as well.

```lisp
> (calendar:valid_date #(2015 11 76))
false
> (calendar:valid_date #(2015 04 24))
true
```

-Proctor, Robert
