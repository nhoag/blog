---
categories: null
comments: null
date: 2016-09-05T15:45:22Z
description: null
share: null
tags:
- git
- osx
- gpg
- sign
title: Signing Commits in Git
url: /blog/2016/09/05/signing-commits-in-git/
---

There are some great resources for getting set up with signing Git commits and tags with a GPG key:

* https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
* https://help.github.com/articles/signing-commits-using-gpg/

After following instructions, I still got the following error:

```bash
error: gpg failed to sign the data
fatal: failed to write commit object
```

Below is a sequence of commands that got everything working properly:

```bash
# Assumes homebrew and existing key-pair
brew install pinentry-mac
# Get the secret key value
gpg2 --list-secret-keys | grep ^sec
git config --global user.signingkey {secret-value}
git config --global gpg.program $(which gpg2)
# Sign everything by default
git config --global commit.gpgsign true
echo "no-tty" >> ~/.gnupg/gpg.conf
echo $(which pinentry-mac) >> ~/.gnupg/gpg-agent.conf
```

When you next sign a tag or commit, you'll get a dialog asking for the password to your GPG key, and assuming all is well everything should complete nominally.

