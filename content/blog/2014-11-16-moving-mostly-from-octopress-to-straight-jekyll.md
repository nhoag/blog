---
comments: null
date: 2014-11-16T11:12:41Z
description: null
share: null
tags:
- octopress
- jekyll
- redirect
title: Moving (Mostly) From Octopress to Straight Jekyll
url: /blog/2014/11/16/moving-mostly-from-octopress-to-straight-jekyll/
---

Over the last couple of weekends I converted my blog from Octopress to straight Jekyll (still hosting on S3). There wasn't any particular reason behind the move, but I was curious to know more about the differences between the two platforms, wanted to try out a new theme, and just generally enjoy these types of migrations.

Overall, there aren't many differences between the two platforms. As many have stated before, the major difference is that Octopress comes with more functionality out of the box, but at the cost of increased complexity. Octopress is a great way to get into static sites, but after gaining some experience I really enjoyed paring down and digging into Jekyll.

There were a couple of fun tasks with the conversion, mostly with regard to setting up redirects and deprecating xml documents.

### Redirects

One of the main differences between the old and new versions of my site is the way tags are handled. On the old site they were found at `blog/categories/{category}`, but on the new site they are at `tags/#{category}`. There are several plugins for generating redirects, and in my case I wanted to make sure I could automate the process, and set up redirects for a defined set of paths. The [Jekyll Pageless Redirects](https://github.com/nquinlan/jekyll-pageless-redirects) plugin got me most of the way there.

The Jekyll Pageless Redirects plugin introduced a couple of issues, with resolution detailed in the following issue thread:

- https://github.com/nquinlan/jekyll-pageless-redirects/issues/5

Basically you'll want to apply the changes from [here](https://github.com/nquinlan/jekyll-pageless-redirects/pull/7), and ensure that paths are specified as follows (note the leading forward slash):

```
/origin : /destination
```

With a working redirect implementation, the next step was to define the list of redirects. Here's the one-liner bash script I used:

``` bash
ls -1 path/to/categories | while read tag ; do echo "/blog/categories/$tag : /tags/#$tag" >> _redirects.yml ; done
```

The above script starts by listing all of the category directories in the original site, pipes these one-by-one into a `while` loop that `echo`s each value in the desired YAML format and appends the result to the `_redirects.yml` file.

### Deprecating Feeds

Similarly to category redirects, the old site generated an xml feed for each category. These feeds are not included in the new Jekyll site, and I don't see a need for them to continue. Rather than shut them down entirely, it's easy enough to hijack the redirect plugin to perform the small additional task of deprecating each of these feed items. This way most feed consumption services will interpret that this resource is officially gone.

I added the below code to the plugin and was good to go:

``` ruby
# snip

retire_xml = 'atom.xml'

# snip

retire_xml_path = File.join(alias_dir, retire_xml)

# snip

File.open(File.join(fs_path_to_dir, retire_xml), 'w') do |file|
  file.write(xml_template)
end

# snip

(retire_xml_path.split('/').size + 1).times do |sections|
  @site.static_files << PagelessRedirectFile.new(@site, @site.dest, retire_xml_path.split('/')[1, sections + 1].join('/'), '')
end

# snip

def xml_template()
  <<-EOF
<?xml version="1.0"?>
<redirect>
  <newLocation />
</redirect>
  EOF
end

# snip
```

And with that I pushed up to S3 and am fully on Jekyll, with the small exception that I still use the Octopress gem to generate new posts.
