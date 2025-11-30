# The Azure Cloud-Provider in Kubernetes

The **cloud-provider** integration is the component that:

- Watches Kubernetes resources (like Services of type LoadBalancer),
- Calls Azure APIs under the hood to:
  - create / update / delete Load Balancers,
  - allocate Public IPs,
  - configure routes and cloud-specific details.

When you set:

```bash
--set controller.publishService.enabled=true
```

for ingress-nginx, you are telling the controller to publish Service information in a way that the cloud-provider can use to reconcile the external Load Balancer.

Understanding this loop is key to debugging “why does my Service not get an external IP?” issues.
