---
comments: true
date: 2014-04-01T14:06:35Z
tags:
- git
- filter-branch
- directory
- shrink
- history
title: More Fun with 'git filter-branch'
url: /blog/2014/04/01/more-fun-with-git-filter-branch/
---

[Previously](http://nathanielhoag.com/blog/2013/11/06/tools-and-processes/), I covered the use of the `git filter-branch` for removing large media assets from a repository's history.

Recently I had a new opportunity to perform this task on whole directories. Here is the command sequence I used to clean up the repo history and to shrink the pack file:

```
# Remove a directory from history in all branches and tags
$ git filter-branch --index-filter 'git rm -r --cached --ignore-unmatch path/to/dir' --tag-name-filter cat -- --all

# Shrink the local pack
$ rm -Rf .git/refs/original
$ rm -Rf .git/logs
$ git gc
$ git prune --expire now

# Push up changes to the remote
$ git push origin --force --all
$ git push origin --force --tags
```

Additionally, it turns out I only had a partial list of assets to remove from the repo. I was able to track down the rest with a couple of additional Git commands:

```
# Show the 20 largest items in the pack
$ git verify-pack -v .git/objects/pack/pack-{hash}.idx | sort -k 3 -n | tail -n 20

# View a pack object
$ git rev-list --objects --all | grep {hash}
{hash} path/to/pack/object.ext
```

Rinse and repeat.
