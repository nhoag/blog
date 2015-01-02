---
layout: post
title: "Another Hodgepodge Update"
date: 2013-12-29 14:18:03 -0500
comments: true
tags: 
- vim
- docker
- osx
- vagrant
- git
---

Recently, a bash script that I've used many times on lots of different types of servers was giving very strange results. Typically the script is called as `./script.sh info.cfg` and proceeds to run through several processes. On this occasion, I was left with `: command not found`. When I hit the script with `bash -x` I could see that both the script and the config file were giving strange results and choking on line-breaks and curly braces. I checked the bash version, which was indeed up-to-date enough. The problem turned out to be that the files were being interpreted in the wrong format!? Solution?: Run `:set ff=unix` on all of the files in vim. Nothing too complex, but this had me scratching my head for a few minutes.

While on the topic of vim, I took a few swings on [Vimgolf](http://vimgolf.com/) a little while back. As a generalist in the editor sphere, I found this to be a really neat way to gain exposure to advanced vim techniques without the overhead of RTFM.

While on the topic of Github-integrated learning applications :), I also dipped my toes over at [Exercism.io](http://exercism.io). This is such a cool implementation! Polyglotism, here we come.

To change topics, I was working on a Drupal site that showed several custom modules enabled but not present in the site codebase. It sometimes happens that a site maintainer/developer will delete a module without properly disabling it in the website configuration. This can cause unexpected performance and behavioral issues for a site, so it's important to resolve this by reinstating the missing modules and following proper uninstallation procedure. In this case, the missing modules were in the repo history. Here's how to retrieve them.

Find the commit where a module was deleted:

```
git rev-list -n 1 HEAD -- <file_path>
```

Checkout the revision just before the delete commit:

```
git checkout <delete_commit>~1 -- <file_path>
```

Note: You can go back further than 1 commit, substituting the desired number for '1', and using the delete commit as an anchor.

I've dabbled with docker containers a few times using [Vagrant](http://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) per the [documentation](http://docs.docker.io/en/latest/installation/vagrant/) for OSX. What isn't clear is how to easily access docker deployments from the OSX host, but after poking around the webs, I eventually stumbled on this little nugget. When firing up the VM that will host the docker deployments, rather than running `vagrant up`, insert a little snippet on the front of the command to specify port forwarding as follows:

```
FORWARD_DOCKER_PORTS=1 vagrant up
```

If your VM is already running, you can s/up/reload :)
