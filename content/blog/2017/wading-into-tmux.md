---
title: "Wading Into Tmux"
date: 2017-12-02T13:58:54-05:00
tags:
- tmux
- terminal
- n00b
---
During a recent group debugging session at work, I was reminded about tmux. I hadn't really used it outside of a couple of brief experiments that were little more than opening the application (and then struggling to kill it), so on this occasion I used `screen`. Whatever the reason, apparently ***now*** is the time for tmux! In this post, I'll cover a few of the impediments and blessings encountered so far, since I seem to have gotten the _good_ kind of tmux bug.

I've had an inherited `.tmux.conf` file in my forked "dots" repo for years, but it's done little more than gather dust. In fact, firing up tmux for the "first" time revealed that my config was not entirely compatible with the latest version of tmux. I started by commenting out offending lines and then read up on what most of the config declarations were meant to do. In the end, I landed on a config that's a blend of niceties discovered through researching various bugs and peeves.

I'm a zsh user. After working through the obvious errors printed to screen on tmux startup, I hit a bit of a roadblock with substring history search not working. This one plugin is a major reason I'm a zsh user. After trying a bunch of suggestions from the Internet, this bug was stubbornly not budging. Then I stumbled on a reference to this issue having been addressed in the plugin, and realized I hadn't updated my zsh plugins in a loooonnnggg while. I ran `zgen selfupdate && zgen update`, and the bug was no more.

I've come to appreciate immersive computer applications, and the iTerm2 app title bar just seems like so much wasted screen real estate. Newer versions of iTerm2 provide a config for this in Preferences > Profiles > Window > Style > No Title Bar. With the move to tmux, this seemed like an especially useful config change.

Next I had to learn the "tmux way" for viewing backscroll. I'm very patterned to using the mouse to scroll up or the iTerm2 "find" feature to locate strings in the backscroll. At first I thought, "Maybe the backscroll is just gone? Guess I'll pipe to `less` and that will be a new thing I'll have to add to commands now." _Silly brain..._ of course, this is built into tmux (Yay copy-mode!). It turns out tmux copy-mode is kinda better than I could have hoped. It encourages a consistent experience between editor and command line, and makes it so easy and seamless to navigate these contexts.

The last thing I'll mention is CMD-K. I use this in the terminal all the time to make it easier to know where output from a particular command or session begins. It's super helpful when debugging tests or with verbose commands such as `strace`, and in a variety of other contexts. In tmux, CMD-K doesn't work so well. But you can get basically the same result with mapping CTRL-K as follows:

```bash
# Clear the current pane.
bind -n C-k send-keys -R \; clear-history
```

That's all for now. Happy multiplexing!

Update:

I found that the above pane clear declaration was a little aggressive in that the prompt string doesn't re-appear. The following doesn't have that problem:

```
# Clear the current pane.
bind -n C-k send-keys C-l \; clear-history
```
