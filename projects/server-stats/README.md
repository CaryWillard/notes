# server-stats.sh README

## Project Requirements

https://roadmap.sh/projects/server-stats

You are required to write a script server-stats.sh that can analyse basic server performance stats.
You should be able to run the script on any Linux server and it should give you the following stats:

- Total CPU usage
- Total memory usage (Free vs Used including percentage)
- Total disk usage (Free vs Used including percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.

## Total CPU usage

From `vmstat`
Get id ("idle time") percentage from vmstat. Subtract from 100 to get usage.

```
vmstat 1 2 # [delay] [count]
```

Print count=2 reports
First report is usage since boot which is not accurate for current usage
Second report is the average over delay=1 second

``` bash
echo "CPU Usage: "$[100-$(vmstat 1 2 | tail -1| awk '{print $15}')]"%"
```

From /proc/stat file - more precise than vmstat
Get aggregate 'cpu' line
Divide idle time by the sum of all kinds of cpu time
Subtract idle time percentage from 100 to get usage
Average idle time (%) = (idle * 100) / (user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice)

``` bash
cat /proc/stat | grep cpu | head -n 1 | awk '{print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}'| awk '{print "CPU Usage: " 100-$1 "%"}'
```

## Total memory usage (Free vs Used including percentage)

### From `vmstat`
```
vmstat -s
```

### From /proc/meminfo


