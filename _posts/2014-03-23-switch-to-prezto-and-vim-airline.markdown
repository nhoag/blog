---
layout: post
title: "Switch to Prezto and vim-airline"
date: 2014-03-23 22:14:16 -0400
comments: true
tags: 
- terminal
- airline
- zsh
- prezto
- vim
---
I've been using [Oh-My-Zsh](http://ohmyz.sh/) and [Powerline](https://github.com/Lokaltog/powerline) for vim for a while now, but just recently converted to [Prezto](https://github.com/sorin-ionescu/prezto) and [vim-airline](https://github.com/bling/vim-airline), repectively, on word of the usability and performance improvements. Already, the benefits have been well worth the minimal effort required to set these up.

* __Note:__ anecdotally, the original switch from bash to zsh was quite easy - I understandably hear questions about this often.

With Prezto, two improvements stand out markedly:

1. Using the Oh-My-Zsh git plugin, I would often see a long lag time (_sometimes 5+ seconds!_) between cd'ing into a git repo and the appearance of the prompt - I'm kind of surprised I never traced that =/ In any case, Prezto is consistently near-instantaneous.
2. I had a reverse history search with Oh-My-Zsh that would check for the string ahead of the first space (i.e. `cd th` would show me any previous `cd` commands via the 'up' arrow). The Prezto reverse history search plugin does two or three better by letting me search for strings with spaces, 'cd' will match any command from history that had 'cd' anywhere in the entire command, and there is a nice highlight on each match.

With vim-airline, set-up and customization were an absolute breeze - especially compared to powerline, which is notoriously difficult to install.

So as you can tell, I'm sold. I haven't been this excited about the shell in at least months :)

