# Traefik Cheatsheet

## How to verify a deployment can be reached

``` bash
curl --connect-to <new-host-name>:443:<traefik-host>:443 https://<new-host-name>
```

## Logs

``` bash
sudo journalctl -xef -u traefik
```
