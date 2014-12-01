---
layout: post
title: "Moving Away From Evernote"
modified:
description:
tags:
- ipython
- evernote
- s3
- notes
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2014-11-29T21:26:34-05:00
---

A few weeks ago, my Evernote account was unexpectedly truncated - it went from hundreds of notes to a mere handful. At that moment, Evernote for me became _'Phemernote_ (i.e. ephemeral ;)). After some poking around, I confirmed and accepted the data loss and committed to find a transparent and robust system for keeping notes.

My personal notes are mostly excerpts from daily tech ramblings. My Evernote contained passages and one-liners from projects, emails, chat transcripts, and the Web. I used it to recall information sources, as fodder for blogging, to remember tricky tech solutions and problems, and to share notes with friends and colleagues at opportune moments. All the regular stuff.

The data loss was painful, but it highlighted a problem and provided motivation to investigate alternatives. I can't yet say that my search is complete, but following are some thoughts about [Smallest Federated Wiki](https://github.com/WardCunningham/Smallest-Federated-Wiki) and [IPython Notebook](http://ipython.org/notebook.html), along with musings around a simpler alternative.

### Smallest Federated Wiki

Smallest Federated Wiki is an impressive distributed information system that has a lot of potential to revolutionize the Wiki-sphere. The major block for me with using this project is the investment to learn how to use it correctly. It has a dense UI and is as amorphous as they come. Up front, this reads as a deep investment of time to only possibly get my needs met.

### IPython Notebook

IPython Notebook has so far been easy and fun to set up and use. It maps to my expectations pretty well and is ***very*** pluggable. IPython Notebook can provide a very similar functionality and experience to Evernote. It also has the capability to execute code, which is an awesome bonus. There are some lacking features with IPython that if addressed could make it even better for this use-case, but as I'm discovering with additional use, IPython is full of fun surprises.

IPython Notebook doesn't have built-in functionality for creating local directories, comprehensive search, or note sharing. But it's easy enough to add or make up for these missing features with plugins, in-notebook code execution, and straight bash.

One thing I really miss from Evernote is the ability to embed an HTML snapshot of a webpage in a note. IPython provides embedded iframes, but this doesn't protect against a page going away.

There are implementations of IPython for [Ruby](https://github.com/minad/iruby) and [PHP](https://github.com/dawehner/ipython-php), which adds further power to in-notebook computation.

For backups I set up an S3 bucket with sync'ing courtesy of [AWS CLI](http://aws.amazon.com/cli/) ala:

```bash
aws --profile=profile-id s3 sync . s3://bucket-id --delete
```

### Simpler Alternative

Getting back to basics, there are plenty of alternatives for assembling a simple notebook repository. The most straight-forward approach would be to write/paste locally in `$editor` and commit to `$vcs` repository. This is stable, can be backed up anywhere, and is version controlled. For sharing, specific notes can be piped to Github Gist:

```bash
gist -c -p < path/to/file
```

For increased compatibility and consistency across mediums (notebook, Gist, static website), it's probably not a bad idea to compose notes in Markdown. There are a few tools for automating conversions to markdown, but it'll take some investigation to identify whether the below options are any good:

- [Pandoc](http://johnmacfarlane.net/pandoc/)
- [reverse_markdown](https://github.com/xijo/reverse_markdown)
- [Bullseye](http://brettterpstra.com/2013/07/30/precise-web-clipping-to-markdown-with-bullseye/)
