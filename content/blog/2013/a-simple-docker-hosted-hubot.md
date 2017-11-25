---
comments: true
date: 2013-09-30T00:00:00Z
tags:
- hubot
- docker
- container
- nodejs
title: A Simple Docker-hosted Hubot
url: /blog/2013/09/30/a-simple-docker-hosted-hubot/
---

I've been playing with Hubot a bit lately, and decided to up the ante on the endeavor by creating a [Hubot Docker container](https://github.com/nhoag/doc-bot). There were a couple of misadventures before landing on a stable source container from which it will now be crazy easy to extend and deploy.

I set up [Docker](http://www.docker.io/) using the instructions [here](http://docs.docker.io/en/latest/installation/vagrant/).

You may notice from reviewing the [Dockerfile](https://github.com/nhoag/doc-bot/blob/master/Dockerfile) that line 6 imports a 'Universe' apt source. This is to support dependencies associated with installing a newer version of [Node.js](http://nodejs.org/) (v0.10.19) in a container. To facilitate deployment speed, the container doesn't include this repository by default. Further down on line 9, [another apt repository](https://launchpad.net/~chris-lea/+archive/node.js/) is added to point to a newer Node.js package. You can find more information about this [here](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#ubuntu-mint-elementary-os).

The Dockerfile includes several different conventions, including RUNning commands, and ADDing files and ENVironment variables to the container.

I had initially tried setting up an [S3](http://aws.amazon.com/s3/) Brain with the aws2js Hubot script. I got it working several times, but ultimately found the npm package handling for this and a few other Hubot scripts to be far too brittle to recommend currently. Most often, package retrieval would hang, fail, or occasionally fail silently :/ In each case the following error would appear:

```
Error: Cannot find module 'aws2js'
```

