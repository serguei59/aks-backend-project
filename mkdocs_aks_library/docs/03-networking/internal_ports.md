# How Kubernetes Exposes Internal Ports

Internally, Service networking works as follows:

- Each Service gets a **ClusterIP** in the service CIDR (e.g. `10.0.0.0/16`).
- iptables or IPVS rules on nodes ensure that:
  - packets to that IP:port are load-balanced across matching Pods.
- DNS in the cluster (CoreDNS) resolves `service.namespace.svc.cluster.local`.

So when your Streamlit frontend calls the API by Service name:

```text
http://api.sbuasa.svc.cluster.local:5000
```

the traffic never leaves the cluster:

- No Azure LB,
- No Public IP,
- Just internal kube-proxy routing.
