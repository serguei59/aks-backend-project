# Why Separate Ingress from Internal Services

Separating ingress traffic from internal services gives you:

- A single, well-controlled entrypoint to the cluster.
- The ability to apply:
  - rate limiting,
  - authentication,
  - TLS termination,
  - logging and metrics at the edge.

Internal Services (ClusterIP):

- Are not exposed to the public internet.
- Are only reachable from within the cluster.

This pattern reduces:

- Attack surface,
- Configuration duplication,
- Complexity in DNS and TLS management.
