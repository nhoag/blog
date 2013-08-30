---
layout: post
title: "Puppet Power Up"
date: 2013-08-29 19:26
comments: true
categories: 
- puppet
- n00b
- vagrant
- ubuntu
---
I've dabbled with, attended presentations for, and read about configuration management systems for quite a while. For at least the past year, every time I start up a new project I can't help but think about all of the benefits that would ensue from wrapping my work in a managed server configuration. I decided recently to bite the bullet and dive into Puppet head.

In getting started, and to keep things simple, I decided to utilize a Vagrant box running 64-bit Ubuntu 12.04.3 LTS (Precise Pangolin). After navigating a couple of small road bumps, things are looking pretty good!

The first bump in the road was getting the following message when trying to run puppet despite setting the hostname from within the VM:
``` text Warning
Warning: Could not retrieve fact fqdn
Warning: Host is missing hostname and/or domain: bump
```

The easy way to solve this one is to simply declare the hostname in the Vagrantfile for the VM as follows:
``` ruby Vagrantfile
config.vm.hostname = "bump"
```

The next little hurdle was learning about modules and using "--modulepath". In this case I set an include in the nodes.pp file to pull in a simple module and ran the following command to get the message below:
``` bash Command
sudo puppet apply ./manifests/site.pp
```
``` text Error
Error: Could not find class hurdle for bump on node bump
```

The fix in this case as implied by the lead-in is to pass the path to the 'modules' directory in the 'puppet apply' command:
``` bash Command
sudo puppet apply ./manifests/site.pp --modulepath=/path/to/puppet/modules/
```

That's all. Pretty pumped to find new and exciting hurdles with Puppet.
