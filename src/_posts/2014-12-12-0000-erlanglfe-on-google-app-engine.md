---
layout: post
title: "Erlang/LFE on Google App Engine"
description: "Getting Erlang and LFE up and running on GAE"
category: tutorials
tags: [google,cloud,gae,app engine, rest, lfest, yaws, web, services]
author: Duncan McGreggor
---
{% include JB/setup %}
<a href="{{ site.base_url }}/assets/images/posts/GoogleCloudPlatform.png"><img class="right small" src="{{ site.base_url }}/assets/images/posts/GoogleCloudPlatform.png" /></a>
Recently the long-stanging Google App Engine
[ticket for Erlang support](https://code.google.com/p/googleappengine/issues/detail?id=125)
was closed as "WontFix". Though iniitally this seemed to be bad news, a link
was provided in the ticket:
[Google App Engine: Custom Runtimes](https://cloud.google.com/appengine/docs/managed-vms/custom-runtimes)
... hope springs eternal, and such did not let us down. In this post we show
how to get Erlang and LFE apps up and running using this GAE feature in
conjunction with YAWS as well as some LFE web and utility libraries.


## GAE Custom Runtimes

A quick intro to this feature is given in the following two different paragraphs
from the site:

<blockquote>Custom runtimes allow you to define new runtime environments (such
as language interpreters or application servers) on Managed VMs. The Managed VM
SDK will then deploy, load balance and scale your application.
</blockquote>

<blockquote>Custom runtimes work by allowing a developer to define the base
runtime image using Dockerfiles (a recipe to build a Docker container) to define
a base runtime environment that your application will run in. Typically a
Dockerfile will configure a basic serving stack for your application as well as
all its dependencies.
</blockquote>


## Previously: The Erlang/LFE Docker Tutorial

This tutorial is based upon the code and ``Dockerfile`` created as part of the
[Erlang/LFE Docker tutorial](http://blog.lfe.io/tutorials/2014/12/07/1837-running-lfe-in-docker/).
It has been adapted for use on Google App Engine and pushed to a
[repository on Github](https://github.com/oubiwann/gae-lfe-yaws-sample-app).


## This Tutorial

This tutorial will cover new ground, starting where the last one left off. In
particuar, it will focus on deploying Erlang ``Dockerfile``s on Google's
infrastructure. Here's a high-level overview of topics to be covered:

* Setting setup with 
* Adding app routes for the GAE custom runtime
* Updating the sample app with code supporting the new routes
* Configuring the GAE app
* Setting up logging

## XXX

```bash
$ curl https://sdk.cloud.google.com | bash
```


* Login to (or sign up at)
  [https://cloud.google.com/console](https://cloud.google.com/console)
* Create a new project, giving a name and ID (e.g., "LFE Sample App" and
  "lfe-sample-app"

```bash
$ gcloud auth login
```

```bash
$ gcloud components update app
```

Download and install the version of boot2docker supported by GAE (1.3.0 as
of the writing of this post).

## Routes

## API

## YAWS Entry Point and Utility Functions


## Configuring the App

``Dockerfile``:

```
FROM debian
RUN apt-get update && apt-get install -y \
    build-essential \
    libpam0g-dev \
    erlang \
    rebar
COPY . /usr/src/volvoshop
WORKDIR /usr/src/volvoshop
CMD [ "make", "" ]
```

``app.yaml``:

```yaml
runtime: custom
vm: true
api_version: 1
```

## Dockerfile


## Configuring App Lifecycle Events

We need to configure the following:

 * start
 * stop
 * health check


## Logging

```
/var/log/app_engine/custom_logs
/var/log/app_engine/request.log
```

## Cloud Platform Services

 * Google Cloud Storage
 * Google Cloud Datastore
 * Google Authentication


## Running in Dev Mode

```bash
$ gcloud preview app run
```

```bash
$ gcloud preview app deploy
```

## Deploying


