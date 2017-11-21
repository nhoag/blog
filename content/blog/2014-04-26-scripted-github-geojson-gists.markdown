---
comments: true
date: 2014-04-26T21:58:34Z
tags:
- github
- gist
- geojson
- jq
- ebird
title: Scripted Github GeoJSON Gists
url: /blog/2014/04/26/scripted-github-geojson-gists/
---

Below is a Github [Gist](https://gist.github.com/nhoag/9995803) with a map comprised of [GeoJSON](http://geojson.org/) data, along with the bash command that was used to create it.

Github automatically generates maps for GeoJSON files in Gists and repositories. This is well documented at the following article: https://help.github.com/articles/mapping-geojson-files-on-github

The map below pulls data from [eBird API](https://confluence.cornell.edu/display/CLOISAPI/eBird+API+1.1), transforms the data structure into GeoJSON format using [jq](http://stedolan.github.io/jq/), and then POSTs to a Github Gist.

<script src="https://gist.github.com/nhoag/9995803.js"></script>
