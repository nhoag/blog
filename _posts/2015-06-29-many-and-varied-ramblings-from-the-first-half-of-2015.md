---
layout: post
title: "Many and Varied Ramblings From the First Half of 2015"
modified:
categories:
description:
tags:
- redis
- docker
- ebird
- nodejs
- boxen
- drupal
image:
  feature: turtle-back.jpg
  credit: Nathaniel Hoag
  creditlink: https://www.flickr.com/photos/n8nl/17149059859/in/datetaken/
comments:
share:
date: 2015-06-29T11:42:27-04:00
---

The last six months have been very full with the arrival of our first baby and all the prep work and new responsibilities that go with being a new parent. Here and there I've managed to squeeze in little hobby projects. Much to my astonishment, I also won the [!!Con](http://bangbangcon.com/) attendance lottery(!!), and had an amazing few days in NYC.

### !!Con

!!Con was an extremely fun conference, and I consider myself so lucky to have won the attendance lottery. The topics were diverse and quirky, but consistently deep and informative. Enough cannot be said for the specialness of !!Con and the focus on inclusivity, accessibility, and openness. I was going to try to highlight a few presentations, but reviewing the [conference program](http://bangbangcon.com/program.html) I'm reminded of so many awesome talks. So once this year's videos are available, maybe a random !!Con video selector will be in order :)

### Nodejs Twitter Bots

Before the baby arrived, I feverishly built up a [fleet of Twitter bots](https://twitter.com/n8nl/lists/notablebirds) that pull notable bird sightings from the [eBird API](https://confluence.cornell.edu/display/CLOISAPI/eBird+API+1.1) and post them to Twitter. This has been a fun project with some interesting challenges.

Below is a list of source repos for the bird bots:

- [Bird Bot](https://github.com/nhoag/notable-birds)
- [Bot Container](https://github.com/nhoag/docker-nbirds)
- [Bot Config](https://github.com/nhoag/nbirds-cfg)

The bots are built on [Nodejs](https://nodejs.org/) backed by [Redis](http://redis.io/), all in [Docker](https://www.docker.com/) containers on a single [Digital Ocean](https://www.digitalocean.com/) droplet. Each bot is associated with a particular state in the US. I started out naively running a couple of bots as concurrent Nodejs containers. This worked great for a while, but as the bot population increased, system stability took a nose dive. I considered a hardware upsize, but since this is a hobby project I opted to reduce the memory requirements of the fleet instead.

I noticed that some of the bots were more active, and would store a greater amount of data. My first idea was to slim down the data for some of the active bots by reducing the window of time they'll consider a sighting as valid. This helped a bit, but didn't get to the heart of the issue - ***lots of concurrent Nodejs instances consuming all the available memory***.

The really big gain came with moving from persistent to ephemeral Nodejs containers. I started out with the Nodejs app keeping track of the time interval between queries to the eBird API. This meant each bot was crowding up the memory space with Nodejs. I could have stayed with this model, and rebuilt the app to run multiple bots per Nodejs instance, but there is a simpler approach.

Rather than managing time intervals with Nodejs, the whole system can be run from crontab at a much lower cost. Following is an example cronjob that will fire up an image, query eBird, process the data, post to Twitter, update Redis, log errors to a persistent file on the host, and then remove the container on exit:

```bash
*/30 * * * * sudo /usr/bin/docker run --name nbirds-id --rm=true -v /data/nbirds/ID:/var/log/nbirds --link redis:redis nbirds:id
```    

The script completes in 1-2 seconds, which means there's now a lot of idle on the server, and headroom for a whole lot more bots! One remaining item to address with continued scaling will be to split out Redis to a separate server instance, as the data will eventually outgrow the available memory even with slimming the tracked time range for bots.

### Provisioning for Productivity

Another recent project is a [Development Base](https://registry.hub.docker.com/u/nhoag/dev-base/) container image. The idea is that the image will have all of my favorite tools and configurations for developing software, so starting up a new project on an unfamiliar machine will be extremely fast (assuming Docker). I also recently started using [Boxen](https://boxen.github.com/), which facilitates automated provisioning of a Mac computer. At first, I was dismissive of Boxen in comparison to the speed of deploying containers. But in digging into Boxen a bit, I've come around to a new perspective. Given the current landscape of provisioning options, Boxen is a great resource for getting a Mac into a desired base state with apps and configuration. While it may be excellent for big teams or small elite teams, I wouldn't recommend Boxen where there is a lack of dedicated resources for maintenance and/or mentorship.

Tying Boxen back to Docker, you'll want to have a look at the following pull request to use `boot2docker` on OSX:

- [Upgrade to 4.3.28](https://github.com/boxen/puppet-virtualbox/pull/40)

### Docker Drupal Onbuild

Another project I've been piecing together is an [onbuild image](https://registry.hub.docker.com/u/nhoag/drupal/) based on the [official Drupal Docker image](https://registry.hub.docker.com/_/drupal/). 'Onbuild' has become a standard option for many official images but doesn't yet exist for Drupal. Beyond relying on `drush site-install`, another good option would be to work up a code volume share between the host and guest machines, but there are as yet unresolved issues with this approach:

- [https://github.com/boot2docker/boot2docker/issues/581](https://github.com/boot2docker/boot2docker/issues/581)
- [https://github.com/boot2docker/boot2docker/issues/587](https://github.com/boot2docker/boot2docker/issues/587)

That's all for this installment!
