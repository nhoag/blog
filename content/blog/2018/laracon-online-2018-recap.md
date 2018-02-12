---
title: "Laracon Online 2018 Recap"
date: 2018-02-08T21:40:37-05:00
tags:
- laravel
- php
- symfony
- laracon online
- vuejs
- eloquent
---
I recently attended [Laracon Online 2018](https://laracon.net/) and got a lot out of it! I happened to see a [tweet](https://twitter.com/sandimetz/status/948226539371532288) about early bird tickets in January and couldn't pass up the opportunity. I've admittedly been sheltered in [Drupal](https://www.drupal.org/)/[Symfony](https://symfony.com/) over the last several years, and it was a bit of a shock to see the popularity and rich features of [Laravel](https://laravel.com/) (like [Rails](http://rubyonrails.org/) for [PHP](http://www.php.net/)). The presenters were knowledgable, practiced, and engaging. The format flowed well and was expertly M.C.'d by [Ian Landsman](https://twitter.com/ianlandsman). I've come away with a lot to mull over, and following are some thoughts, takeaways, and references.

It was nice for so many reasons to be able to attend a conference from my home! It's tough to travel right now with two young kids, and this format makes it possible to get a conference experience without sacrificing family obligations. It's kinda surprising to me that it's not more common, or offered as a cheaper option for in-person conferences.

The conference used a [Discourse](https://www.discourse.org/) instance for chat, which seemed like a good choice. I heard grumblings about the lack of a [Slack](https://slack.com/) channel (some folks managed to assemble on Slack anyway), but I didn't feel like I needed anything more. The Discourse site is easy to navigate and will be available for a year. The conference was broadcast via [Zoom](https://zoom.us/), which was solid throughout, with a minor exception of slow-down/speed-ups on one presentation. Thanks to [@ianlandsman](https://twitter.com/ianlandsman) for showcasing Zoom green screen capability (TIL)!

I started out taking some notes, but soon learned that [Michael Roderick](https://twitter.com/rodericktech) was sharing much more detailed conference notes in a [Github repo](https://github.com/rodericktech/laracon-online-2018-notes) (including code snippets and diagrams!). Thanks! Nicely done.

The talks spanned a range of topics, from front-end to back-end, with a good dose of "human experience" sprinkled in. [Adam Wathan](https://twitter.com/adamwathan) kicked things off with a nail-biter of a live coding presentation demonstrating a [Vue.js](https://vuejs.org/) component refactor. [Steve Schoger](https://twitter.com/steveschoger) demonstrated modern design principles through transforming a typical app design to be more streamlined and professional. [Taylor Otwell](https://twitter.com/taylorotwell) walked through contributions from the newly minted Laravel 5.6 (complete with attributions), and the proprietary Spark project. [Chris Fidao](https://twitter.com/fideloper) reviewed common bottlenecks and solutions when scaling Laravel apps. [Wes Bos](https://twitter.com/wesbos) discussed modern and upcoming Javascript features. [Jonathan Reinink](https://twitter.com/reinink) gave a fast-paced live coding demo of implementing increasingly complex [Eloquent](https://laravel.com/docs/eloquent) queries without sacrificing performance. [Sandi Metz](https://twitter.com/sandimetz) gave a moving talk on the common element of effective teams. [Matt Stauffer](https://twitter.com/stauffermatt) ended the day with a compelling reminder to have fun!

Some big takeaways from the conference (for me):

* Presenters were mostly using [Sublime Text](https://www.sublimetext.com/) (`o_O?`) and getting it done!
* Look out for the "n+1" performance problem, and remedy with [Eager loading](https://stackoverflow.com/a/1299381)
* Psychological safety is crucial to effective engineering/teamwork
* I need a frontend project so I can flex my Javascript muscles
* Laravel (software, popularity, momentum) is HUGE

A few small critiques:

* A nice enhancement to the current conference setup would be to include a stenographer for real-time captions and improved accessibility
* I would love to see a more diverse group of speakers
* I saw at least one image that didn't belong in a professional presentation

Coming from the Drupal/Symfony world, it was awesome to get a window into another realm of PHP. Laravel is definitely something I'll be evaluating more fully, and Laracon Online has provided a number of reference pointers for learning more about the framework.

