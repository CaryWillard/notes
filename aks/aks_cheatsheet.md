# AKS Cheatsheet

## Get creds for an AKS cluster

``` bash
az login

az account set -s $subscription>
az aks get-credentials -g $resource_group -n $cluster_name
```

## Rotate Certs

``` bash
az aks rotate-certs -g $resource_group -n $cluster_name --subscription $subscription
```

* May take half an hour
* May cycle nodes

## Change Azure Subscription

``` bash
az account set -s $subscription
```
