---
title: "Saved by Layered Docker Images"
date: 2018-02-04T22:18:38-05:00
tags:
- docker
- hobby
---
Several years ago, I created a fleet of bots that pull data from one API and post to another API. Over the years, the bots have needed various interventions to get them back up and running, but I've shied away from upgrading underlying technologies. Thankfully, when I put these bots together, I used a system of layered Docker builds. I didn't remember having done this, but after a quick review it became clear that this update was going to be easy.

Regarding the layered Docker builds, I had started with my own custom base image, then built the framework dependency, followed by the application image, and then finally a `Dockerfile` for app configuration. In this case, I needed to convert use of http to https in the application layer, as http support was removed from one of the APIs. After updating the app, I rebuilt the application image from the latest app release, and then rerolled the individual bot configurations on top.

I didn't need to touch the framework image, which is fortunate because the framework version used is no longer available through supported channels. The level of effort would have gone up significantly if I didn't have a ready custom-built image with the needed version. I highly recommend doing this layered image approach if you have toy projects you can't poor loads of time and effort into updating and maintaining. It's slightly more work up front, but will provide a stable bedrock for future project iteration.
