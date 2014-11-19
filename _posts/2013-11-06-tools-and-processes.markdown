---
layout: post
title: "Tools and Processes"
date: 2013-11-06 08:52
comments: true
tags: 
- argument expansion
- filter-branch
- history expansion
- screen
- stash
- windows linebreaks
---
bash tricks accumulated over the last several weeks:

#### Argument expansion

Need to move or copy a file under a long directory tree?

```
cp /this/is/a/really/long/path/to/{file-01,file-02}.txt
```

#### Git filter-branch

Need to get rid of large media files in your Git repo throughout the entire history of the project?

```
git filter-branch --index-filter \
    'git rm --cached --ignore-unmatch ./path/to/file/*.ext' \
    --tag-name-filter cat -- --all
```

Supports wildcard matching!

#### History Expansion

There are several techniques here, but my current favorites are `sudo !!` (re-run the last command as sudo), and `!<string>` (run the most recent command starting with string).

#### Long-running Processes with screen

Running a multi-hour/day process and don't want your computer to be tied to the task? Use `screen`!

* Create	`Ctl-a Ctl-c`
* Switch 	`Ctl-a n`, `Ctl-a p` 
* List 		`Ctl-a "`
* Name		`Ctl-a A`
* Kill		`Ctl-a k`
* Detach	`Ctl-a d`

To re-attach you can list screens with `screen -list`. Then re-attach with `screen -r {SCREEN-ID}`.

#### Git stash

Just because it's not entirely clear how this works, but it really is this simple:

```
git stash save "Short description"
git stash list
git stash pop stash@{0}
```

If you're on "branch-A" and want changes to apply to "branch-B", simply checkout branch-B and then stash.

#### Remove Pesky Windows Linebreaks

I frequently observe Windows-style line-endings `` in code files. These can introduce confusion into the repo history, as inconsistency in line-break handling will cause lines that may have no visible changes to be recorded as a change. Here's a little vim magic to remove these cleanly:

```
:%s/<Ctrl-V><Ctrl-M>//g
```
