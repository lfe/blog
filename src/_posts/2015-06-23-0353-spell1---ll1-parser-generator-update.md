---
layout: post
title: "spell1 - LL(1) parser generator update"
description: ""
category: tutorials
tags: [spell1,lfe,erlang,tools]
author: Robert Virding
---
{% include JB/setup %}
<a href="{{ site.base_url }}/assets/images/posts/lfe-tooling-leonardo-gears-2.png"><img class="right small" src="{{ site.base_url }}/assets/images/posts/lfe-tooling-leonardo-gears-2.png" /></a> Work has been proceeding with spell1 and we now have something useable. There are now two front-ends for the language of the grammar files and output files, one for handling Erlang, and the other for handling LFE.

The way the spell1 code is split makes it quite straight-forward to add front-ends for other languages. Even to have the grammar file in one syntax and the output file in another.

Work is now being done to automatically handle left-recursion and multiple rules with the same prefix.

Comments welcome.

Robert
