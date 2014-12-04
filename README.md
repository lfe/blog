# LFE Blog

*The code repo for the LFE News & Updates Blog*

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
