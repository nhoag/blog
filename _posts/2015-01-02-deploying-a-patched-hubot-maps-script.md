---
layout: post
title: "Deploying a Patched Hubot Maps Script"
modified:
categories: 
description:
tags:
- hubot
- maps
- patch
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2015-01-02T13:40:48-05:00
---

In deploying [Hubot](https://hubot.github.com/) for the first time, you may encounter the following error:

```
ERROR ReferenceError: fillAddress is not defined
  at TextListener.callback (/path/to/bot/node_modules/hubot-maps/src/maps.coffee:58:16, <js>:57:18)
</truncated>
```

At the time of this writing, running a `grep` in the [Hubot Maps](https://github.com/gkoo/hubot-maps) source code shows a single instance of the function and no function definition:

```bash
grep -rn fillAddress .
./src/maps.coffee:58:    location = fillAddress(msg.match[3])
```

Stepping back a level to `grep` all of Hubot and scripts yields the same result as above.

Running a Google search for `hubot maps fillAddress` gives [one promising hit](https://github.com/gkoo/mybot/blob/master/scripts/maps.coffee). Looking at this code, we can see that `fillAddress()` is defined!:

```coffee
  fillAddress = (address) ->
    if (address.match(/borderlands/i))
      return '1109 Pebblewood Way, San Mateo, CA'
    else if (address.match(/hhh/i))
      return '516 Chesterton Ave, Belmont, CA'
    else if (address.match(/airbnb/i))
      return '888 Brannan St, San Francisco, CA'

    return address
```

But do we need this function defined, or do we need to remove the reference? All the function does is to provide a system for aliasing particular addresses to a human-friendly reference. So by typing `hubot map me hhh` we should actually get back the coordinates for '516 Chesterton Ave, Belmont, CA'. This is a nice idea, but definitely not necessary for my purposes.

Back to Hubot Maps, there is an [open pull request](https://github.com/gkoo/hubot-maps/pull/3) that addresses this issue by removing the remaining `fillAddress()` reference that's causing the error (while adding support for Japanese characters). This PR hasn't yet been merged into Hubot Maps, but we can still benefit from the fix.

Here's one way to deploy a patched script to Hubot:

1. Fork hubot-maps
2. Deploy the patch to your fork
3. Tag your fork (i.e. 0.0.1p) - `git tag 0.0.1p && git push --tags`
4. Reference your forked version of hubot-maps in `package.json`:

```json
...
    "hubot-maps": "https://github.com/USERNAME/hubot-maps/archive/0.0.1p.tar.gz",
...
```

Now when you run `npm install`, npm will pull in the patched script.

And subsequently firing up Hubot and asking for a map shows success:

```
./bin/hubot
# No error! \o/
```

[![Hubot map me Boston]({{ site.url }}/images/hubot_map-me.png)](http://maps.google.com/maps/api/staticmap?markers=boston&size=400x400&maptype=roadmap&sensor=false&format=png)
