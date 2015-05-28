# LFE Blog

*The code repo for the LFE News & Updates Blog*

We welcome blog contributors! Just
[fork the repo](https://github.com/lfe/blog/fork), write your post, and submit
a PR.

You can view the blog [here](http://blog.lfe.io/). The LFE blog is a member of
[Planet Erlang](http://planeterlang.com/).


## Requirements

For those who will actually be executing the ``make publish`` target, ``git-subtree`` is required.

Install [git-subtree](https://github.com/andrewmwhite/git-subtree):

```bash
$ git clone git@github.com:andrewmwhite/git-subtree.git
$ cd git-subtree
$ sudo make install
```


## Workflow

### For Contributors

#### Summary

* Fork this repo (you might want to rename yours from "blog" to "lfe-blog")
* See the usage below to create a post
* Push to your fork
* Issue a PR from your branch to lfe/blog ``master``


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


#### Issue a Pull Request

Once you're stasified with your post, push your branch up to your fork of
the blog and issue a PR to be merged with ``master`` of lfe/blog.


### For Maintainers

#### Summary

* Merge a contributor's PR
* Regenerate the static content
* Push the updated static content to ``gh-pages``


#### Publish

Once a contributor's code has been merged (either in the Web UI or via
command line), you are ready to publish. This needs to be done locally,
so if I've merged a PR on Github, you'll need to ``$ git pull origin master``.

The following command will regenerate the static content, commit it to
master (interactively), and then push the static content to ``gh-pages``
for the LFE blog repo on github (which will be renderable immediately on
the blog):

```bash
$ make publish
```


## Usage

To create a new post:
```bash
$ TITLE="Super-Sweet LFE Tutorial" make new
```
This will open a draft with ``vi``. Edit to your heart's content, save, commit,
push, and send the PR!

Other useful ``make`` targets:

*Rebuild the site static files in the ``./build`` directory*:

```bash
$ make build
```

*Run a local copy of the site available on http://localhost:4000, served from
the ``./build`` directory*:

```bash
$ make run
```

*Clean up your build files*:

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

*Publish your changes to staging-blog.lfe.io:

```bash
$ make staging
```


## Built With

This site is built using [Jekyll-Bootstrap](http://jekyllbootstrap.com/) with
a modified version of the
[Hooligan](http://themes.jekyllbootstrap.com/preview/hooligan/) template.
