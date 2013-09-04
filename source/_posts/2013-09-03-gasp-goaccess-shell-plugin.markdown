---
layout: post
title: "GASP: GoAccess Shell Plugin"
date: 2013-09-03 23:33
comments: true
categories: 
- GoAccess
- plugin
- shell
---
I made some good progress on the [GoAccess plugin](https://github.com/nhoag/goaccess-plugin) over the past few days. Many of the kinks have been ironed out and making access.log reports has never been so easy :)

It's a pretty simple plugin, but it does the job well. My favorite parts of the script are a fun bit of regex that's just aesthetically pleasing, the awk date filter, and the overall flow of execution.

``` bash Fun Regex
yes='^1$|^([y|Y]([e|E][s|S])?)$'
```

``` bash awk Date Filter
cmDATE=`date -u -v-"$goINTVAL"H +\[%d/%b/%Y:%H:%M:%S` # OSX date command format (-v).
    ssh -F $HOME/.ssh/config "$goSRV" \
        "sudo awk -v Date=$cmDATE '\$4 > Date { print \$0 }' /var/log/$tech/$file"
```
