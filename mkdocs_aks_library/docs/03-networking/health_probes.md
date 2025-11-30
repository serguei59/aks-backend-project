# Health Probes in Azure & Kubernetes

There are two layers of probes involved:

1. **Kubernetes probes** (liveness, readiness, startup):
   - Monitor container health.
   - Decide if a Pod should receive traffic or be restarted.

2. **Azure Load Balancer health probes**:
   - Monitor node health and NodePort availability.
   - Decide which nodes remain in the backend pool.

Typical setup for `ingress-nginx-controller`:

- Azure LB health-probes an HTTP endpoint on each node’s NodePort.
- If the node or ingress Pod is down, that node is temporarily removed from the LB rotation.

This combination gives robust behavior:
- Unhealthy Pods are removed from the Service endpoints.
- Unhealthy nodes are removed from Azure LB backend pool.
