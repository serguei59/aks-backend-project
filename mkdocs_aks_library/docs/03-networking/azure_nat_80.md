# How Azure Load Balancer NATs Port 80 to a NodePort

For the `ingress-nginx-controller` Service of type LoadBalancer:

- Kubernetes exposes a NodePort port, e.g. `31245`.
- Azure Load Balancer is configured with:
  - Frontend: Public IP on port 80,
  - Backend: the AKS nodes on port `31245`.

When a client hits `http://PUBLIC_IP:80`:

1. Azure LB receives the packet on port 80.
2. It performs NAT to one of the backend nodes on port 31245.
3. kube-proxy forwards traffic to the `ingress-nginx-controller` Pods.
4. nginx then routes based on host/path to internal Services.

The NodePort is an implementation detail; the user never has to know it exists.
