---
comments: true
date: 2013-09-11T00:00:00Z
tags:
- ncdu
- goaccess
- utc
title: A Few Quick Updates
url: /blog/2013/09/11/a-few-quick-updates/
---

### ncdu for the Win

While reading through some internal tool enhancement tickets at work the other day, I happened accross a quick mention of a command line tool that I'd not yet seen, but which proved to have immediate value. The tool is `ncdu`, 'NCurses Disk Usage', which as the man page states, "...provides a fast way to see what directories are using your disk space."

In the process of onboarding new sites to [Acquia Cloud](http://www.acquia.com/products-services/acquia-cloud), it's not always clear where the lines have been drawn with regard to separating out code and media assets for a site. [Drupal](https://drupal.org/) itself is also quite flexible about where media can be stored, and custom PHP opens up the possibilities completely. Version control is not so forgiving, as loading media into a VCS can cause a repository to be unusably slow. In order to maintain wholistic efficiency for a project, it's helpful to know if there are bulky files stashed somewhere in an application. With this piece of the puzzle, it's possible to divert media assets out of the repo and into the file system.

This is where `ncdu` comes in. Regular old `du` is a handy tool indeed, but requires a lot of iterative manual steps to walk through an entire directory tree. By contrast, ncdu pops you into an interactive screen with a simple graph showing where the heaviest files are located. You can quickly navigate up the chain and find those big files in no time! Note: Calculating disk usage in a large and vast file system is still going to take some time to crunch.

### GoAccess Plugin: UTC Support Added

In other news, the [GoAccess Shell Plugin](https://github.com/nhoag/goaccess-plugin) is freshly outfitted with UTC time specification. In addition to being able to filter by start time X hours or minutes ago, you can now pass a UTC argument to hit a specific time range in an access log. To have the script return values starting at UTC 9:30am, you can pass `--time=0930`. The new change is particularly helpful for honing in on that 3-5 minute period of downtime where you want to determine if there were any anomalies in the traffic pattern.

