# AKS Networking

## How to enable access between K8s clusters in separate peered VNETs

Let's say we want to let an ES cluster in `k8s-1` call the API on an ES cluster in `k8s-2` without opening up the entire `VNET 2` IP range to the entire `VNET 1` IP range.

Let's expose the `k8s-2` ES API on a new IP and allow `k8s-1` to send requests to that IP.

In `k8s-2`, declare a Service with type LoadBalancer. This will create a new Frontend IP on the `kubernetes-internal` LB in the `mc_k8s-2_k8s-2_eastus` resource group.

Add `loadBalancerSourceRanges: ["k8s-1 CIDR range goes here"]` to the `k8s-2` Service spec. This will automatically create Network Security Group rules on the `k8s-2` `mc_k8s-2_k8s-2_eastus` resource group.
