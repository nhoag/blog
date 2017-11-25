---
comments: true
date: 2014-05-21T20:56:46Z
tags:
- ruby
- drupal
- git
- nokogiri
- thor
title: Automating Drupal Module Deployment with Ruby
url: /blog/2014/05/21/automating-drupal-module-deployment-with-ruby/
---

After building a bash script to automate Drupal module deployments, I figured it might be worthwhile to convert the script over to Ruby. I decided to spin up the new version as a Ruby gem leveraging the [Thor](http://whatisthor.com/) CLI Framework.

Having already worked out many of the mechanics of deploying Drupal contrib modules in the previous bash script, I was able to dive right into coding. I started by fleshing out the command options and then moved into scripting the functionality. Thor makes it really easy to set up the command interface, though formatting long descriptions can be a little tricky. 

In building the script, I wanted to stay faithful to keeping as much of the logic in Ruby as possible. The result was many opportunities to explore Ruby and to make some interesting discoveries. The two areas where I was most tempted to shell out were with identifying and downloading the "best" version of a contributed Drupal module ([drush](https://github.com/drush-ops/drush)), and with performing version control activities (Git).

In the first case, [Nokogiri](http://nokogiri.org/) was an obvious choice for parsing Drupal contrib XML feeds. Fortunately, drupal.org exposes uniform project feeds in the following format:

```
http://updates.drupal.org/release-history/{project}/{core-version}
```

Reviewing several project feeds, it wasn't immediately obvious how to parse a feed to select the "best" project, so I referenced drush source code for pointers:

```php
function updatexml_best_release_found($releases) {
  // If there are releases found, let's try first to fetch one with no
  // 'version_extra'. Otherwise, use all.
```

The above comment says it all. In the Ruby script, you can see this basic logic is reproduced in `contrib.rb` (dl method):

```ruby
    def dl
      doc = Nokogiri::XML(open(@feed).read)
      releases = {}
      doc.xpath('//releases//release').each do |item|
        if !item.at_xpath('version_extra')
          releases[item.at_xpath('mdhash').content] = item.at_xpath('download_link').content
        end
      end
      if releases.nil?
        doc.xpath('//releases//release').each do |item|
          releases[item.at_xpath('mdhash').content] = item.at_xpath('download_link').content
        end
      end
      return releases.first
    end
```

For downloads of both XML documents and project archives, I wanted to prevent getting myself (or others) blacklisted through unintentionally DOS'ing drupal.org with lots of requests. Here I decided to lean on a small OpenURI extension called [open-uri-cached](https://github.com/tigris/open-uri-cached). The way this is implemented is a bit hacky, but it gets the job done for now. For locating cached project archives, you'll see that I replicated a small bit of logic from open-uri-cached to find and extract archives:

```ruby
uri = URI.parse(archive)
targz = "/tmp/open-uri-503" + [ @path, uri.host, Digest::SHA1.hexdigest(archive) ].join('/')
```

Addressing Git functionality was initially not so straight-forward. Following the Git breadcrumbs from [Ruby Toolbox](https://www.ruby-toolbox.com/categories/git_Tools), the most obvious place to start is [Grit](https://github.com/mojombo/grit), which "is no longer maintained. Check out [rugged](https://github.com/libgit2/rugged)." Rugged was initially promising, but in the end failed to yield a working `git push`. That left [ruby-git](https://github.com/schacon/ruby-git) as the next logical choice. Fortunately ruby-git did the trick without much fuss:

```ruby
    def update
      prj_root = Pathname.new(docroot)
      workdir = prj_root.parent.to_s
      project = File.basename(path)

      g = Git.open(workdir)
      g.branch('master').checkout

      changes = []
      g.status.changed.keys.each { |x| changes.push x }
      g.status.deleted.keys.each { |x| changes.push x }
      g.status.untracked.keys.each { |x| changes.push x }

      if changes.nil? == false
        g.add(path, :all=>true)
        g.commit("Adds #{project}")
        g.push
      else
        puts "No changes to commit for #{project}"
      end
    end
```

There are many improvements left to be made with this script, but so far I'm very happy with the result. Using classes and objects is a breath of fresh air compared to procedural bash, and having this rolled into a gem makes it very easy to share with the team.

