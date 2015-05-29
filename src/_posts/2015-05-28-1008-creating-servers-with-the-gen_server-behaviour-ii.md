---
layout: post
title: "Creating LFE Servers with OTP, Part II"
description: "Taking the LFE gen_server to the next level"
category: tutorials
tags: [otp,erlang]
author: Duncan McGreggor
---
{% include JB/setup %}
<a href="/assets/images/posts/LFE-signal.jpg"><img class="right thumb" src="/assets/images/posts/LFE-signal.jpg" /></a>As mentioned in the previous
post, one of the most common patterns that was identified in Erlang was the
need to create a generic, long running process. This pattern has been codified
in the gen_server behaviour, and it is now time that we got our hands dirty by
creating a few :-)


## LFE OTP Tutorial Series

* [Introducing the LFE OTP Tutorials](/tutorials/2015/05/23/1720-new-series-lfe-otp-tutorials/)
* [What is OTP?](/tutorials/2015/05/24/1808-what-is-otp/)
* [Prelude to OTP](/tutorials/2015/05/25/0929-prelude-to-otp/)
* [Creating LFE Servers with OTP, Part I](/tutorials/2015/05/26/1112-creating-servers-with-the-gen_server-behaviour/)
* [Creating LFE Servers with OTP, Part II](/tutorials/2015/05/28/1008-creating-servers-with-the-gen_server-behaviour-ii/)

You can leave feedback for the LFE OTP tutorials
[here](https://github.com/lfe/blog/issues/7).


## In This Post

* Requirements, Assumptions, and Code
* ``gen_server`` Recap and Preview
* How We're Going to Do This
* Unified Code
* Stopping a ``gen_server``
* Best Practices
* Full Source Code
* Learning More About ``gen_server``
* Up Next


## Requirements, Assumptions, and Code

Before reading this tutorial, be sure you should have read the ones preceding
it in this series. For a list of what you need to have installed before working
through the examples as well as getting the source code for these tutorials,
please see the post [Prelude to OTP](/tutorials/2015-05-25-0929-prelude-to-otp/).


## ``gen_server`` Recap

In the last post, we went on a whirlwind tour of ``gen_server``'s basic
functionality:

* We created a callback module which embodied our logic.
* We created a server module that was responsible for setting up the loop.
* We added an API to wrap ``gen_server:cast`` and ``gen_server:call``
  functions that passed messages to our callback logic.


## How We're Going to Do This

In this post we're going to follow up on that work with the following:

* Combine the callback and server module into one.
* Add support for stopping the server.
* Improve the support for handling unexpected messages.
* Stub out the remaining ``gen_server`` functions (full implementation of these
  will come in a later post.
* Fix our exports


## Unified Code



## Stopping a ``gen_server``


XXX adding the ability to stop our server. We'll
start with the new API function:

```lisp
(defun stop ()
  (gen_server:call (server-name) 'stop))
```

That’s the easy bit. Now let’s add support for this new ``stop`` message to our
``handle_call`` callback function:

```lisp
(defun handle_call
  (('amount _caller state-data)
    `#(reply ,state-data ,state-data))
  (('stop _caller state-data)
    `#(stop shutdown ok state-data))
  ((message _caller state-data)
    `#(reply ,(unknown-command) ,state-data)))
```

If we now try to run our server with just this change to the callback, we’d get
an error after calling our new ``(tut01:stop)`` API function that would look
something like this:

```erlang
=ERROR REPORT==== 25-May-2015::19:27:16 ===
** Generic server tut01 terminating
** Last message in was stop
** When Server state == 'state-data'
** Reason for termination ==
** {'function not exported',
       [{'tut01-callback',terminate,...},
        {gen_server,try_terminate,...},
        {gen_server,terminate,7,...},
        {gen_server,handle_msg,5,...},
        {proc_lib,init_p_do_apply,3,...}]}
```

You will see that error message when you haven’t defined the ``terminate``
callback function. Here’s a quick one:

```lisp
(defun terminate (_reason _state-data)
  'ok)
```

Now when we stop our server using our new API, we have success:

```lisp
> (tut01:start)
#(ok <0.35.0>)
> (tut01:stop)
ok
```

And we can demonstrate that it’s really stopped by trying to call our
``amount?`` API function:

```lisp
> (tut01:amount?)
exception exit: #(noproc #(gen_server call (tut01 amount)))
  in gen_server:call/2 (gen_server.erl, line 182)
```


## Best Practices


## Full Source Code

XXX:

```lisp

```


## Learning More About ``gen_server``

There’s a lot of information we didn’t cover in this tutorial, however it’s
enough to get started writing simple OTP servers in LFE. If you’d like to learn
more, one of the newest books out there on the topic has been recently
published by O’Reilly:
[Designing for Scalability with Erlang/OTP](http://shop.oreilly.com/product/0636920024149.do).
The chapter on ``gen_server`` covers this material in much more detail,
including timeouts, deadlocks, hibernating, and custom global registries.

Another good resource, once you get up to speed, is the
[Erlang documentation](http://www.erlang.org/doc/man/gen_server.html) (and
[here](http://www.erlang.org/doc/design_principles/gen_server_concepts.html)).
Often overlooked, it's actually really good and will be a constant companion
for you any time you need to do something with OTP that you haven't tried
before.

In future posts in this series, we will be covering bits we've left out of this
tutorial, namely:

* ``code_change`` - supporting hot-loading of code in a running system
* ``format_status`` - providing custom status data for a running server


## Up Next

Before we tackle any other behaviours, we’re going to explore distributed
generic servers: running our code on multiple cores and multiple machines.

----

### Footnotes

