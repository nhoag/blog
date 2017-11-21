---
categories: null
comments: null
date: 2016-09-08T21:53:20Z
description: null
share: null
tags:
- vim
- multiple
title: Execute Multiple Commands in Vim
url: /blog/2016/09/08/execute-multiple-commands-in-vim/
---

Today I needed to perform multiple transforms on a chunk of text in a file and found a nice solution in Vim! Initially I was thinking about `VISUAL` mode in Vim and chaining transforms the way I would do with `sed` (i.e. `s/one/two/g;s/^/  /;s/$/,/`). It turns out this doesn't exactly work in Vim, but it's not too far off the mark.

The following syntax works in Vim `NORMAL` mode:

```vim
:%s/^/  / | %s/string/replace/g | %s/$/,/
```

And in `VISUAL` mode, the sytax is slightly different. Select a bunch of lines to operate on, and then use the following:

```vim
:'<,'>s/^/  / | :'<,'>s/string/replace/g | :'<,'>s/$/,/
```
