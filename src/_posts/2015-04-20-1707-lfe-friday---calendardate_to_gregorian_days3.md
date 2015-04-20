---
layout: post
title: "LFE Friday - calendar:date_to_gregorian_days/3"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday covers [calendar:date_to_gregorian_days/3](http://www.erlang.org/doc/man/calendar.html#date_to_gregorian_days-3).

As we saw in last week’s [LFE Friday on calendar:day_of_the_week/3](http://blog.lfe.io/tutorials/2015/04/12/1941-lfe-friday---calendarday_of_the_week3/) when we were looking at some error messages, we saw that the errors were coming from ``calendar:date_to_gregorian_days/3``.

```lisp
> (calendar:day_of_the_week 0 0 0)        
exception error: function_clause
  in (: calendar date_to_gregorian_days 0 0 0)
  in calendar:day_of_the_week/3 (calendar.erl, line 151)
> (calendar:day_of_the_week 1970 2 31)   
exception error: if_clause
  in calendar:date_to_gregorian_days/3 (calendar.erl, line 116)
  in calendar:day_of_the_week/3 (calendar.erl, line 151)
> (calendar:day_of_the_week 1970 13 2)
exception error: function_clause
  in (: calendar last_day_of_the_month1 1970 13)
  in calendar:date_to_gregorian_days/3 (calendar.erl, line 115)
  in calendar:day_of_the_week/3 (calendar.erl, line 151)
```

I promised you at the end of that post we would take a deeper look at ``calendar:date_to_gregorian_days/3`` next time, so let’s fulfill that promise.

``calendar:date_to_gregorian_days/3`` takes three arguments, a non-negative integer for the year, an integer between 1 and 12 (inclusive) for the month, and an integer between 1 and 31 (inclusive) for the day of the month, and returns the number of days since ``0000-01-01`` in the Gregorian calendar.

```lisp
> (calendar:date_to_gregorian_days 2015 4 19)
736072
> (calendar:date_to_gregorian_days 0 1 1)    
0
> (calendar:date_to_gregorian_days 1 1 1)
366
> (calendar:date_to_gregorian_days 1970 1 1)
719528
> (calendar:date_to_gregorian_days 1999 12 31)
730484
```

There is also a version ``calendar:date_to_gregorian_days/1``, that takes a tuple of year, month, and day available if your code already has the date in tuple format.

```lisp
> (calendar:date_to_gregorian_days #(2015 4 19))
736072
> (calendar:date_to_gregorian_days #(0 1 1))    
0
> (calendar:date_to_gregorian_days #(1 1 1))
366
```

And if we pass something invalid to ``calendar:date_to_gregorian_days/1``, we see that it is calling ``calendar:date_to_gregorian_days/3``.  So it is just a nice helper function that does the pattern match destructing for us.

```lisp
> (calendar:date_to_gregorian_days #(1 1 0))
exception error: function_clause
  in (: calendar date_to_gregorian_days 1 1 0)
```

-Proctor, Robert
