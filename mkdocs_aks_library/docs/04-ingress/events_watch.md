# How the Ingress Controller Watches Events

The nginx ingress controller runs as Pods that:

- watch the Kubernetes API for:
  - Ingress resources,
  - ConfigMaps,
  - Secrets (for TLS),
- compute the desired nginx configuration,
- reload nginx (hot reload) when configuration changes.

When you patch an Ingress:

1. The API server updates the Ingress object.
2. The ingress controller receives an event.
3. It regenerates its internal configuration.
4. It triggers an nginx reload.

This is why you do **not** need to restart Pods manually when you change Ingress rules; the controller takes care of it.
