---
layout: post
title: "LFE Friday - ETS Introduction, part 1"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday starts the beginning of an intro to the [ets](http://www.erlang.org/doc/man/ets.html) module, and ETS in general.

ETS stands for Erlang Term Storage, and is a in-memory store for Erlang/LFE terms, a.k.a pieces of an Erlang/LFE data type, that provides constant access time to the data stored.

ETS can be thought of as a key/value store style storage, and it uses the concept of tables as the way of grouping together data.

One of the first things that is useful to know is that ETS tables are created by a process which, unless transferred to another process, is the owner of the table.

When the owner dies, the table gets deleted, and is no longer accessible.

Let's see what this would look like.

First, after starting a new LFE shell, we will check the PID (process identifier) of the shell we are in.

```lisp
> (self)
<0.28.0>
```

We then will create a new ETS table.  We will be going into future details about the various ways new tables can be created in future posts, so for now, we will just create a new table by only specifying a name and empty list of options.

```lisp
> (set table-id (ets:new 'table ()))
8207
```

Capturing table id, we will take a look at the info that ETS knows about that table with ``ets:info/1``.

```lisp
> (ets:info table-id)
(#(read_concurrency false)
 #(write_concurrency false)
 #(compressed false)
 #(memory 305)
 #(owner <0.28.0>)
 #(heir none)
 #(name table)
 #(size 0)
 #(node nonode@nohost)
 #(named_table false)
 #(type set)
 #(keypos 1)
 #(protection protected))
```

We see in the table info that the shell process, ``<0.28.0>``, is the "owner" of the table. Time to cause the owning process to crash.  In this case we'll do a bad pattern match to cause a bad match exception.

```lisp
> (set 1 2)
exception error: #(badmatch 2)
```

And let's check the PID of the process to double check that the shell has indeed started a new process for us to run in.

```lisp
> (self)
<0.38.0>
```

And yes, the PID ``(self)`` returned is different than the PID we got when we called ``(self)`` the first time.

Time to look at the info for the table we created earlier again and see what we get.

```lisp
> (ets:info table-id)
undefined
```

``undefined``.  So we no longer have any table found by ETS for that table id.

We take a secondary look using ``ets:all/0`` to see if we can see if it might be floating around somewhere still but the call to ``ets:info/1`` is just not returning for the table id.

```lisp
> (ets:all)
(file_io_servers inet_hosts_file_byaddr inet_hosts_file_byname
 inet_hosts_byaddr inet_hosts_byname inet_cache inet_db
 global_pid_ids global_pid_names global_names_ext global_names
 global_locks 4098 1 ac_tab)
```

Doesn't look like it, so let's create another table with the same table name as before.

```lisp
> (set table-id-2 (ets:new 'table ()))
12303
```

That succeeds and doesn't complain about trying to create a table with the same name as an existing table.

We will call ``ets:all/0`` again, and we can see there is an item in the list with the id that was returned from ``ets:new/2``.

```lisp
> (ets:all)                           
(12303 file_io_servers inet_hosts_file_byaddr inet_hosts_file_byname
 inet_hosts_byaddr inet_hosts_byname inet_cache inet_db
 global_pid_ids global_pid_names global_names_ext global_names
 global_locks 4098 1 ac_tab)
```

Time to crash the process again.

```lisp
> (set 1 2)                           
exception error: #(badmatch 2)
```

We note that we do have a new PID again.

```lisp
> (self)                              
<0.45.0>
```

And if we call ``ets:all/0`` one more time, we can see that the table identifier that was previously in the list has gone away.

```lisp
> (ets:all)
(file_io_servers inet_hosts_file_byaddr inet_hosts_file_byname
 inet_hosts_byaddr inet_hosts_byname inet_cache inet_db
 global_pid_ids global_pid_names global_names_ext global_names
 global_locks 4098 1 ac_tab)
```

So with this initial look at ETS, we have demonstrated an owning process crash does remove the table, and we have also gotten an preview of a couple of the functions in the ``ets`` module, specifically ``ets:new/2``, ``ets:info/1``, and ``ets:all/0``.

We will continue looking at the overview of ETS for a few posts, while doing some cursory coverage of some of the functions in the ``ets`` module, and after that, we will then start to get into the specifics of the different functions in the ``ets`` module.

\- Proctor, Robert
