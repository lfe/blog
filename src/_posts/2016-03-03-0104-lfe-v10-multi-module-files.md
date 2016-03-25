---
layout: post
title: "Coming in LFE v1.0: multi-module files"
description: ""
category: tutorials
tags: [v1.0]
author: Robert Virding
---
{% include JB/setup %}
<a href="/assets/images/posts/LFE-signal.jpg"><img class="right thumb" src="/assets/images/posts/LFE-signal.jpg" /></a>Finally LFE v1.0 is about to be released. Pretty soon anyway. So here are some new things which are coming. These can all be tested on the develop branch.
<br /><br />

First up is that the handling of multi-module files has now been finalized. So while the latest version of LFE has been able to handling multiple modules in one file it has never really been announced and described. The basics are simple: everything defined *before* the first module is visible in all the modules while that which is defined *inside* a module is only visible in that module.

An example file:

```lisp
;; A demo file.
;; This is before all the modules.

(defmacro before (a)
  `(tuple 'before ,a))

;; Define the first module.

(defmodule 1st-module
  (export (f 1)))

(defmacro inside (a)
  `(tuple 'inside '1st-module ,a))

(defun f (x)
  (list (before x)
        (inside x)))

;; Define the second module.

(defmodule 2nd-module
  (export (f 1)))

(defmacro inside (a)
  `(tuple 'inside '2nd-module ,a))

(defun f (x)
  (list (before x)
        (inside x)))
```

So this simple module contains the definition of the macro ``before`` and then two modules ``1st-module`` and ``2nd-module``. Each module defines the macro ``inside`` and a function ``f/1``. Compiling this module and calling the functions ``f/1`` gives us:

```lisp
> (c 'zip)                 
(#(module 1st-module) #(module 2nd-module))
> (1st-module:f 42)        
(#(before 42) #(inside 1st-module 42))
> (2nd-module:f 42)
(#(before 42) #(inside 2nd-module 42))
```

Here we see that the ``before`` macro is the same in both modules while the ``inside`` macro is local to each module.
