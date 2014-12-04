# LFE Blog

*The code repo for the LFE News & Updates Blog*

## Requirements

Install [git-subtree](https://github.com/andrewmwhite/git-subtree):

```bash
$ git clone git@github.com:andrewmwhite/git-subtree.git
$ cd git-subtree
$ sudo make install
```

## Workflow

* Fork this repo (you might want to rename yours from "blog" to "lfe-blog")
* See the usage below to create a post
* Regenerate the static content
* Push the updated static content to the gh-pages branch your fork
* Issue a PR from your gh-pages branch to the upstream gh-pages branch

There are some ``make`` targets defined that should make this easier for you.
Here's an example:

```bash
$ ./bin/new-post "Quick Test"
$ git add src/_posts/2014-12-04-1323-quick-test.md
$ make publish
```

The ``make`` target of that final command rebuilds the site and then pushes the
content of your newly-refreshed``./prod`` directory up to the ``gh-pages``
branch of your fork.


## Usage

We welcome blog contributors! Just
[fork the repo](https://github.com/lfe/blog/fork), write your post, and submit
a PR. Be sure to enter your name in the post meta data after the ``Author:``
header ...

To create a new post:
```bash
$ ./bin/new-post "Super-Sweet LFE Tutorial"
```
This will open a draft with ``vi``. Edit to your heart's content, save, commit,
push, and send the PR!

Useful ``make`` targets:

*Run a local copy of the site available on http://localhost:4000, served from
the ``./staged`` directory*:

```bash
$ make run
```

*Build a local copy of the site in the ``./staged`` directory*:

```bash
$ make build
```

*Update your jekyll Ruby gem. This will also update your gems and install
jekyll, if it's not already installed*:

```bash
$ make update
```

## Built With

This site is built using the Jekyll-Bootstrap Hooligan template.
