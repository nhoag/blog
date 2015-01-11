---
layout: post
title: "Hubot With a Redis Brain on Docker"
modified:
categories: 
description:
tags:
- docker
- hubot
- redis
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2015-01-10T15:59:18-05:00
---

![Hello, Hubot.](/images/hubot.png)

I've written previously about [deploying Hubot on Docker](/blog/2014/12/07/a-dockerized-slack-integrated-hubot/), [deploying patched Hubot scripts](/blog/2015/01/02/deploying-a-patched-hubot-maps-script/), and [bechmarking mass inserts with a Redis Docker container](/blog/2015/01/03/redis-tangent/). In this post, I'll cover how to link a Hubot Docker container to a Redis Docker container to equip Hubot with persistent memory.

As an overview we're going to:

1. Spin up a Redis Docker container with a host directory mounted as a data volume
2. Spin up a linked Hubot Docker container that will use Redis as a persistent brain

For my most recent post on Redis mass inserts, I created a [basic Redis Docker image](https://registry.hub.docker.com/u/nhoag/redis/) that satisfies all of the requirements to be used as a Hubot Redis brain. We'll bring this up now:

```bash
$ docker run --name redis -v /host/dir:/data -d nhoag/redis
3fc0b9888d5428f01ad13a26d1390904d58b9a34a76ce9965469694307781e3b
$ docker ps -a
CONTAINER ID        IMAGE                COMMAND                CREATED             STATUS              PORTS               NAMES
3fc0b9888d54        nhoag/redis:latest   "redis-server /etc/r   8 seconds ago       Up 7 seconds        6379/tcp            redis
```

In the above `docker run`, the Redis container is named as 'redis', and a directory from the host is mounted as a volume in the Docker container. By mounting a directory from the host as a volume on the guest, we can now retain Redis backup data through a container failure or reprovision. You can get a sense for this by adding a file on the host, editing from the guest, and viewing the change back on the host:

```bash
$ echo "Host" > /host/dir/test.txt
$ docker exec -it redis sh -c 'echo "Guest" > /data/test.txt'
$ cat /host/dir/test.txt
Guest
```

Next up, we need a suitable Hubot Docker image. I previously assembled a Hubot Docker image that almost meets our requirements. As stated on the [Hubot Redis Brain](https://www.npmjs.com/package/hubot-redis-brain) page on NPM:

> hubot-redis-brain requires a redis server to work. It uses the `REDIS_URL` environment variable for determining where to connect to. The default is on localhost, port 6379 (ie the redis default).

> The following attributes can be set using the `REDIS_URL`

> * authentication
> * hostname
> * port
> * key prefix

> For example, export `REDIS_URL=redis://passwd@192.168.0.1:16379/prefix` would authenticate with `password`, connecting to 192.168.0.1 on port 16379, and store data using the `prefix:storage` key.

Let's spin up the old Hubot image without any modifications to scout out what needs to change. I'm using the same build process outlined in my previous post, [A Dockerized and Slack-integrated Hubot](/blog/2014/12/07/a-dockerized-slack-integrated-hubot/), where I've defined a base Hubot image into which I'll sprinkle some additional configuration in order to connect to various services:

```bash
$ git clone git@github.com:nhoag/bot-cfg.git && cd bot-cfg
# Add credentials to ./Dockerfile
$ docker build -t="my-bot" .
$ docker run -d -p 45678:8080 --name bot --link redis:redis my-bot
$ docker exec -it bot env | grep "^REDIS_PORT"
REDIS_PORT=tcp://172.1.2.3:6379
REDIS_PORT_6379_TCP=tcp://172.1.2.3:6379
REDIS_PORT_6379_TCP_ADDR=172.1.2.3
REDIS_PORT_6379_TCP_PORT=6379
REDIS_PORT_6379_TCP_PROTO=tcp
```

From the above environment variables, there are a lot of options for defining a connection to the Redis container, but the easiest option is to use `REDIS_PORT` since it has everything we need and can be used as-is. [With one new line](https://github.com/nhoag/bot/commit/769d044262faeee13c90c1a98d6c90c6a816470a) added to the [bot repo](https://github.com/nhoag/bot) (which gets pulled into the Docker image defined [here](https://github.com/nhoag/doc-bot)), we have a Hubot that can automatically talk to Redis on start-up.

Here is the addition to `bin/hubot` for reference:

```bash
export REDIS_URL="${REDIS_PORT}"
```

After rebuilding the base Hubot image and `my-bot`, we now have a suitable Hubot Docker image to auto-connect to our running Redis container.

Let's spin up the updated Hubot:

```bash
# Don't forget to rebuild the my-bot image from the updated Hubot
$ docker run -d -p 45678:8080 --name bot --link redis:redis my-bot
```

To verify that Hubot is connected, let's attach to the running Redis container and review with `redis-cli`:

```bash
$ docker exec -it redis redis-cli -h 3fc0b9888d54
3fc0b9888d54:6379> SCAN 0
1) "0"
2) 1) "hubot:storage"
```

Success!!
