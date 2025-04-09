# Bash

## Sort command output after a header line

``` bash
CMD | tee >/dev/null >(head -n 1) >(tail -n +2 | sort)
```

## conntrack

Stateful firewall
