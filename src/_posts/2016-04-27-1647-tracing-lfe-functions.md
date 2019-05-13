---
layout: post
title: "Tracing LFE Functions"
description: ""
category: tutorials
tags: [howto, libraries, tools, utilities, tracing, debugging]
author: Eric Bailey
---
{% include JB/setup %}
What follows is an LFE translation of Roberto Aloi's
[*Tracing Erlang Functions*][OP], originally posted to [my blog][blorg].

[OP]: https://aloiroberto.wordpress.com/2009/02/23/tracing-erlang-functions/
[blorg]: http://blorg.ericb.me/2016/04/tracing-lfe-functions

Tracing LFE functions for debugging purposes is quite simple.

Let's say you have the following module and want to trace one of its functions.

```lisp
(defmodule maths
  (export (sum 2) (diff 2)))

(defun sum (a b) (+ a b))

(defun diff (a b) (- a b))
```

Before we get started, make sure you compile the `maths` module:

```lisp
> (c "/path/to/maths.lfe")
(#(module maths))
```

Just start the tracer:

```lisp
> (dbg:tracer)
#(ok <0.37.0>)
```

Tell the tracer you are interested in all calls for all processes:

```lisp
> (dbg:p 'all 'c)
#(ok (#(matched nonode@nohost 26)))
```

Finally, tell it you want to trace the function, `sum`, from the `maths` module:

```lisp
> (dbg:tpl 'maths 'sum [])
#(ok (#(matched nonode@nohost 1)))
```

Now, try to call the function, as usual. The tracer is active!

```lisp
> (maths:sum 2 3)
5
(<0.29.0>) call maths:sum(2,3)
```

To trace all functions from the `maths` module:

```lisp
> (dbg:tpl 'maths [])
#(ok (#(matched nonode@nohost 6)))
```

To trace the return value for a given function:

```lisp
> (dbg:tpl 'maths 'sum (match-spec ([_] (return_trace))))
#(ok (#(matched nonode@nohost 1) #(saved 1)))
```

```lisp
> (maths:sum 19 23)
42
(<0.47.0>) call maths:sum(19,23)
(<0.47.0>) returned from maths:sum/2 -> 42
```

To stop the trace:

```lisp
> (dbg:stop)
ok
```
