---
layout: post
title: "GoAccess Shell Plugin Revamped"
date: 2013-09-08 14:09
comments: true
categories: 
- GoAccess
- bash
- getopts
- refactor
---
I made a bunch of big changes to the [GoAccess shell plugin](https://github.com/nhoag/goaccess-plugin) including improved argument handling, greater agnosticism, and greater configurability with time filtering. I converted the plugin from sourced script to regular bash script. This meant the script components had to be ordered into a sequential configuration, but this also makes the script more portable and easier to fire up.

The script options now support short and long call values, courtesy of [Stack Overflow](http://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options). So the log file location can be designated with either -l or --location. and the same is true of each option. I also made the options more intuitive to use by ensuring that options such as --report and --open can be called without having to pass an associated extra value such as '1' or 'yes'.

The time filter defaults to showing results for the past hour, but this can be altered in various ways. You could specify that you want results from 3 hours ago with -b3. By default, the end value is 'now', but this can also be customized by passing -d10M to specify that results should span a 10-minute period following the start time. Time units and integer values are parsed with regex and sed, respectively.

Many of the big changes were made over the course of several hours at a location where I was unable to iteratively test. It was a bit scary to diverge so far from a working copy of the script, but in the end I think it allowed me to be more adventurous with the direction of the scipt. The subsequent debugging wasn't as involved as I had anticipated.

The remaining TODOs are to add support for parallel remote connections, compression support for gzipped log files, and support for filtering by arbitary UTC (HH:MM) time values.
