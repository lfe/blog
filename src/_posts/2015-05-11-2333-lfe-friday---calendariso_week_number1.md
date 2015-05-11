---
layout: post
title: "LFE Friday - calendar:iso_week_number/1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday[^1] is on [calendar:iso_week_number/1](http://www.erlang.org/doc/man/calendar.html#iso_week_number-1)

``calendar:iso_week_number/1`` takes a date tuple as an argument, and returns a tuple of the year and week number.  The year is the year passed as the date tuple, and the week number is an integer between 1 and 53.

```lisp
> (calendar:iso_week_number #(2015 05 11))
#(2015 20)
> (calendar:iso_week_number #(2015 05 10))
#(2015 19)
```

If we use this week as an example, we can see that a week starts on Monday (the 11th of May), where the Sunday before (10th of May) was the previous week.

We see that January 1st falls on the first week of the year, no surprise there, and that the 31st of December for 2015, is on the 53rd week of the year.

```lisp
> (calendar:iso_week_number #(2015 01 01))
#(2015 1)
> (calendar:iso_week_number #(2015 12 31))
#(2015 53)
```

Having a 53rd week of the year sounds surprising at first, because everyone talks about 52 weeks in a year, until you realize that sometimes December 31st sometimes falls at the very beginning of a week, causing it to be the 53rd week, since it is only a partial week.

-Proctor, Robert

[^1]: Slightly late again, this time because of work on my parser generator. See the previous blog posting.
