---
title: "Debugging Drupal With Docker"
date: 2017-12-27T21:45:55-05:00
tags:
- Docker
- Drupal
- Docker4Drupal
---
This week I had occasion to help resolve a customer support case. As part of troubleshooting, I stood up a local copy of the site using [Docker4Drupal](https://github.com/wodby/docker4drupal). This worked out really well, and I'd like to take a moment to discuss some of the benefits.

It initially took a little time to configure the site with Docker4Drupal, and to get XDebug linked up. But I'm sure that if I were doing this regularly, this would have been no more than a few minutes. Once Docker4Drupal was in place, it was incredibly easy and cheap to burn down my local copy of the site and start fresh. Two commands to get back to the initial state (with maybe a little lag for database population):
```bash
docker-compose down
docker-compose up
```

Another perk is distributed reproducibility with troubleshooting. With a `docker-compose.yml` and a few other assets, anyone can spin up their own copy of the site to dig in and contribute to solving a problem. Each site build will be functionally equivalent, so it's fairly assured that everyone is seeing the same issue.

The speed benefits hinge a bit on a site being amenable to quick standup. Large database size can be mitigated somewhat through clever host:guest volume management, but the larger a database the more beneficial it will be to generate a slimmed down development copy from production (perhaps as a daily task - wink wink nudge nudge).

Using Docker4Drupal, I was also able to quickly compare the site build to a vanilla Drupal installation with a minimal set of contrib modules for reproducing the issue. [simplytest.me](https://simplytest.me/) is another option here, but Docker4Drupal is comparatively faster and more configurable (especially with regard to memory and CPU allocation).

That's all for this installment. I hope this is sufficiently convincing for everyone to include Docker4Drupal assets in their Drupal repos. Happy troubleshooting!

