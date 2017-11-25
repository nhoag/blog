---
comments: null
date: 2014-11-23T18:03:26Z
description: null
share: 3
tags:
- drupal
- flamegraph
- fast_404
title: Flame Graphs Show Why Fast 404 Is Important for Drupal Performance
url: /blog/2014/11/23/flamegraphs-show-why-fast-404-is-important-for-drupal-performance/
---

The [Fast 404](https://www.drupal.org/project/fast_404) Drupal contributed module project page provides a lot of context for why 404s are expensive in Drupal:

> ... On an 'average' site with an 'average' module load, you can be looking at 60-100MB of memory being consumed on your server to deliver a 404. Consider a page with a bad .gif link and a missing .css file. That page will generate 2 404s along with the actual load of the page. You are most likely looking at 180MB of memory to server that page rather than the 60MB it should take.

The explanation continues to describe how Drupal 7 has a rudimentary implementation for reducing the impact of 404s. You may have seen the below code while reviewing `settings.php`:

``` php
<?php
$conf['404_fast_paths_exclude'] = '/\/(?:styles)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';
```

But wouldn't it be nice to actually ***see*** the difference between all of these implementations? Thanks to the magic of open source, we can!

Nearly a month ago now, Mark Sonnabaum posted a [Gist](https://gist.github.com/msonnabaum/c8902d5000d892ba121b) with instructions for generating flame graphs from XHProf-captured Drupal stacks. The [technique](https://github.com/msonnabaum/xhprof-flamegraphs) converts XHProf samples to a format that can be read and interpreted by Brandan Gregg's excellent [FlameGraph](https://github.com/brendangregg/FlameGraph) tool.

I set up a local Drupal site in three 404 configurations (unmitigated, default 404, Fast 404) and tested them one at a time. One difficulty with testing is that the default XHProf sample rate is 0.1 seconds. This was plenty for unmitigated 404s, but I had to make a lot of requests to capture a stack with the Fast 404 module in place.

The flame graph screenshots below corroborate what we would expect, with unmitigated 404s being the tallest stack of the bunch, the Drupal core 404 implementation showing a favorable reduction, and Fast 404 showing the shortest stack. We can also extrapolate that adding various contrib modules will push the stacks even higher with unmitigated 404s.

***Click each image below for an interactive flame graph.***

### Unmitigated 404s

[![Unmitigated 404 Flame Graph](/images/flamegraph/unmitigated_404.png)](/flamegraph/unmitigated_404.svg)

### Drupal Core 404 Implementation

[![Drupal 404 Flame Graph](/images/flamegraph/core_404.png)](/flamegraph/core_404.svg)

### Fast 404

[![Fast 404 Flame Graph](/images/flamegraph/fast_404.png)](/flamegraph/fast_404.svg)
