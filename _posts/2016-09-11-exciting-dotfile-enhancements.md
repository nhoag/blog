---
layout: post
title: "Exciting Dotfile Enhancements"
modified:
categories: 
description:
tags:
- dotfiles
- git
- alias
- vim
- zsh
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2016-09-11T21:09:53-04:00
---
Over the weekend, I've been cleaning up, organizing and improving my dotfiles. Below are a couple of things that I'm most excited about.

### Zsh in Vim Mode

I've been using zsh for a while, but only recently starting using zsh in Vim mode. One thing that's been sorely missing is moving by word in `INSERT` mode. I got this working by adding the following to `~/.zshrc`:

```bash
bindkey '^b' backward-word
bindkey '^w' forward-word
```

With this config loaded, I can move forward by word boundaries with `Control-w` and backward with `Control-b`. Lot's more configurations are listed [here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Movement).

### Git Advanced Aliases

I've been assembling Git shortcuts into a separate "functions" dotfile, but learned that it's maybe cleaner to use Git _advanced aliases_. You can read more about advanced aliases [here](http://blogs.atlassian.com/2014/10/advanced-git-aliases/).

The advanced alias I'm most excited about is triggering a `post-push` hook, which is [not provided in Git core](https://git-scm.com/docs/githooks). The below solution is adapted to a Git advanced alias from [this Stack Overflow thread](http://stackoverflow.com/questions/1797074/local-executing-hook-after-a-git-push):

```bash
  # Wrapper for git push to enable a post-push hook
  push-with-hooks = !"f() { \
      local GIT_DIR_="$(git rev-parse --git-dir)" \
        && local BRANCH="$(git rev-parse --symbolic --abbrev-ref $(git symbolic-ref HEAD))" \
        && local POST_PUSH="$GIT_DIR_/hooks/post-push" \
        && git push "$@" \
        && test $? -eq 0 && test -x "$POST_PUSH" \
        && exec "$POST_PUSH" "$BRANCH"; \
    }; f"
```

With the above in place, put the following in an executable file at `.git/hooks/post-push`:

```bash
#!/bin/sh

echo "$@"
```

This doesn't do much as-is outside of echoing the current branch to `STDOUT`, but could be used to trigger a build, or all kinds of fun things!
