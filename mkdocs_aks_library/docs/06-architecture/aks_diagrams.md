# AKS Architecture Diagrams (Conceptual)

At a high level, your AKS project looks like this:

```text
[Internet]
    |
    v
[Azure Public IP] --- [Azure Load Balancer]
    |                          |
    v                          v
              [AKS Nodes (VMSS)]
                      |
        +-------------+-------------+
        |                           |
[ingress-nginx-controller]    [Other system Pods]
        |
        v
   [Ingress rules]
        |
        v
   [ClusterIP Services]
        |
        v
      [Pods]
  (Streamlit, API, MySQL)
```

This diagram is useful to keep in mind when:

- deciding where to put TLS termination,
- debugging traffic (where is it lost?),
- planning logging and metrics collection,
- reasoning about security boundaries (public vs internal).
