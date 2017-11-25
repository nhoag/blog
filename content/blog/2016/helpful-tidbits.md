---
categories: null
comments: null
date: 2016-09-04T13:51:59Z
description: null
share: null
tags:
- less
- wc
- hide
- toggle
title: Helpful Tidbits
url: /blog/2016/09/04/helpful-tidbits/
---

Below is a smattering of helpful tidbits from the last several months.

### less

Case-insensitive search: Add `-i` to your `LESS` environment variable

### Drupal

Hide fieldgroups with all child fields: `field_group_hide_field_groups($form, array('field_group_name'));`

### OS X

"Disable" the dock by setting a long autohide delay: `defaults write com.apple.dock autohide-delay -float 5`

Clear the clipboard: `pbcopy </dev/null`

### wc

Consider the following:

```bash
# 'HELLO' + newline
echo HELLO | wc -m
6
# Just 'HELLO'
echo -n HELLO | wc -m
5
```

### Google Hangout

* Toggle camera: ⌘ + e
* Toggle microphone: ⌘ + d

Much better than using a mouse!

### Vim

* Toggle the case of characters in a word: `g~iw`.
* Show all whitespace characters: `:set list`
* Replace a character with a newline: Use `\r` instead of `\n`
* Delete all lines that match a pattern: `:g/pattern/d`
