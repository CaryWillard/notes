# NTP: Network Time Protocol

Scenario: A server is suposed to be syncing with an internal time source and not a public Ubuntu source. Requests sometimes timeout against the public Ubuntu source.

## How to check

``` bash
systemctl status systemd-timesyncd.service

> Connecting to time server 185.125.190.58:123 (ntp.ubuntu.com)

# This needs to be updated in the configs
```

## Config files for timesyncd

[https://www.freedesktop.org/software/systemd/man/latest/timesyncd.conf.html](https://www.freedesktop.org/software/systemd/man/latest/timesyncd.conf.html)

``` bash
cat /etc/systemd/timesyncd.conf
```
