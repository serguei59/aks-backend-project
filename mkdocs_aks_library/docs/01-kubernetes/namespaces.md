# Namespaces

A **Namespace** is a logical partition of the cluster.

Use cases:

- Separate environments (`dev`, `test`, `prod`),
- Separate teams or applications (`sbuasa`, `monitoring`, `ingress-nginx`),
- Apply different RBAC permissions and ResourceQuotas.

Important points:

- Namespaces do **not** provide security isolation by themselves; they are a scoping mechanism.
- Namespaced resources:
  - Pods, Services, ConfigMaps, Secrets, Ingresses…
- Cluster-scoped resources:
  - Nodes, PersistentVolumes, StorageClasses…

In your AKS project:

- `sbuasa` namespace contains your app (API, DB, front).
- `ingress-nginx` namespace contains the ingress controller itself.
