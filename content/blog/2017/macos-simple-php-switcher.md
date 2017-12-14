---
title: "macOS: Simple PHP Switcher"
date: 2017-12-11T22:14:54-05:00
tags:
- php
- brew
- switch
- link
- bash
- script
---
Recently I've been working with PHP applications in varying states of modernity/antiquity, and very regularly have to switch the current PHP version to accomodate the PHP flavors of the day. Homebrew un/link commands are super simple and at this point all I want is to be able to switch the PHP version with a single command. With a little bit of searching, I found a script that comes pretty close to what I need:

{{< gist w00fz 142b6b19750ea6979137b963df959d11 >}}

I made a fork, and then removed Apache stuff and unused code, converted conditionals to guard clauses, ran the remainder through `shellcheck`, and addressed a couple of minor consistency/grammar issues to achieve the following result:

{{< gist nhoag 33504e22c922d9b035c6d7be32f8f0ac >}}

