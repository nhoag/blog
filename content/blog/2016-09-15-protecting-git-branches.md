---
categories: null
comments: null
date: 2016-09-15T20:57:37Z
description: null
share: null
tags:
- git
- protect
- branch
title: Protecting Git Branches
url: /blog/2016/09/15/protecting-git-branches/
---

I've been thinking about the vulnerability of the primary Git branch for the last several weeks. Mostly out of paranoia about destroying a critical application. I added protective measures to my local clones on important projects and was content in thinking that I was now safe. But today I was reminded that this is only a small part of protecting a collaborative project.

Here's what happened:

1. User 1 made a commit on `master` and pushed to `origin`
2. User 2 fixed a bad merge on branch `feature` and ran `git push --force`
3. User 1 made a tag directly on the remote and deployed to Production
4. User 1 saw the new tag in production, but the new commit was missing

The problem was introduced with the `git push --force`. User 2 must have had a Git `push` configuration of `default = matching`. This is the default in Git version pre-2.0, but can still be set explicitly on newer versions. The result was that the intended `feature` branch was force pushed, ***AND*** the `master` branch was also ***force pushed***!! Yikes.

We lucked out, as the newly deployed tag was identical to the previous tag and there was no production impact. But the result could have been much, much worse.

Here's what we're doing about it:

1. Add local force push protection for the `master` branch with a `pre-push` Git hook and push config enforcement
2. Add protection to the `master` branch of our Github mirror if possible

We already use a `git-setup.sh` script to add a `pre-commit` static code checker, so it should be pretty quick to add a `pre-push` hook from the following Gist:

* https://gist.github.com/pixelhandler/5718585

The one case this hook doesn't cover is the exact scenario described above. In order to protect against this, we can add local Git configuration to ensure the default push behavior as anything other than `matching`. My current preference is for `nothing`, but really any of `simple`, `current`, or `upstream` should work fine.

We use Github primarily for code reviews and mirror our repo there via Jenkins. It's not clear whether branch protection is compatible with mirroring via Jenkins, so that'll need some more research.
