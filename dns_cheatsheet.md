# DNS Cheatsheet

## Local DNS

### Linux

``` bash
sudo systemd-resolve --flush-caches
```

### Chrome

``` txt
chrome://net-internals/#dns
```

### Powershell

``` ps1
Clear-DnsClientCache
```

### Windows CMD

``` cmd
ipconfig /flushdns
```
