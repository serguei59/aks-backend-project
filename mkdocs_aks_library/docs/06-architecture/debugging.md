# How to Debug in Kubernetes

Core tools you will use all the time:

- `kubectl get`:
  - Quick overview of resources (Pods, Services, Deployments, Ingress).

- `kubectl describe`:
  - Detailed information, including events.
  - Great for understanding why something is Pending / CrashLoopBackOff / not routing.

- `kubectl logs`:
  - Application logs from containers.
  - Use `-f` to follow.

- `kubectl exec`:
  - Open a shell inside a container for debugging,
  - Or run specific commands (curl, ping, etc.) from inside the cluster.

- `kubectl port-forward`:
  - Forward a local port to a Pod or Service for quick local testing.

- Ingress debugging:
  - Check `kubectl get ingress -A`,
  - Describe the ingress,
  - Verify the Service backend and Pod readiness,
  - Inspect the ingress controller logs.

Combining these tools with a clear mental model of the architecture is the fastest way to solve production issues.
