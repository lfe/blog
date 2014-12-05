# LFE Blog

*The code repo for the LFE News & Updates Blog*

We welcome blog contributors! Just
[fork the repo](https://github.com/lfe/blog/fork), write your post, and submit
a PR.

You can view the blog [here](http://blog.lfe.io/).


## Requirements

Install [git-subtree](https://github.com/andrewmwhite/git-subtree):

```bash
$ git clone git@github.com:andrewmwhite/git-subtree.git
$ cd git-subtree
$ sudo make install
```


## Workflow

#### Summary

* Fork this repo (you might want to rename yours from "blog" to "lfe-blog")
* See the usage below to create a post
* Regenerate the static content
* Push the updated static content to the ``gh-pages`` branch your fork
* Issue a PR from your ``gh-pages`` branch to the upstream ``gh-pages`` branch

#### Get the code

 * [Fork us](https://github.com/lfe/blog/fork).
 * Update the name in your new repo's settings
 * Clone:

    ```bash
    $ git clone git@github.com:<YOURNAME>/lfe-blog.git
    $ cd lfe-blog
    ```

#### Create a post

```bash
$ TITLE="Exciting LFE News" make new
```

Edit to your heart's content. Be sure to update the following:
 * Category (theme of your post)
 * Descriptive tags
 * Your name as ``author``


#### Add to the repo

```bash
$ git add src/_posts/2014-12-04-1323-exciting-lfe-news.md
```

Also at this point you'll want to add any new directories that were created,
e.g., for tags, archives, years, etc. Make sure you didn't miss anything by
checkout the untracked files in the ``git status`` output.


#### Publish

```bash
$ make publish
```

The ``make`` target of that final command rebuilds the site and then pushes the
content of your newly-refreshed``./prod`` directory up to the ``gh-pages``
branch of your fork.

At that point, you're ready to go to your fork on Github, switch to the
``gh-pages`` branch, and issue the pull request to ``gh-pages`` on ``lfe/blog``.


Note: when you push this change up to your ``gh-pages`` branch, you may see a
Github Pages build warning about the ``CNAME`` file. You can ignore that :-)


## Usage

To create a new post:
```bash
$ TITLE="Super-Sweet LFE Tutorial" make new
```
This will open a draft with ``vi``. Edit to your heart's content, save, commit,
push, and send the PR!

Other useful ``make`` targets:

*Rebuild the site static files in the ``./prod`` directory*:

```bash
$ make build
```

*Run a local copy of the site available on http://localhost:4000, served from
the ``./prod`` directory*:

```bash
$ make run
```

*Run a staged copy of the site available on http://localhost:4000, served from
the ``./stage`` directory*:

```bash
$ make run-stage
```

*Clean up your staged files*:

```bash
$ make clean
```

*Update your jekyll Ruby gem. This will also update your gems and install
jekyll, if it's not already installed*:

```bash
$ make update
```

*Publish your changes to ``master`` and ``gh-pages``*:

```bash
$ make publish
```


## Built With

This site is built using [Jekyll-Bootstrap](http://jekyllbootstrap.com/) with
a modified version of the
[Hooligan](http://themes.jekyllbootstrap.com/preview/hooligan/) template.
