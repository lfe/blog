---
layout: post
title: "LFE Friday - httpc:request/1 and httpc:request/4"
description: ""
category: tutorials
tags: [lfe friday,lfe,erlang]
author: Robert Virding
---
{% include JB/setup %}
{% include LFEFriday/setup %}

Today's LFE Friday is on [httpc:request/1](http://www.erlang.org/doc/man/httpc.html#request-1) and [httpc:request/4](http://www.erlang.org/doc/man/httpc.html#request-4). The httpc module is Erlang’s HTTP 1.1 client, and the ``request`` function is a powerful way to make web requests using Erlang.

To start using the httpc module, you first have to make sure ``inets`` has been started.

```cl
> (inets:start)
ok
```

``httpc:request/1`` takes one argument, and that is the URL, as a Erlang string, you want to make the request against.

```cl
> (httpc:request "http://www.example.com")
#(ok
  #(#("HTTP/1.1" 200 "OK")
    (#("cache-control" "max-age=604800")
     #("date" "Thu, 22 Jan 2015 21:52:42 GMT")
     #("accept-ranges" "bytes")
     #("etag" "\"359670651\"")
     #("server" "ECS (ewr/1584)")
     #("content-length" "1270")
     #("content-type" "text/html")
     #("expires" "Thu, 29 Jan 2015 21:52:42 GMT")
     #("last-modified" "Fri, 09 Aug 2013 23:54:35 GMT")
     #("x-cache" "HIT")
     #("x-ec-custom-error" "1"))
    "<!doctype html>\n<html>\n<head>\n    <title>Example Domain</title>\n\n    <meta charset=\"utf-8\" />\n    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n    <style type=\"text/css\">\n    body {\n        background-color: #f0f0f2;\n        margin: 0;\n        padding: 0;\n        font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n        \n    }\n    div {\n        width: 600px;\n        margin: 5em auto;\n        padding: 50px;\n        background-color: #fff;\n        border-radius: 1em;\n    }\n    a:link, a:visited {\n        color: #38488f;\n        text-decoration: none;\n    }\n    @media (max-width: 700px) {\n        body {\n            background-color: #fff;\n        }\n        div {\n            width: auto;\n            margin: 0 auto;\n            border-radius: 0;\n            padding: 1em;\n        }\n    }\n    </style>    \n</head>\n\n<body>\n<div>\n    <h1>Example Domain</h1>\n    <p>This domain is established to be used for illustrative examples in documents. You may use this\n    domain in examples without prior coordination or asking for permission.</p>\n    <p><a href=\"http://www.iana.org/domains/example\">More information...</a></p>\n</div>\n</body>\n</html>\n"))
```

``httpc:request/1`` is the equivalent of the ``httpc:request/4`` function called as ``(httpc:request 'get (tuple url ()) () ())``.

```cl
> (httpc:request 'get #("http://www.example.com" ()) () ())
#(ok
  #(#("HTTP/1.1" 200 "OK")
    (#("cache-control" "max-age=604800")
     #("date" "Thu, 22 Jan 2015 21:55:34 GMT")
     #("accept-ranges" "bytes")
     #("etag" "\"359670651\"")
     #("server" "ECS (ewr/1584)")
     #("content-length" "1270")
     #("content-type" "text/html")
     #("expires" "Thu, 29 Jan 2015 21:55:34 GMT")
     #("last-modified" "Fri, 09 Aug 2013 23:54:35 GMT")
     #("x-cache" "HIT")
     #("x-ec-custom-error" "1"))
    "<!doctype html>\n<html>\n<head>\n    <title>Example Domain</title>\n\n    <meta charset=\"utf-8\" />\n    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n    <style type=\"text/css\">\n    body {\n        background-color: #f0f0f2;\n        margin: 0;\n        padding: 0;\n        font-family: \"Open Sans\", \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n        \n    }\n    div {\n        width: 600px;\n        margin: 5em auto;\n        padding: 50px;\n        background-color: #fff;\n        border-radius: 1em;\n    }\n    a:link, a:visited {\n        color: #38488f;\n        text-decoration: none;\n    }\n    @media (max-width: 700px) {\n        body {\n            background-color: #fff;\n        }\n        div {\n            width: auto;\n            margin: 0 auto;\n            border-radius: 0;\n            padding: 1em;\n        }\n    }\n    </style>    \n</head>\n\n<body>\n<div>\n    <h1>Example Domain</h1>\n    <p>This domain is established to be used for illustrative examples in documents. You may use this\n    domain in examples without prior coordination or asking for permission.</p>\n    <p><a href=\"http://www.iana.org/domains/example\">More information...</a></p>\n</div>\n</body>\n</html>\n"))
```

You can specify headers as part of your request. For example, say we want to get DuckDuckGo's page in Swedish in honor of Erlang being created by Ericsson. To do that, we add a tuple of ``#("Accept-Language" "sv")`` to the headers list as part of the request.

```cl
> (httpc:request 'get #("http://duckduckgo.com" (#("Accept-language" "sv"))) () ())
#(ok
  #(#("HTTP/1.1" 200 "OK")
    (#("cache-control" "max-age=1")
     #("connection" "keep-alive")
     #("date" "Thu, 22 Jan 2015 21:58:14 GMT")
     #("accept-ranges" "bytes")
     #("etag" "\"54c126fc-1488\"")
     #("server" "nginx")
     #("content-length" "5256")
     #("content-type" "text/html; charset=UTF-8")
     #("expires" "Thu, 22 Jan 2015 21:58:15 GMT"))
    "<!DOCTYPE html>\n<!--[if IEMobile 7 ]> <html lang=\"sv_SE\" class=\"no-js iem7\"> <![endif]-->\n<!--[if lt IE 7]> <html class=\"ie6 lt-ie10 lt-ie9 lt-ie8 lt-ie7 no-js\" lang=\"sv_SE\"> <![endif]-->\n<!--[if IE 7]>    <html class=\"ie7 lt-ie10 lt-ie9 lt-ie8 no-js\" lang=\"sv_SE\"> <![endif]-->\n<!--[if IE 8]>    <html class=\"ie8 lt-ie10 lt-ie9 no-js\" lang=\"sv_SE\"> <![endif]-->\n<!--[if IE 9]>    <html class=\"ie9 lt-ie10 no-js\" lang=\"sv_SE\"> <![endif]-->\n<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class=\"no-js\" lang=\"sv_SE\"><!--<![endif]-->\n\n  <head>\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\" />\n<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8;charset=utf-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, user-scalable=1\" />\n<meta name=\"HandheldFriendly\" content=\"true\"/>\n\n<link rel=\"canonical\" href=\"https://duckduckgo.com/\">\n\n<link rel=\"stylesheet\" href=\"/s927.css\" type=\"text/css\">\n<link rel=\"stylesheet\" href=\"/t927.css\" type=\"text/css\">\n\n<link rel=\"shortcut icon\" href=\"/favicon.ico\" type=\"image/x-icon\" sizes=\"16x16 24x24 32x32 64x64\"/>\n<link rel=\"apple-touch-icon\" href=\"/assets/icons/meta/DDG-iOS-icon_60x60.png\"/>\n<link rel=\"apple-touch-icon\" sizes=\"76x76\" href=\"/assets/icons/meta/DDG-iOS-icon_76x76.png\"/>\n<link rel=\"apple-touch-icon\" sizes=\"120x120\" href=\"/assets/icons/meta/DDG-iOS-icon_120x120.png\"/>\n<link rel=\"apple-touch-icon\" sizes=\"152x152\" href=\"/assets/icons/meta/DDG-iOS-icon_152x152.png\"/>\n<link rel=\"image_src\" href=\"/assets/icons/meta/DDG-icon_256x256.png\"/>\n\n<link title=\"DuckDuckGo\" type=\"application/opensearchdescription+xml\" rel=\"search\" href=\"/opensearch.xml\">\n\n<meta name=\"twitter:site\" value=\"@duckduckgo\">\n<meta name=\"twitter:url\" value=\"https://duckduckgo.com/\">\n\n<meta property=\"og:url\" content=\"https://duckduckgo.com/\" />\n<meta property=\"og:site_name\" content=\"DuckDuckGo\" />\n\n\n\t<title>DuckDuckGo</title>\n<meta property=\"og:title\" content=\"DuckDuckGo\" />\n<meta name=\"twitter:title\" value=\"DuckDuckGo\">\n\n\n<meta name=\"description\" content=\"The search engine that doesn't track you. A superior search experience with smarter answers, less clutter and real privacy.\">\n\n\n  </head>\n  <body id=\"pg-index\" class=\"page-index body--home\">\n\t<script type=\"text/javascript\">settings_js_version = \"/s1725.js\";</script>\n<script type=\"text/javascript\" src=\"/locales/sv_SE/LC_MESSAGES/duckduckgo-duckduckgo+sprintf+gettext+locale-simple.20150116.072656.js\"></script>\n<script type=\"text/javascript\" src=\"/d1725.js\"></script>\n\n\n<script type=\"text/javascript\">\n    DDG.page = new DDG.Pages.Home();\n</script>\n\n\n\t<div class=\"site-wrapper  site-wrapper--home  js-site-wrapper\">\n\t\n\t\t  \n\t\t\t<div class=\"header-wrap--home  js-header-wrap\"></div>\n\n\t\t\t<div id=\"\" class=\"content-wrap--home\">\n\t\t\t  <div id=\"content_homepage\" class=\"content--home\">\n\t\t\t\t<div class=\"cw--c\">\n\t\t\t\t\t\t\t<div class=\"logo-wrap--home\">\n\t\t\t<a id=\"logo_homepage_link\" class=\"logo_homepage\" title=\"About DuckDuckGo\" href=\"/about\">About DuckDuckGo</a>\n\t\t</div>\n<!--\n\t\t<div class=\"logo-wrap--home\">\n\t\t\t<a id=\"logo_homepage_link\" class=\"logo_homepage  logo_homepage--resetthenet\" title=\"Reset the Net\" href=\"https://www.resetthenet.org/\" target=\"_new\">Reset the Net</a>\n\t\t</div>\n\t\t//-->\n\n\t\t\t\t\t<div class=\"search-wrap--home\">\n\t\t\t\t\t\t\t\t<form id=\"search_form_homepage\" class=\"search  search--home  js-search-form\" name=\"x\" method=\"POST\" action=\"/html\">\t\t\t\n\t\t\t<input id=\"search_form_input_homepage\" class=\"search__input  js-search-input\" type=\"text\" autocomplete=\"off\" name=\"q\" tabindex=\"1\" value=\"\">\n\t\t\t<input id=\"search_button_homepage\" class=\"search__button  js-search-button\" type=\"submit\" tabindex=\"2\" value=\"S\" />\n\t\t\t<input id=\"search_form_input_clear\" class=\"search__clear  empty  js-search-clear\" type=\"button\" tabindex=\"3\" value=\"X\" />\n\t\t\t<div id=\"search_elements_hidden\" class=\"search__hidden  js-search-hidden\"></div>\n\t\t</form>\n\n\t\t\t\t\t</div>\n\t\t\t\t\n\t\t  \n\t\t\n\n\t\t<!-- sv_SE Alla instÃ¤llningar -->\n\t\t\n<div id=\"tagline_homepage\" class=\"tag-home\">\n\n\tSÃ¶kmotorn som inte spÃ¥rar dig.\n\t<span class=\"tag-home__links\">\n\t\t<span class=\"js-homepage-cta\"><a href=\"/spread\" class=\"tag-home__link\"> HjÃ¤lp till att fÃ¶ra DuckDuckGo vidare! </a> <span class=\"tag-home__links__sep\">|</span> </span><a href=\"/tour\" class=\"tag-home__link\">Titta runt</a>\n\t</span>\n</div>\n\t\t\n\t\t<div id=\"error_homepage\"></div>\n\n\n\t\n\t\t\n\t\t\t\t</div> <!-- cw -->\n\t\t\t </div> <!-- content_homepage //-->\n\t\t  </div> <!-- content_wrapper_homepage //-->\n\t\t  <div id=\"footer_homepage\" class=\"foot-home  js-foot-home\"></div>\n\n<script type=\"text/javascript\">\n\t{function seterr(str) {\n\t\tvar error=document.getElementById('error_homepage');\n\t\terror.innerHTML=str;\n\t\t$(error).css('display','block');\n\t}\n\tvar err=new RegExp('[\\?\\&]e=([^\\&]+)');var errm=new Array();errm['2']='ingen sÃ¶k';errm['3']='sÃ¶k fÃ¶r lÃ¥ng';errm['4']='UTF\\u002d8 kodar ej';if (err.test(window.location.href)) seterr('Oops, '+(errm[RegExp.$1]?errm[RegExp.$1]:'det blev ett fel.')+' &nbsp;Var vÃ¤nlig fÃ¶rsÃ¶k igen');};if (ip) setTimeout('nuo(1)',250);nip(1)\n\t\n\tif (kurl) {\n\t  document.getElementById(\"logo_homepage_link\").href += (document.getElementById(\"logo_homepage_link\").href.indexOf('?')==-1 ? '?t=i' : '') + kurl;\n\t}\n</script>\n\n\t\t\n\t    \n\t\n    </div> <!-- site-wrapper -->\n  </body>\n</html>\n"))
```

The third argument of ``httpc:request/4`` is a list of HTTP option tuples. For example, you need to set timeouts on the response in order to avoid waiting on a response from an irresponsive or slow website because if it doesn't respond in time, the requesting code needs to back off and try again later to avoid triggering the equivalent of a Denial of Service attack. In this case, I am specifying a timeout of 0, expressed in milliseconds, to ensure a timeout happens for illustrative purposes.

```cl
> (httpc:request 'get #("http://erlang.org" ()) '(#(timeout 0)) ())
#(error
  #(failed_connect (#(to_address #("erlang.org" 80)) #(inet (inet) timeout))))
```

As it's final argument, ``httpc:request/4`` takes a list of other options, these options are for how the Erlang side of things should work. Maybe you want to make a request asynchronously, and want to receive a message when it is complete. To do that you can specify an option tuple of ``#(sync false)``.

```cl
> (set `#(ok ,requestid) (httpc:request 'get '#("http://example.com" ()) () '(#(sync false))))
#(ok #Ref<0.0.0.87>)
> (receive (`#(http #(,requestid ,result)) result) (after 500 -> error))
#(#("HTTP/1.1" 200 "OK")
  (#("cache-control" "max-age=604800")
   #("date" "Thu, 22 Jan 2015 22:06:01 GMT")
   #("accept-ranges" "bytes")
   #("etag" "\"359670651\"")
   #("server" "ECS (phl/9D2C)")
   #("content-length" "1270")
   #("content-type" "text/html")
   #("expires" "Thu, 29 Jan 2015 22:06:01 GMT")
   #("last-modified" "Fri, 09 Aug 2013 23:54:35 GMT")
   #("x-cache" "HIT")
   #("x-ec-custom-error" "1"))
  #B("<!doctype html>\n<html>\n<head" ...))
```

Or maybe you want to get the response body back as an Erlang binary instead of a string.

```cl
> (httpc:request 'get '#("http://example.com" ()) () '(#(body_format binary)))
#(ok          
  #(#("HTTP/1.1" 200 "OK")
    (#("cache-control" "max-age=604800")
     #("date" "Thu, 22 Jan 2015 22:08:20 GMT")
     #("accept-ranges" "bytes")
     #("etag" "\"359670651\"")
     #("server" "ECS (ewr/1584)")
     #("content-length" "1270")
     #("content-type" "text/html")
     #("expires" "Thu, 29 Jan 2015 22:08:20 GMT")
     #("last-modified" "Fri, 09 Aug 2013 23:54:35 GMT")
     #("x-cache" "HIT")
     #("x-ec-custom-error" "1"))
    #B("<!doctype html>\n<html>\n<hea" ...)))
```

This post just scratches the surface of what you can do with ``httpc:request/4``, and I highly recommend checking out the Erlang documentation for the [httpc module](http://www.erlang.org/doc/man/httpc.html). For more examples and information, also check out the [Erlang inets User Guide](http://www.erlang.org/doc/apps/inets/users_guide.html), and the chapter ["HTTP Client"](http://www.erlang.org/doc/apps/inets/http_client.html).

–Proctor, Robert
