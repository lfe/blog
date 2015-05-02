---
layout: post
title: "LFE Friday - calendar:is_leap_year/1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is on [calendar:is_leap_year/1](http://www.erlang.org/doc/man/calendar.html#is_leap_year-1).

``calendar:is_leap_year/1`` takes a non-negative integer value representing a year, and will return ``true`` if that year is a leap year, or ``false`` otherwise.

```lisp
> (calendar:is_leap_year 2015)
false
> (calendar:is_leap_year 2012)
true
> (calendar:is_leap_year 2017)
false
> (calendar:is_leap_year 2000)
true
> (calendar:is_leap_year 1900)
false
> (calendar:is_leap_year 0)   
true
```

By having a built in function as part of the core Erlang libraries, it means you don't have to code up the rules, or even go lookup the rules to remember how the century years are determined to be leap years or not.

And if you do pass in a negative number for the year, Erlang will raise an exception, as there are no clauses which match a negative number for the year.

```lisp
> (calendar:is_leap_year -1)
exception error: function_clause
  in (: calendar is_leap_year -1)
> (calendar:is_leap_year -4)
exception error: function_clause
  in (: calendar is_leap_year -4)
```

-Proctor, Robert
