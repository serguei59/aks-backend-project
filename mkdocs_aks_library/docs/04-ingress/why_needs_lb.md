# Why ingress-nginx Alone Does Not Expose Your App

Deploying the ingress controller (nginx) into the cluster is **not enough**:

- The controller runs as Pods inside the cluster.
- Without a `Service` of type `LoadBalancer`, it is **only reachable internally**.

To expose it publicly:

1. You create a Service of type LoadBalancer for `ingress-nginx-controller`.
2. The Azure cloud-provider creates:
   - a Load Balancer,
   - a Public IP,
   - the necessary routes.
3. The Load Balancer forwards incoming internet traffic to the nginx Pods.

So the full chain is:

```text
Azure LB + Public IP → Service (LoadBalancer) → ingress-nginx Pods → your Services → your Pods
```
