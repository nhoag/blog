---
title: "New Year, Shiny Dots"
date: 2018-01-21T14:52:07-05:00
tags:
- dotfiles
- bats
- shellcheck
- shfmt
- rcm
---
Over the last few weeks I've been digging away on my [dotfiles](https://github.com/nhoag/dotfiles) and figured I'd write up the interesting aspects of the various decisions, methods and changes involved. The high-level overview is that I moved to a bare Git repository structure, added an installer script and some light multi-OS support, and added automated linting and a few basic tests.

After using a symlinked dotfiles system for a couple of years, I got curious as to whether there might be decent alternatives. I tried [rcm](https://github.com/thoughtbot/rcm), but started having issues with it and lost interest. Then I found the following comment thread that describes using a bare Git repository, the simplicity of which caught my attention:

* https://news.ycombinator.com/item?id=11070797

Making the conversion was easy enough, and the process helped alleviate some cruft that had built up. After standardizing my home directory and removing unnecessary symlinks, I created a one-liner to replace symlinks with hard files. Then I set up the bare Git repo format, switched everything over, and haven't looked back!

I opted to alias git operations in the home directory to 'dots'. It hasn't been too bad to rewire my brain to use git as 'dots' in this instance. The only thing to watch out for is not accidentally adding untracked files (a habit that's worthwhile to break), as doing so here could expose sensitive info!

I wanted to make my dotfiles installable on a non-macOS computer. I started out using a snapshot of a basic Ubuntu GUI install on VirtualBox. This is where the installer script initially became useful, as it saved running long-ish command sequences over and over. It later proved useful for automated testing! There were several fun issues to work out, and in the end my dotfiles gained robustness and a few bug fixes.

I added Travis CI integration, initially just for formatting and linting checks, and later got into some basic tests via [bats](https://github.com/sstephenson/bats). Travis CI has several tools built-in, including [shellcheck](https://github.com/koalaman/shellcheck), [shfmt](https://github.com/mvdan/sh), and bats. So far, I haven't found good lint and test tooling for zsh. Thankfully, most of my stuff is bash compatible, and these Travis CI built-ins have proven useful.

In adding bats tests, there were some delightful surprises. A `fingerprints` function I'd written a while back ultimately proved to be useless. It was an overly complex wrapper for `ssh-keygen` that was trying to add functionality that was already present (showing fingerprints for multi-key files). I might never have discovered this if it weren't for attempting to create a bats test. A less delightful surprise was that Travis CI openssh is an older version that does not support passing the hash option (`-E`).

In the end, my dotfiles feel lighter and leaner. There's still a lot to do, but it's comforting to have some basic tests in place - even with the slight mismatch of tools to code.
