---
layout: post
title: "Automating Drupal Module Deployment with Bash"
date: 2014-04-26 22:48:53 -0400
comments: true
tags: 
- drush
- git
- drupal
- bash
- make
- heredoc
---
Part of the process of migrating new customers to [Acquia Hosting](http://www.acquia.com/products-services/acquia-cloud) involves adding (or verifying the presence of) three [Drupal](https://drupal.org/project/drupal) modules:

- [Acquia Network Connector](https://drupal.org/project/acquia_connector): get status and recommendations from Acquia Insight
- [Fast 404](https://drupal.org/project/fast_404): reduce the cost of 404s
- [Memcache API and Integration](https://drupal.org/project/memcache): improve performance by moving cache data into memory

### Manual?! Awe shucks...

Verifying, adding, and committing these modules manually generally takes about five to ten minutes and can be error-prone. I don't usually stand a site up for this task, but just clone the repo locally, download the modules and move them into place with rsync. This means I can't lean on Drupal to make the right decisions for me. Mistakes are not a huge deal at this phase, but can add many minutes to an otherwise quick task (assuming we actually catch the mistake!). Mistakes might include adding D7 modules to a D6 site, putting modules in the wrong location, or adding a slightly older version of a module (perhaps with a known security flaw!). Once a mistake has been introduced, we now have to verify the mistake, maybe perform an interactive Git rebase on bad commits, and generally do more work.

In order to ease some of the human error factor of the above scenario, and since this is repetitive and script-worthy, I decided to cobble together a [bash script](https://github.com/nhoag/ah-onboard/blob/master/modules.sh) to automate the process. Now the whole task is much less error-prone, and takes all of 5-10 seconds to complete!

### The Brainstorm

Below is the basic plan I brainstormed for how I initially thought the script should operate:

```
get drupal version from prompt
check if acquia_connector, fast_404, memcache already exist in the repo
check contrib modules path - contrib|community
download modules that don't exist and move into place
git add and commit each downloaded module individually
git push to origin
```

You'll notice that not all of the above was actually implemented/needed, but it gave a good starting point for setting up the basic mechanics of the script, and served as an anchor when I needed to reset my focus.

### Gotta drush That

To simplify the process of downloading and adding the latest version of each module for the correct version of Drupal core, I decided to lean on [drush](https://github.com/drush-ops/drush), and particularly drush's ability to build out a codebase via the [make](http://www.drush.org/#make) command.

__A few important points:__

- in Drupal 6/7, shared contributed modules are _generally_ located at 'sites/all/modules[/contrib]'
- `drush make` receives build instructions via a make file
- since each project is evaluated individually, we need a make file for each project
- since make files are static, we need a different set of make files for each version of Drupal, and for each contrib module path

Looking back through the repo history, you'll see that my initial approach was to generate static make files for each Drupal version, project, and project path. You'll also see that I included a secondary script to generate a new set of make files for those rare times when a codebase is using a contrib path such as 'sites/all/modules/community' or other. Fortunately, there is a better way!

### A Better Way

In bash, we can define dynamic make files as [heredocs](http://en.wikipedia.org/wiki/Here_document). By making this shift, I was able to trim 12+ static make files along with secondary bash script down to two heredocs:

``` bash
function makefile() {
  if [[ $3 == 'modules' ]]; then
    cat <<EOF
core = $1.x
api = 2

; Modules
projects[] = $2
EOF
  else
    cat <<EOF
core = $1.x
api = 2

; Modules
projects[$2][subdir] = $3
EOF
  fi
}
``` 

In order to support the shift to heredocs, I also had to convert the drush command from referencing static files to processing make files via STDIN. Thanks to [this comment](https://gist.github.com/patcon/3014293#comment-360469), I ended up with the following:

```
for i in "${DIFF[@]}"; do
  makefile $VERSION $i $CONTRIB \
    | $DRUSH make --no-core -y php://stdin
done
```

And with that, we have a powerful and dynamic bash script that will save lots of time, and can be easily expanded or improved to handle additional modules and use cases. I also set the repo up to be a collection of helpful scripts, and I very much look forward to automating away additional complexities.

