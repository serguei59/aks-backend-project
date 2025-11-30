# Security: RBAC, NetworkPolicies, Secrets, Identity

Kubernetes security is multi-layered:

- **RBAC (Role-Based Access Control)**:
  - Controls who can do what via `kubectl` or the API.
  - You define Roles/ClusterRoles and RoleBindings/ClusterRoleBindings.

- **NetworkPolicies**:
  - Define which Pods can talk to which other Pods.
  - Implemented by the CNI plugin (not always enabled by default).

- **Secrets**:
  - Store sensitive configuration (passwords, tokens).
  - Should be encrypted at rest and restricted by RBAC.

- **Identity & Access to Azure resources**:
  - Use Managed Identities or workload identities for Pods.
  - Avoid embedding Azure credentials in Secrets when possible.

In your lab project, focus first on:

- proper Secret usage,
- minimal RBAC permissions for your CI/CD,
- then add NetworkPolicies once the basics are stable.
