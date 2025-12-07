# Pods

A **Pod** is the smallest deployable unit in Kubernetes. It is a wrapper around one or more containers that must be scheduled together on the same node.

Key points:

- A Pod usually contains **one main container**, plus optional sidecars (for logging, proxies, etc.).
- All containers in a Pod:
  - share the same network namespace (same IP, same ports),
  - can talk to each other over `localhost`,
  - can share mounted volumes.
- Pods are **ephemeral**: they can be killed, rescheduled, or recreated at any time.

In practice, you almost never create Pods directly in production.  
Instead, you use **Deployments** or other higher-level controllers that manage Pods for you.
