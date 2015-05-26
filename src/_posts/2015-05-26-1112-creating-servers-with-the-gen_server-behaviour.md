---
layout: post
title: "LFE OTP: Creating Servers with the gen_server Behaviour"
description: "Creating a generic OTP server in LFE"
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
* [Creating Servers with the gen_server Behaviour](/tutorials/2015/05/26/1112-creating-servers-with-the-gen_server-behaviour/)

You can leave feedback for the LFE OTP tutorials
[here](https://github.com/lfe/blog/issues/7).

## In This Post

* Requirements, Assumptions, and Code
* Introductory Notes on ``gen_server``
* Creating a Callback Module
* Creating a Server Module
* Creating An API
* Updating An API
* Full Source Code
* Learning More About gen_server
* Up Next
* Footnotes

## Requirements, Assumptions, and Code

Before reading this tutorial, be sure you should have read the ones preceding
it in this series. For a list of what you need to have installed before working
through the examples as well as getting the source code for these tutorials,
please see the post [Prelude to OTP](/tutorials/2015-05-25-0929-prelude-to-otp/).

## Introductory Notes on gen_server

The ``gen_server`` behaviour defines a contract between the programmer and the
world of OTP, expecting you to do the following:

* Define a module which implements ``gen_server`` functions
* Define a callback module which implements the required message-passing (and
  callback-related) functions

If you have ever looked at Erlang code for ``gen_server``s, you will have
noticed that setting up a ``gen_server`` involves some boilerplate Erlang data
structures.  This sort of setup is a common idiom in Erlang, however, the
approach is a bit atypical for a Lisp. It’s more common to see keyword
arguments (a la ``&key``) or even property lists in Common Lisp. In Clojure,
hash maps are used to the same effect.

When creating new functions in LFE, you have the option of providing a better
developer experience by simulating keyword arguments using such things as the
new map data type, property lists, or records. Since we are using functions
which already exist in OTP, we don't have that option (unless we create
wrappers or define an OTP DSL ... but that's out of scope for this series!).
Instead, we’ll simply take extra measures for clarity, defining variables with
names that give strong hints as to how they will be used by the ``gen_server``
code.

Furthermore, it is a very common practice in Erlang for developers to implement
a behaviour module and a callback module in the same file. This has a tendency
to confuse newcomers, so we have opted for an explicit separation of the two in
order to make the delineation of responsibilities as clear as possible.

That said, we're ready for some code!

## Creating a Callback Module

If we want to port our previous closure or process example servers to use OTP,
it might made the most sense to start with the callback module, since this is
where most of the logic lives:

```lisp
(defun handle_cast
  (('add state-data)
    `#(noreply ,(+ 1 state-data))))

(defun handle_call
  (('amount _caller state-data)
    `#(reply ,state-data ,state-data))
  ((message _caller state-data)
    `#(reply ,(unknown-command) ,state-data)))
```

If we compare this to the process server from the previous post, we can see
that things have started to change rather significantly:

```lisp
(defun process-state (caller state-data)
  (receive
    ('add
      (process-state caller (+ 1 state-data)))
    ('amount?
        (! caller state-data)
        (process-state caller state-data))))
```

First of all, our callback module has two functions instead of just one:
``handle_cast`` and ``handle_call``. These functions are not used by developers
or users of the OTP software we write; they are defined in a callback module
for use by our ``gen_server``.

The ``handle_call`` function is used for making synchronous calls, usually
where a result is expected. This is why we return the ``#(reply ...)`` tuple:
we’re letting OTP know that whatever made this call should get the second
element of the tuple sent to it. The third element of the tuple is used
internally by ``gen_server`` as the state data which restarts the loop after
this call (all under the hood and away from view). We did something almost
identical in our process example in the last post. In this simple example, our
return value and our state data are one and the same; in a more complicated
example, one might extract the result from the state data or perform some
operations on the state data. Whatever you did, you would put the result you
wanted to be sent back to the caller in the second element of the tuple.

Note the reply of ``(unknown-command)`` in the catch-all function head pattern
for ``handle_call``. This is used here for demonstration purposes only. In a
later post, we will cover error handling and how to best deal with unexpected
messages in an OTP application. [^handle-info]

The ``handle_cast`` function is used for making asynchronous calls, often
convenient when you want to execute a function and don’t care about returning
data to the caller. This is exactly what we’re using it for: we just want our
state data to get incremented; we don’t want a result. [^delayed-result]

Both functions expect a message (any Erlang term) and the state data for our
``gen_server`` loop. Additionally, the ``handle_call`` function takes a
parameter for the calling function so that it can send results back to it. When
we look at the the API code in our server module, we’ll see where this code
gets called.  First, though, let’s finish looking at our callback module:

The other thing our callback module needs to define is an ``init`` function.
This is used to “prime the pump”, as it were, for the the ``gen_server`` loop.
In other words, this is what initializes the state that gets passed to the
various ``handle_*`` functions. Note that for our example, our state data is
extremely simple: it’s just an integer. But it could be any LFE data structure,
including records (which is very often what the state data is in Erlang and LFE
applications).

## Creating a Server Module

Okay, so we know how our logic gets converted from the non-OTP server loops to
the callback code ... but what calls the callback? If we’re creating a server
in this post then where is the server code? Thanks to OTP (which takes care of
so many of the details), our server code is very simple:

```lisp
(defun start ()
  (gen_server:start (register-name)
                    (callback-module)
                    (initial-state)
                    (genserver-opts)))
```

As promised above, instead of archane data structures, we have very clearly
defined the variables which are being used as the ``gen_server:start``
arguments:

1. The ``start/4`` function takes a name with which the server will be
  registered. [^start-name] The name is a tuple with the first element being
  either ``local`` or ``global`` and the second being the actual name for the
  process. [^via-name]
1. The second argument is the callback module associated with this server
  (that’s what we created in the previous section ... it’s where all our logic
  lives).
1. In our case, the next argument is the initial state for our server loop, but
   more generally, it is the list of arguments (can be an empty list) that will
   be passed to the ``init`` function in a ``gen_server``'s callback module.
1. Finally, if we want to pass any options to the ``gen_server`` process
   itself, we can do that here. At the beginning of the module where this code
   lives, we've defined ``(genserver-opts)`` to be an empty list, since we
   don’t need to do anything special here. [^genserver-opts]

As you can see, there are a series of functions being called that we haven’t
defined above -- these are all defined in the tutorial server module
``tut01.lfe`` (the full listing of which is at the end of this post). These
hold all the data which is getting passed. [^genserver-args]

## Creating An API

Next, we can look at our API. As you recall from the last post, our “APIs” were
hardly that. They consisted of making ``funcall``s in one case, and in the
other, sending messages to the server process via the ``(! ...)`` form. That
changes now :-)

Whenever you have created an implementation of the ``gen_server`` behaviour and
a callback module for it, the way you execute the callback code is by sending
messages to your server via ``(gen_server:call ...)`` and ``(gen_server:cast
...)``. We will use these to define a nicely usable API for our server:

```lisp
(defun add ()
  (gen_server:cast (server-name) 'add))

(defun amount? ()
  (gen_server:call (server-name) 'amount))
```

You can imagine that for a large server module, there would be a great many API
functions defined here. At this point, the mystery of what calls
our ``handle_cast`` and ``handle_call`` functions in the callback module is
solved :-)

OTP helps us to also keep our API definitions very simple. Essentially we’re
saying “Hey, gen_server!  You know that server we defined called
``(server-name)``? Well, we’d like to send a ``cast`` message to it. Can you do
that please?” OTP then takes care of the rest of it for us, by looking up the
server, finding the callback module that was defined for it, and then calling
the ``handle_cast`` function with the appropriate arguments.

Let’s try it out:

```bash
$ cd ../tut01
$ make repl
```

```lisp
> (tut01:start)
#(ok <0.35.0>)
> (tut01:add)
ok
> (tut01:add)
ok
> (tut01:amount?)
2
> (tut01:add)
ok
> (tut01:amount?)
3
> (gen_server:call (tut01:server-name) 'bingo)
#(error "Unknown command.")
```

How’s *that* for clean! That’s what a good developer experience should look
like :-) None of this crazy you-gotta-make-``funcall``s-and-then-save-state
business.

Let's review what happened above:
We started up our server which initialized the loop with the data we
configured for it in our server module (just the integer ``0`` in our case).
Next, we made some API calls which were passed on to our callback module by the
underlying OTP infrastructure. We got results for our API functions which made
``call``s, and for the ``cast``s we got a simple and reassuring ``ok``.  When
skipping the API functions and making calls directly via ``gen_server:call``,
we got the expected error message for messages which don't match the ones that
have been defined in our callback module.

## Updating An API

What if we needed to make a change to our API? Asked another way, what does one
need to do in order to add new functionality to a server API? Let’s answer this
by looking at a special case: adding the ability to stop our server. We'll
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

This was a special case; most times you will add API functions, there will be
no implicit execution of callback functions (which need to be defined in order
to prevent errors from being generated). Usually all you'll have to do is
define your API function and then implement the logic that will get executed by
the callback module.


## Full Source Code

Though we have this code defined in modules for this post’s tutorial in the
repository, it can be nice to see it on the page in the same context as the
blog post.

Here is the server module:

```lisp
(defmodule tut01
  (behaviour gen_server)
  (export all))

;;; config functions

(defun server-name () (MODULE))
(defun callback-module () 'tut01-callback)
(defun initial-state () 0)
(defun genserver-opts () '())
(defun register-name () `#(local ,(server-name)))

;;; gen_server implementation

(defun start ()
  (gen_server:start (register-name)
                    (callback-module)
                    (initial-state)
                    (genserver-opts)))

;;; our server API

(defun add ()
  (gen_server:cast (server-name) 'add))

(defun amount? ()
  (gen_server:call (server-name) 'amount))

(defun stop ()
  (gen_server:call (server-name) 'stop))
```

And here’s the callback module code:

```lisp
(defmodule tut01-callback
  (export all))

;;; config functions

(defun unknown-command () #(error "Unknown command."))

;;; callback implementation

(defun init (initial-state)
  `#(ok ,initial-state))

(defun handle_cast
  (('add state-data)
    `#(noreply ,(+ 1 state-data))))

(defun handle_call
  (('amount _caller state-data)
    `#(reply ,state-data ,state-data))
  (('stop _caller state-data)
    `#(stop shutdown ok state-data))
  ((message _caller state-data)
    `#(reply ,(unknown-command) ,state-data)))

(defun terminate (_reason _state-data)
  'ok)
```

Note that our callback module doesn’t implement all the callbacks it would need
as part of a full-blown OTP application; we’ll do that in a future post.

## Learning More About gen_server

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

* ``handle_info`` - managing unepxected messages and different error states
* ``code_change`` - supporting hot-loading of code in a running system
* ``format_status`` - providing custom status data for a running server


## Up Next

Before we tackle any other behaviours, we’re going to explore distributed
generic servers: running our code on multiple cores and multiple machines.

----

### Footnotes

[^handle-info]: If you're curious now and want to do this the right way before
                we get around to creating a blog post for error handling and
                unexpected messages, look info the ``handle_info`` callback
                function for ``gen_server``. A minimal use of ``handle_info``
                to deal with unexpected messages would involve adding three
                pattern-matching function heads: 1) match for a normal exit
                and return your state data as ``noreply``, 2) match for any
                other type of exit, log the exit reason, and return your state
                data as ``noreply``, and 3) have a catch-all pattern that
                simply returns your state data as ``noreply``.

[^delayed-result]: Another way to do this would be to use ``call`` instead of
                   ``cast`` and in our ``add`` callback function, return
                   ``(gen_server:reply from `#(reply ,state-data)) `#(noreply ,(+ 1 state-data))``
                   This does two things: 1) sends an immediate response back to
                   the caller (which which is the API function ``add`` in this
                   case), satisfying its need for a response from the server,
                   and 2) passes the new state to the next loop of the server.
                   We chose to use the ``cast`` approach not only for
                   simplicity of implementation, but to introduce the async
                   capabilities of a ``gen_server`` implementation.

[^start-name]: In general, this is optional -- you could use ``start/3`` which
               doesn't take a name. In our case, however, we need it so that we
               can easily make calls to the ``gen_server`` process (and for
               that we need to register a name so the process can be looked up;
               if we didn’t do this, we’d need to keep track of the process id
               for our server).

[^via-name]: A third alternative is more rarely used in the cases where one
             need to implement a custom global registry. In that event, you
             create a 3-tuple where the second element is the name of the
             module which implements the registry functions.

[^genserver-opts]: For a list of available options, see the [gen_server:start docs](http://www.erlang.org/doc/man/gen_server.html#start-4).

[^genserver-args]: There is no defined convention in LFE for how one defines
                   module-level configuration variables or where these might
                   go: you can put the data for the argument values anywhere it
                   makes sense to you.  You don't even have to define any --
                   you can just pass the data as-is in the function arguments.
                   However, there is a lot to be said for the readability of
                   the example above :-)
