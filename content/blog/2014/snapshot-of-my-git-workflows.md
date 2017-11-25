---
comments: true
date: 2014-03-15T10:57:48Z
tags:
- git
- rebase
- cherry-pick
- filter-branch
- tig
title: 'Snapshot: My Git Usage'
url: /blog/2014/03/15/snapshot-of-my-git-workflows/
---

Following are the Git commands and Git family of tools that I use in my day-to-day.

Before writing this post, I generated a report of my most-used git sub-commands with the following:

```
history | awk '$2 == "git" {print $3}' | sort | uniq -c | sort -nr | head -n 20
```

Most of my Git usage is bread-and-butter Git commands, but I'll highlight some of my favorite Git features below.

Say you've just added and committed a change, and _only then_ you spot a typo in your changes. Rather than adding a whole new commit for that, simply fix the typo, `git add` the fix, and then `git commit --amend` to incorporate the typo fix in the last commit.

You massively messed up a file or directory and just want to start over on that one thing:

```
git checkout ./path/to/messed-up-thing
```

Need to pull in a file from another branch in your repo?:

```
git checkout branch-name -- path/to/file
```

Need a new branch that's completely devoid of historical context?:

```
git checkout --orphan branch-name
```

When cloning a new Git repo, you don't always want to clone the 'master' branch, or to use the repo name as the directory name in your local clone. Here's how to get around both of these in one swoop:

```
git clone -b not-master repo-address.git local-name
```

Need to see a diff for a single file?:

```
git diff ./path/to/file
```

Want to add new files, modified files, and deleted files all in one go? Try `git add -A`. You can also refine this command by specifying, `./path/to/directory-or-file`.

For those times when you really need to reset, nothing beats `git reset --hard`. But wait a minute... all the new untracked files are still popping up with `git status`!! Sure we can `grep | awk | xargs rm` that cruft, but Git has a convenient (__yet dangerous!__) feature:

```
git clean [-f (-d)?]
```

I use `git log` often enough, and the prettification options make the command very useful, but my go-to for Git log review these days is good ol' `tig`. It's interactive, has great defaults, and is very easy to type.

Why do I use `git remote` so much?! The main reason is that I am usually connected to multiple remotes from a local clone - one for the canonical repo, and a second for my fork. `git remote -v` shows what my clone is connected to. This way I can easily rebase from upstream and ensure that my fork is in sync.

While merges are useful, I generally dislike merge commits. Aside from rebasing and setting git to auto-rebase on merge, another of my preferred methods for sharing commits between different branches is `git cherry-pick commit-hash`. With `cherry-pick`, you're essentially distilling a commit down to a diff and applying that diff to another branch, all in one awesomely concise command. `cherry-pick` even supports commit ranges as follows:

```
git cherry-pick 'older-commit-hash^..newer-commit-hash' # the '^' stands for inclusive
```

Certain types of repositories are particularly well suited to the `subtree` command. I happen to work with an open source project called Drupal, that when configured as a multisite is an excellent candidate for the `subtree` workflow. In this case you might find the following commands to be of use:

```
git subtree add --prefix sites/site-name multisite-repo-name branch-name --squash
# Then to update
git fetch remote-repo-name remote-branch-name
git subtree pull --prefix sites/site-name multisite-repo-name branch-name --squash
# And to push
git subtree push --prefix sites/site-name multisite-repo-name branch-name
```

In Drupal, `subtree` is particularly useful with sites that share a common profile or a common module or theme composition. It's also handy for keeping aspects of a multisite secret, or to retain control over the release of new features or sites to production.

Reset a git repo to _zilch_ with the following (__careful now!__):

```
mkdir dirname
cd dirname
git init
git remote add remote-name repo-address
git push --mirror --force remote-name
# Data destroyed!
```

Need to migrate an existing Git repo to a new repo address? Here are the commands:

```
git clone --mirror src-repo-address migrate
cd migrate
git remote add dst dst-repo-address
git push --mirror dst
cd ..
rm -rf migrate
```

