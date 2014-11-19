---
layout: post
title: "Fun with access.log"
date: 2013-08-24 12:02
comments: true
tags: 
- piping
- bash
- cli
- stream
---
With analyzing data sets and performing repetitive (and tedious) tasks, piping streams in the terminal can save a ridiculous amount of manual labor and time. Following are a few examples that I use in diagnosing and resolving various types of problems with web applications.

Assuming log entries in the following format:

```
1.1.1.1 - - [24/Aug/2013:12:55:30 +0000] "GET / HTTP/1.0" 200 2227 "-" "USER AGENT STRING" vhost=vhost.example.com host=example.com hosting_site=docroot request_time=5640229
```

### Number of Requests

``` bash Number of requests in a given half hour in 10-minute increments
$ for i in {0..2} ; do echo "-- 10:$i""x UTC --" ; grep -c "2013:10:$i" access.log ; echo -e "\n" ; done
```

__Results:__
<pre>
-- 10:0x UTC --
494

-- 10:1x UTC --
458

-- 10:2x UTC --
446
</pre>

### HTTP Response Codes

``` bash Sort HTTP response codes in a given half hour in 10-minute increments
$ for i in {0..2} ; do echo "-- 10:$i""x UTC --" ; grep "2013:10:$i" access.log | cut -d\" -f3 | awk '{print $1}' | sort | uniq -c | sort -nr ; echo -e "\n" ; done
```

__Results:__
<pre>
-- 10:0x UTC --
 337 200
 108 302
  31 304
  11 301
   7 404

-- 10:1x UTC --
 283 200
 110 302
  39 301
  21 304
   5 403

-- 10:2x UTC --
 280 200
 116 302
  46 301
   2 404
   2 403
</pre>

### Most Requested URIs
```bash Most-requested URIs in a given half hour in 10-minute increments
for i in {0..2} ; do echo "-- 10:$i""x UTC --" ; grep "2013:10:$i" access.log | cut -d\" -f2 | awk '{print $2}' | cut -d\? -f1 | sort | uniq -c | sort -nr | head -n 5 ; echo -e "\n" ; done
```

__Results:__
<pre>
-- 10:0x UTC --
  64 /example/one
  48 /example/two
  32 /example/three
  16 /example/four
   9 /example/five

-- 10:1x UTC --
  62 /example/two
  55 /example/three
  30 /example/six
  27 /example/one
  20 /example/four

-- 10:2x UTC --
  58 /example/one
  34 /example/three
  33 /search
  31 /rss.xml
  27 /example/two
</pre>

### Most Active IPs

``` bash Most active IPs in a given half hour in 10-minute increments
for i in {0..2} ; do echo "-- 10:$i""x UTC --" ; grep "2013:10:$i" access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 5 ; echo -e "\n" ; done
```

__Results:__
<pre>
-- 10:0x UTC --
 145 1.1.1.1
  73 2.2.2.2
  29 3.3.3.3
  25 4.4.4.4
  13 5.5.5.5

-- 10:1x UTC --
 153 1.1.1.1
  76 3.3.3.3
  32 5.5.5.5
  29 2.2.2.2
  18 4.4.4.4

-- 10:2x UTC --
 131 2.2.2.2
  61 4.4.4.4
  38 5.5.5.5
  34 3.3.3.3
  10 1.1.1.1
</pre>

