---
layout: post
title: "Lisp Machine Flavors for LFE (2)"
description: ""
category: tutorials
tags: [lisp machine,flavors]
author: Robert Virding
---
{% include JB/setup %}
<a href="{{ site.base_url }}/assets/images/posts/lm_logo.png"><img class="right tiny" src="{{ site.base_url }}/assets/images/posts/lm_logo.png" /></a>Work on an LFE Flavors implementation had progressed and there is now something to test here [LFE Flavors](https://github.com/rvirding/flavors).

LFE Flavors is not a direct copy of LM Flavors as this is practically impossible given the differences in the underlying machines, for example LFE doesn't have mutable data. Some of its features:

* It uses processes to implement instances. This of course makes it
  fit very well in to the LFE/Erlang way of building systems.

* Each flavor definition becomes a separate module containing its core
  properties. When a flavor is first instantiated then a new module is
  made combining all the component flavors. This allows the component
  flavors to be pre-compiled and loaded in any order.

* A selection of all the LM Flavors options have been implemented with
  some of most usable features like before and after daemons. More
  will be added when necessary.

Now we just need to test this and see if it useful both in its own
right and as a tool to build other tools.

A link to the [LM documentation](http://www.bitsavers.org/pdf/mit/cadr/chinual_6thEd_Jan84/) and some other interesting links [CADR lisp machine](http://www.unlambda.com/cadr/index.html) and [Lisp machines](http://c2.com/cgi/wiki?LispMachine)

Robert

P.S. Defstruct is still calling me and I think it should be possible to make a nice implementation of defstruct which can handle both Erlang records and Elixir structs plus other combinations.
