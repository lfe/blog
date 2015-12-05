---
layout: post
title: "LFE Friday - ETS Introduction, part 2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday continues the introduction to the [ets](http://www.erlang.org/doc/man/ets.html) module, and ETS in general.

We saw last time that ETS tables are destroyed when the parent process crashes, so the question comes, how might we be able to keep our ETS tables alive if we just "Let It Crash!"?

To solve this problem, we will take a look at the function ``ets:give_away/3`` and the option of specifying the ``heir`` at table construction.

First, we will create a function that will represent a process we can give the table ownership to.  This function just does a receive and never times out.

```lisp
> (set fun (lambda () (receive (after 'infinity 'ok))))
#Fun<lfe_eval.23.88887576>
```

And now with that function, we can spawn a process to run that function.

```lisp
> (set process (spawn fun))
<0.36.0>
```

We create a new ETS Table,

```lisp
> (set table (ets:new 'table ()))
8207
```

and give it away to the process we just spawned.

```lisp
> (ets:give_away table process ())
true
```

We can look at the table info, and see the owner is now the process we spawned as the Pid for the process aligns with the Pid in the ``owner`` tuple in the table settings.

```lisp
> (ets:info table)
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 305)
 #(owner <0.36.0>)
 #(heir none)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

Now that we have supposedly transferred ownership, time to crash our current process, which is the one that was the original owner before the transfer.

```lisp
> (set 1 2)
exception error: #(badmatch 2)

> (self)
<0.41.0>
```

We check if the process we spawned is still alive, mostly out of showing that there is nothing up our sleeves.

```lisp
> (is_process_alive process)
true
```

And let's take a look at the "info" for the table again, and see if it is still available.

```lisp
> (ets:info table)
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 305)
 #(owner <0.36.0>)
 #(heir none)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

It is still alive!!! We did transfer ownership, so if our process crashes the ETS table still stays alive.

Time to kill that process

```lisp
> (exit process "Because")
true
> (is_process_alive process)
false
```

and watch the ETS table disappear...

```lisp
> (ets:info table)
undefined
```

This time, let's use the ``heir`` option when creating an ETS table, and take advantage of the magic of ownership transfer for an ETS table to a heir.

In this case, the shell will be the heir when the owning process dies.

```lisp
> (set table-with-heir (ets:new 'table (list (tuple 'heir (self) "something went wrong"))))
12303
```

We create a new process, and assign ownership of the ETS table to the new process.

```lisp
> (set process-2 (spawn fun))
<0.50.0>
> (ets:give_away table-with-heir process-2 ())
true
```

We then look at the info for the table, and we can see both the owner is the new process, and the heir is our current process.

```lisp
> (self)
<0.41.0>
> (ets:info table-with-heir)
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 349)
 #(owner <0.50.0>)
 #(heir <0.41.0>)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

Time to kill the owning process again...

```lisp
> (exit process-2 "Because")
true
> (is_process_alive process-2)
false
```

And if we inspect the table info again, we can see the current process is now both the owner and the heir.

```lisp
> (ets:info table-with-heir)
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 349)
 #(owner <0.41.0>)
 #(heir <0.41.0>)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

We spawn up a new process, and we give the table to that new process.

```lisp
> (set process-3 (spawn fun))
<0.57.0>
> (ets:give_away table-with-heir process-3 ())
true
```

The owner now becomes that new process, and our current process is still the heir.

```lisp
> (ets:info table-with-heir)                  
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 349)
 #(owner <0.57.0>)
 #(heir <0.41.0>)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

So by taking advantage of the ability to specify a heir, and using ``ets:give_away/3``, we can help keep the ETS table alive.

One way this might be taken advantage of is that we have a supervisor create a "heir" process, and then create the child process that would own the ETS table, and if the child dies, it can then transfer ownership back to the heir process until the new "owning" process can be restarted, and then the heir process can then transfer ownership of the ETS table to the "newly restarted" process.

\- Proctor, Robert
