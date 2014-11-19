---
layout: post
title: "GoAccess for Log Analysis"
date: 2013-08-31 21:54
comments: true
tags: 
- goaccess
- access.log
- analysis
- report
---
An excellent log analysis tool that I picked up recently from a blog post by my colleague, [Amin Astaneh](http://www.aminastaneh.net/), is the [GoAccess](http://goaccess.prosoftcorp.com/) interactive web log analyzer. Out of the box, you can unleash GoAccess on raw or piped log data to reveal an array of interesting traffic patterns that might otherwise take some serious piping skills to crack - I covered some of these in a [recent blog post](/blog/2013/08/24/fun-with-accesslog/).

Working at [Acquia](http://www.acquia.com/), we do diagnostic work with log files across lots of servers, web applications, and stack technologies. To aid our efforts at log analysis, I started a GoAccess [shell plugin](https://github.com/nhoag/goaccess-plugin) to enable traversing various servers and types of log files using aliased GoAccess commands over secure ssh tunnels.

At first I was a little disappointed at the limitations of the GoAcess project, but the simplicity leaves a lot of room for extensibility.
