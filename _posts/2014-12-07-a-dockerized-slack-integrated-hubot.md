---
layout: post
title: "A Dockerized and Slack-integrated Hubot"
modified:
description:
tags:
- docker
- slack
- hubot
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2014-12-07T14:06:01-05:00
---

A little over a year ago, I wrote a quick [blog post](http://nathanielhoag.com/blog/2013/09/30/a-simple-docker-hosted-hubot/) about deploying Hubot with Docker. A lot has changed with Hubot and Docker since that time, so I decided to revisit the build.

The new implementation I whipped up consists of three main components:

1. [Yeoman-generated Hubot](https://github.com/nhoag/bot)
2. [Base Docker image](https://registry.hub.docker.com/u/nhoag/hubot/)
3. [Dockerfile](https://github.com/nhoag/bot-cfg) for configuring Hubot

The [Hubot 'Getting Started'](https://github.com/github/hubot/blob/7562e245eb5fe229fc861bfe870c6117ae36093f/docs/README.md) instructions walk us through generating a deployable Hubot with [Yeoman](http://yeoman.io/). Once generated, the code can be stashed away somewhere until we're ready to pull it into a Docker image. In this case I committed the code to Github.

Now that we have a bot defined, we can build a new Docker image to deploy and run the bot. The [base Docker image](https://github.com/nhoag/doc-bot/blob/277de8a21677fd167d808547eeae040c4d7ee1bc/Dockerfile) (below) installs [Node.js](http://nodejs.org/), pulls in our `bot` repo, and runs `npm install`, but notice we're not deploying any configuration yet:

```bash
# DOCKER-VERSION  1.3.2

FROM ubuntu:14.04
MAINTAINER Nathaniel Hoag, info@nathanielhoag.com

ENV BOTDIR /opt/bot

RUN apt-get update && \
  apt-get install -y wget && \
  wget -q -O - https://deb.nodesource.com/setup | sudo bash - && \
  apt-get install -y git build-essential nodejs && \
  rm -rf /var/lib/apt/lists/* && \
  git clone --depth=1 https://github.com/nhoag/bot.git ${BOTDIR}

WORKDIR ${BOTDIR}

RUN npm install
```

Anyone can use or modify the build to create their own Docker images:

```bash
git clone git@github.com:nhoag/doc-bot.git
# Optionally edit ./doc-bot/Dockerfile
docker build -t="id/hubot:tag" ./doc-bot/
docker push id/hubot
```

At this point, we have an image ready to go and just need to sprinkle in some configuration to make sure our bot is talking to the right resources. This is where we'll make use of the [bot-cfg](https://github.com/nhoag/bot-cfg) repo, which contains yet another [Dockerfile](https://github.com/nhoag/bot-cfg/blob/713820474f584587516d503fcb331de773a96c18/Dockerfile):

```bash
# DOCKER-VERSION        1.3.2

FROM nhoag/hubot
MAINTAINER Nathaniel Hoag, info@nathanielhoag.com

ENV HUBOT_PORT 8080
ENV ADAPTER slack
ENV HUBOT_NAME bot-name
ENV HUBOT_GOOGLE_API_KEY xxxxxxxxxxxxxxxxxxxxxx
ENV HUBOT_SLACK_TOKEN xxxxxxxxxxxxxxxxxxxxx
ENV HUBOT_SLACK_TEAM team-name
ENV HUBOT_SLACK_BOTNAME ${HUBOT_NAME}
ENV PORT ${HUBOT_PORT}

EXPOSE ${HUBOT_PORT}

WORKDIR /opt/bot

CMD bin/hubot -- --adapter ${ADAPTER} --name ${HUBOT_NAME}
```

Here we're extending the public `nhoag/hubot` image created earlier by adding our private credentials as environment variables. Once this is populated with real data, the last steps are to build and run the updated image.

Below is the full deployment process that should give you a new Slack-integrated Hubot:

1. `docker pull nhoag/hubot`
2. `git clone git@github.com:nhoag/bot-cfg.git`
3. `vi ./bot-cfg/Dockerfile` (configure `ENV`s)
4. `docker build -t="nhoag/hubot:live" ./bot-cfg/`
5. `docker run -d -p 45678:8080 nhoag/bot:live`
6. Add public Hubot address to your Slack Hubot Integration (i.e. http://2.2.2.2:45678/)

Happy chatting!
