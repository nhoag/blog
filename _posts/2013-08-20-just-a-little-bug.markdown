---
layout: post
title: "Just a Little Bug"
date: 2013-08-20 20:00
comments: true
tags: 
- bug
- zsh
- noglob
- alias
---
It's an old bug but a tiny stumbling block for zsh users who are new to Jekyll/Octopress. On submitting the following command I was getting a silly error in response.

Command:

```
$ rake new_post["First Post\!"]
```

Error:

```
zsh: no matches found: new_post[First Post!]
```

I ultimately ended up [here](https://github.com/imathis/octopress/issues/117#issuecomment-3707975).

Escapes are fine, but I decided to go with the "noglob" alias in .zshrc given that it's difficult enough to write on a regular basis :)
