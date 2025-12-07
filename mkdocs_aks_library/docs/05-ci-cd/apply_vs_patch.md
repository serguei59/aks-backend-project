# kubectl apply vs kubectl patch

- `kubectl apply -f file.yaml`
  - Applies the full manifest.
  - Creates or updates the resource.
  - Keeps track of the last applied configuration for merge.

- `kubectl patch`
  - Modifies only part of a resource.
  - Does not require full YAML.
  - Useful for dynamic or one-off changes (like Ingress host).

In the pipeline' project:

- `apply` is used for static manifests (Deployments, Services, ConfigMaps).
- `patch` is used for the Ingress host, which depends on a dynamic value (external IP).
