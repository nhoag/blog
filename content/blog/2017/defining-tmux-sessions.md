---
title: "Defining Tmux Sessions"
date: 2017-12-22T22:04:53-05:00
tags:
- tmux
- session
- ondemand
- native
---
I'm still kicking with tmux, and have rounded a few rough edges since the last installment. One area of advancement has been learning about defining default sessions. To be clear, this doesn't entail attaching to indefinitely running background sessions. This is firing up an on-demand pre-defined session.

In researching support for this, I found [teamocil](http://www.teamocil.com/) and [tmuxinator](https://github.com/tmuxinator/tmuxinator). These look interesting, but ultimately didn't appeal to me since they are Ruby gems that introduce additional dependencies. _I don't like dependencies._ It turns out this can be handled natively in tmux!

Here's a Stack Overflow answer that provides a rough explanation of the concept:

* https://stackoverflow.com/a/5753059

Here's an example of the session file I'm using to write this blog post:
```bash
new-window -n blog -c ~/blog
send-keys -t blog.1 "vi ." Enter
split-window -h -d -c ~/blog
send-keys -t blog.2 "hugo serve -D -b localhost:1313" Enter
```

The above session file opens a single window called "blog". It then tells the window to open `vi`. Next the window is split vertically (keeping the focus on the `vi` pane), and then starts up `hugo serve` in the second pane.

In order to make use of the session defined above, we can call it directly:
```bash
# The leading tmux depends whether you're in or out of tmux at execution time.
[tmux] new-session "tmux source-file ~/.tmux/sess.blog"
```

We can also add a binding in `.tmux.conf` so that the session can be invoked with 3 keys:
```bash
bind H source-file ~/.tmux/sess.blog
```

