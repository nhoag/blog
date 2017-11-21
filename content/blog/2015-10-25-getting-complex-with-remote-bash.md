---
categories: null
comments: null
date: 2015-10-25T13:42:26Z
description: null
share: null
tags:
- base64
- perl
- one-liner
- time
- filter
- logs
title: Getting Complex With Remote Bash
url: /blog/2015/10/25/getting-complex-with-remote-bash/
---

Over the past few months, I've found and created a bunch of fun new scripting tricks and tools. Below are two somewhat related items that helped to unlock new possibilities for me in remote `bash` automation. The first is a Perl *one-liner* that allows filtering access logs by start and end times. The second is a method for executing complex commands remotely via `ssh` without all those intricate escapes.

As context for the Perl log filter, my team at work regularly performs Load Test Analyses. A customer will run a Load Test, provide us with the start and end times for the test window, and then we run a comprehensive analysis to determine whether any problems were recorded. Previous to automation, we would develop `grep` time filters via Regular Expressions (i.e. `grep -E '15/Oct/2015:0(4:(3[4-9]|[4-5]|5:([0-1]|2[0-3]))'`), and then run a bunch of analyses on the results. This is not **so** bad, but involves training in Regular Expressions, is prone to human error, and requires some careful thought.

In developing a more human/beginner-friendly solution, I desired for people to be able to enter start and stop times in the following format:

- `YYYY-MM-DD:HH:mm`

This part is pretty easy, since the entered date can be converted to a timestamp for easy comparisons and then passed along to another function for the comparison/computation.

I first built a filter using `awk`, but found that the version of `awk` on my local machine is more feature-rich than `mawk` which is available on the platform. Most crucially, `mawk` is missing time functions that would enable doing the following:

```bash
awk -v starttime=$STARTTIME -v endtime=$ENDTIME'
BEGIN{
  m = split("Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec", d, "|")
  for(o=1; o<=m; o++) {
    months[d[o]] = sprintf("%02d", o)
  }
}
{
  gsub("[\[]", "", $0)
  split($0, hm, ":")
  split(hm[1], dmy, "/")
  date = (dmy[3] " " months[dmy[2]] " " dmy[1] " " hm[2] " " hm[3] " 0")
  logtime = mktime(date)
  if (starttime <= logtime && logtime <= endtime) print $0
}'
```

Since it's not likely that `gawk` will be available any time soon on the platform, the next alternative I considered was Perl. With some deliberation, I came up with the Perl one-liner below (here wrapped in a bash function):

```bash
function time_filter() {
  PERL_COLUMN=${1:-3}
  echo "perl -MPOSIX -sane '
    {
      @months = split(\",\", \"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec\");
      \$i = 0;
      foreach \$mon (@months) {
        @m{\$mon} = \$i;
        \$i++
      };
      @hm = split(\":\", \$F[$PERL_COLUMN]);
      @dmy = split(\"/\", @hm[0]);
      @dmy[0] =~ s/\[//;
      \$logtime = mktime(0, @hm[2], @hm[1], @dmy[0], @m{@dmy[1]}, @dmy[2]-1900);
      if (\$startTime <= \$logtime && \$logtime <= \$endTime) {
        print
      }
    };' -- -startTime=${START_TIMESTAMP} -endTime=${END_TIMESTAMP}"
}
```

To start off, the function takes an optional argument for the location of the date string in a log line. Next, the POSIX module is loaded along with Perl options (switch, loop, split, single line). Diving into the actual script logic, an array containing 3-letter abbreviations for each month is created, and then the date/time value from the log line is converted to a format that can be used to create a timestamp via the `mktime` function. Lastly, if the converted log time falls between specified start and end times the full log line is printed. `startTime` and `endTime` are fed into the Perl script from corresponding bash variables. You can see that there is a little bit of escaping for the double quotation marks and dollar signs, but nothing beyond what's required to run this locally.

Next up, I needed the ability to execute this remotely over `ssh`. I initially attempted to insert additional escapes to be able to pass this directly to `ssh`. This task proved to be quite challenging, and greatly impacted the human-friendliness of the code. Thankfully, there is a nice alternative - `base64` encoding. This approach gets a bad wrap as a common hacker technique, but I can attest that it works wonders (it's not the tool but the intent!).

Here's a sample implementation:

```bash
function ssh_cmd() {
  echo "ssh -q -t -F ${HOME}/.ssh/config \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o PreferredAuthentications=publickey \
    ${1}"
}

TIME_FILTER=$(time_filter)
REMOTE_CMD=$(echo "cat access.log | ${TIME_FILTER} >> /path/to/filtered/access.log" \
  | base64)
$(ssh_cmd server-id)" echo ${REMOTE_CMD} | base64 -d | sudo bash" < /dev/null
```    

Firstly, we're defining a general purpose `ssh` command. Then the Perl logic is loaded into a variable and concatenated into a full remote command that is subsequently `base64`-encoded. Lastly, we assemble the full remote `ssh` command by piping the `base64`-encoded logic to be decoded remotely and piped into `sudo bash`.

There are alternatives to this approach such as using `rsync` to pass a file with the above Perl script to a remote server ahead of remote execution, but I really like the simplicity that's achievable with `base64`.
