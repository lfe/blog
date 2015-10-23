---
layout: post
title: "LFE Friday - digraph:add_edge/4"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is on [digraph:add_edge/4](http://www.erlang.org/doc/man/digraph.html#add_edge-4).

``digraph:add_edge/4`` takes a graph as its first argument, the originating ([eminating](http://www.erlang.org/doc/man/digraph.html#emanate)) vertex as its second argument, the destination ([incident](http://www.erlang.org/doc/man/digraph.html#incident)) vertex as its third argument, and a label.

```lisp
> (set graph (digraph:new))
#(digraph 8207 12304 16401 true)
> (set vertex-1 (digraph:add_vertex graph 'foo))
foo
> (set vertex-2 (digraph:add_vertex graph 'bar))
bar
> (set edge-1 (digraph:add_edge graph vertex-1 vertex-2 #(foo bar)))
($e . 0)
> (digraph:edges graph)
(($e . 0))
> (set edge-2 (digraph:add_edge graph vertex-2 vertex-1 #(bar foo)))
($e . 1)
> (digraph:edges graph)                                             
(($e . 1) ($e . 0))
```

The ``digraph`` module also contains ``digraph:add_edge/3`` which allows you to not specify a label.

```lisp
> (digraph:add_edge graph vertex-2 vertex-1)
($e . 2)
> (digraph:add_edge graph vertex-1 vertex-2)
($e . 3)
> (digraph:edges graph)                     
(($e . 1) ($e . 3) ($e . 0) ($e . 2))
```

The ``digraph`` module also contains ``digraph:add_edge/5`` which allows you to specify the edge identifier, in this case we want the edge to be ``my-edge``, as well as the label.

```lisp
> (digraph:add_edge graph 'my-edge vertex-1 vertex-2 'my-label)
my-edge
> (digraph:edges graph)                                        
(($e . 1) ($e . 3) my-edge ($e . 0) ($e . 2))
```

And if you note in the examples for ``digraph:add_edge/3`` and ``digraph:add_edge/5`` we added a number of edges with the same eminate and incident vertices, and it was happy to create those edges for us.

We can also create acyclic digraphs by using ``digraph:new/1``, and specifying that we want the ``digraph()`` to be ``acyclic``.

```lisp
> (set graph-2 (digraph:new '(acyclic)))
#(digraph 20498 24595 28692 false)
> (set vertex-a (digraph:add_vertex graph-2 'foo))
foo
> (set vertex-b (digraph:add_vertex graph-2 'bar))
bar
> (set edge-ab (digraph:add_edge graph-2 vertex-a vertex-b #(foo bar)))
($e . 0)
> (set edge-ba (digraph:add_edge graph-2 vertex-b vertex-a #(bar foo)))
#(error #(bad_edge (foo bar)))
```

When we try to add an edge that will create a cycle in an acyclic directed graph, we get a return of a ``bad_edge`` error with the two edges specified.

\- Proctor, Robert
