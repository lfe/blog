---
layout: post
title: "LFE Friday - string:tokens/2"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today’s LFE Friday is [string:tokens/2](http://www.erlang.org/doc/man/string.html#tokens-2).

``string:tokens/2`` takes a string as the first argument, and a list of separators to split the string on, and returns a list of token strings.

```cl
> (string:tokens "foo" "")
("foo")
> (string:tokens "banana" "a")
("b" "n" "n")
> (string:tokens "It was the best of times, it was the worst of times" " ") 
("It" "was" "the" "best" "of" "times," "it" "was" "the" "worst" "of" "times")
```

If consecutive separators appear in the string they will be treated as a single separator, and no empty strings will be returned.

```cl
> (string:tokens "Mississippi" "s")
("Mi" "i" "ippi")
> (string:tokens "Mississippi" "sp")
("Mi" "i" "i" "i")
> (string:tokens "Mississippi" "is")
("M" "pp")
```

The order of the separators in the separator list passed to ``string:tokens/2`` does not matter, and can be specified in any order.

```cl
> (string:tokens "Mississippi" "ps")                                       
("Mi" "i" "i" "i")
> (string:tokens "Mississippi" "sp")
("Mi" "i" "i" "i")
```

And as the separator list is just simply a list of separators, instead of passing a string, the integer values for the characters to use as the separators can be passed as a list, as a list of the integers is the same as a string.

```cl
> #\s
115
> #\p
112
> '(115 112)
"sp"
> (string:tokens "Mississippi" '(115))
("Mi" "i" "ippi")
> (string:tokens "Mississippi" '(115 112))
("Mi" "i" "i" "i")
```

–Proctor, Robert
