# OpenSSL Cheatsheet

## List certs on a remote endpoint

_This includes the expiration dates._

``` bash
openssl s_client -connect <hostname>:<port> -showcerts
```

## View expiration dates from a .pem file

``` bash
cat cert.pem | openssl x509 -noout -dates
```

## View cert expiration dates from a K8s Secret

``` bash
kubectl get secret <secret-name> -n <namespace> --template="{{index .data \"tls.crt\"}}" | base64 -d | openssl x509 -noout -dates
```
