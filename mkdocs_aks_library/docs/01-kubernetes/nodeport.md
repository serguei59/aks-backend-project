# NodePort and Its Real Role

**NodePort** exposes a Service on a port on each node (e.g. `31234`).

- Every worker node opens that port.
- Traffic to `NODE_IP:NodePort` is forwarded to the Service, then to Pods.

In a managed cloud (AKS):

- You usually do not call NodePort directly.
- Instead, a **LoadBalancer** Service is created:
  - Azure Load Balancer forwards traffic from PublicIP:80 → NodePort → Pods.

So in this project:

- NodePorts are mostly an **implementation detail** used by Azure LB.
- You interact with:
  - **Public IP + port 80** externally,
  - **ClusterIP + port 8501** internally.
