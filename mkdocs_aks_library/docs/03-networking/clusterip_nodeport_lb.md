# ClusterIP vs NodePort vs LoadBalancer

This is the core triangle for understanding Kubernetes networking:

- **ClusterIP**: internal-only, cluster-local virtual IP.
- **NodePort**: exposes a port on each node, mainly used internally by cloud Load Balancers.
- **LoadBalancer**: cloud-facing entrypoint that forwards traffic to NodePorts.

Flow in AKS:

1. You create a Service of type LoadBalancer.
2. Kubernetes assigns a NodePort behind the scenes.
3. The Azure cloud-provider:
   - creates a Load Balancer in the nodeResourceGroup,
   - allocates a Public IP,
   - configures a rule PublicIP:80 → NodeIPs:NodePort.

From the outside, you only see:

```text
http://<Public-IP>:80
```

From inside the cluster, Services talk to each other using ClusterIP.
