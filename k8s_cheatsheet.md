# K8s Cheatsheet

## Cluster Internal Service Url

``` txt
<service-name>.<namespace>.svc.cluster.local:<service-port>
```

## Port forwarding

``` bash
kubectl port-forward <kind>/<name> <local-port>:<k8s-port> --namespace <namespace>
```

## Debugging Networking

``` bash
# Open a new debug pod on the first node listed (thus least likely to be removed during scale down)
first_node=$(kubectl get nodes | tail -n +2 | head -n 1 | awk '{print $1}')
kubectl debug -it --image=mcr.microsoft.com/dotnet/runtime-deps:8.0 node/$first_node
```

Install tools on the pod
``` bash
alias ll="ls -Flash"
apt update
apt install -y netcat-openbsd dnsutils iputils-ping curl traceroute dig telnet
```

## Draining a Node

``` bash
kubectl drain nodename --ignore-daemonsets --delete-emptydir-data
```
