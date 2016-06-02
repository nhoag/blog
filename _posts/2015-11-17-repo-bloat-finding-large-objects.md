---
layout: post
title: "Repo Bloat: Finding Large Objects"
modified:
categories:
description:
tags:
- repo
- git
- rev-list
- verify-pack
image:
  feature:
  credit:
  creditlink:
comments:
share:
date: 2015-11-17T21:26:11-05:00
---
I've written previously about trimming the fat on bloated Git repositories. Here I'll present a convenient method for listing the largest objects in a human-friendly format.

The first step in finding the largest objects is to list ***all*** objects. We can do this with `verify-pack`:

```bash
$ git verify-pack -v .git/objects/pack/pack-{HASH}.idx
8306276cde4f3cff8cbe5598fd98bf10146da262 commit 254 170 9725
4677b7c11924cefa62393f0e3e7db6c06787815e tree   30 63 9895 1 08ce30d6550bed7725c399026d91fce24c86a79f
5062bde76952965ff5c473a7de0ae102b4d2c9f3 tree   1122 944 9958
1c1ef555c77ee527c95ca093f251313a6418c158 blob   10 19 10902
non delta: 15175 objects
chain length = 1: 1672 objects
chain length = 31: 10 objects
chain length = 32: 4 objects
.git/objects/pack/pack-d59d9ffc33fbbf297076d5ab7abc07ce2cd8eae0.pack: ok
```

The above is a highly curated result from an actual repo. Here are column IDs for reference:

```bash
SHA-1 type size size-in-packfile offset-in-packfile depth base-SHA-1
```

What we care about are columns 1 and 3, corresponding to `SHA-1` object ID and `size` in bytes. We can get the info we want for the 20 largest objects by adding a few pipes:

```bash
$ git verify-pack -v .git/objects/pack/pack-{HASH}.idx \
  | sort -k 3 -rn \     # sort descending by the size column
  | head -20 \          # return the first 20 items from the sorted list
  | awk '{print $1,$3}' # return colums 1 and 3 for each row
67c7d98775171c7e91aafac8e9905ec204194c30 881498661
447ed6a08656ef9e7047189523d7907bed891ce4 881494950
078659b9e1aed95600fe046871dbb2ab385e093d 46903069
a78bb70f7d351bd3789859bb2e047a6f01430e7f 37732234
432c2dad0b7869c6df11876c0fe9f478c15fb261 30695043
</etc.>
```

The next step is typically to run `git rev-list` and to `grep` for specific hashes from above:

```bash
$ git rev-list --objects --all \
  | grep 67c7d98775171c7e91aafac8e9905ec204194c30
67c7d98775171c7e91aafac8e9905ec204194c30 path/to/archive.tar.gz
```

Performing this next step manually is repetitive and intensive. `xargs` could be employed, but for longer lists of hashes and large repos this would involve a lot of extra overhead to process the full `rev-list` multiple times.

One way to speed this up ***AND*** to eliminate the manual repetition is to construct a single Regex `grep` with all the hash IDs we want so that we can process them all with a single call to `rev-list`. This means we'll need variables in order to track hashes, file sizes, and file paths.

Let's start with data from `verify-pack`:

```bash
HASHES_SIZES=$(git verify-pack -v .git/objects/pack/pack-*.idx \
  | sort -k 3 -rn \
  | head -20 \
  | awk '{print $1,$3}' \
  | sort)
```

Nothing too much new here, but you might notice a couple of new features:

- Using a wildcard for the `idx` file(s)
- Sorting the final result by hash ID (you'll see why in a bit)

Now to put the hashes in a form that we can pass to a `grep`:

```bash
HASHES=$(echo "$HASHES_SIZES" \
  | awk '{printf $1"|"}' \
  | sed 's/\|$//')
```

This gives us a string of pipe-separated hashes like so:

- `hash01|hash02|hashN`

Which we can use to get a list of files from `rev-list` in one go:

```bash
HASHES_FILES=$(git rev-list --objects --all \
  | \grep -E "($HASHES)" \
  | sort)
```

Here again we're sorting the result by hash ID. This facilitates the final step, which is to assemble the gathered data together into a human-friendly format:

```bash
paste <(echo "$HASHES_SIZES") <(echo "$HASHES_FILES") \
  | sort -k 2 -rn \
  | awk '{
      size=$2; $1="";
      $2="";
      $3="";
      split( "KB MB GB" , v );
      s=0;
      while( size>1024 ){
        size/=1024; s++
      } print int(size) v[s]"\t"$0
    }' \
  | column -ts $'\t'
```

We start by merging together data from 'SIZES' and 'FILES' variables. Then we re-sort by file-size before converting the file size field to human-friendly file sizes with `awk`.

The final result is a simple list of files preceded by size:

```bash
44MB     docroot/images/video1.wmv
35MB     docroot/images/video1.mp4
29MB     docroot/images/video2.wmv
7MB      docroot/images/video3.wmv
3MB      docroot/images/image1.JPG
3MB      docroot/images/image2.JPG
</etc.>
```

Overall this is still an expensive operation, but most of the cost is associated with the initial `verify-pack`. Otherwise this is easy to use and to read.

The complete script is available at the following Gist:

- [https://gist.github.com/nhoag/3f21cc113d92fd5676d4](https://gist.github.com/nhoag/3f21cc113d92fd5676d4)
