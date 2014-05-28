---
layout: post
title: "The Secret History of LFE"
description: "A post to the mail list too good to just keep there :-)"
category: history
tags: [history,discussion]
---
{% include JB/setup %}

When asked recently about the history of LFE on the <a href="https://groups.google.com/d/msg/lisp-flavoured-erlang/XA5HeLbQQDk/Jdbf0KJV7dUJ">LFE mail list</a>,
Robert replied with some nice information that we couldn't resist highlighing/duplicating here:

	The earliest work is actually from 2007 but this was toying with
	parsing and implementing a lisp and was more a preamble to LFE. The
	real work with LFE didn't start until 2008. The earliest LFE files I
	can find are from March 2008. Originally I wasn't using github, or any
	other vcs for that matter, and just kept the separate versions as
	copies of the directory tree.

	There were a number of reasons why I started with LFE:

	* I was an old lisper and I was interested in implementing a lisp.
	* I wanted to implement it in Erlang and see how a lisp that ran on,
	  and together with, Erlang would look. A goal was always to make a
	  lisp which was specially designed for running on the BEAM and able to
	  fully interact with Erlang/OTP.
	* I wanted to experiment with compiling another language on top of
	  Erlang. So it was also an experiment in generating Core erlang and
	  plugging it into the backend of the Erlang compiler.
	* I was not working with programming/Erlang at the time so I was
	  looking for some interesting programming projects that were not too
	  large to do in my spare time.
	* I like implementing languages.
	* I also thought it would be a fun problem to solve. It contains many
	  different parts and is quite open ended.

Thanks again, Robert :-)


