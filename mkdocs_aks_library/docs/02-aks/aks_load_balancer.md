# Why AKS Creates a Load Balancer

When a Service of type `LoadBalancer` is created (e.g. `ingress-nginx-controller`):

- The Kubernetes cloud-provider integration for Azure detects it.
- Azure automatically creates:
  - a **Standard Load Balancer** in the nodeResourceGroup,
  - frontend IP configuration,
  - backend pool (with the nodes),
  - load balancing rules,
  - health probes.

This is why you do **not** create Azure Load Balancers manually for AKS.  
You declare a Kubernetes Service of type LoadBalancer, and AKS + Azure do the rest.
