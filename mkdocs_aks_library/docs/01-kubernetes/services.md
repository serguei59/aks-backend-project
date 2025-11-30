# Services: ClusterIP, NodePort, LoadBalancer

A **Service** is a stable, virtual IP that exposes a set of Pods selected by labels.

There are three core Service types:

## ClusterIP (default)

- Internal-only.
- Accessible only from inside the cluster (`10.x.x.x`).
- Used for Pod-to-Pod communication (e.g., API talking to MySQL).

Example: your `mysql` Service in namespace `sbuasa`.

## NodePort

- Exposes a port on **every node** of the cluster.
- Each node listens on the same NodePort (e.g. `31245`) and forwards traffic to the Service.
- Rarely used directly in cloud environments, but used under the hood by LoadBalancer Services.

## LoadBalancer

- Only meaningful in a cloud provider (Azure, AWS, GCP).
- Automatically provisions:
  - a cloud Load Balancer,
  - a Public IP,
  - backend rules to reach the NodePorts.
- Typical pattern for:
  - `ingress-nginx-controller` Service,
  - occasionally direct public Services (not recommended for apps; better use Ingress).

In your AKS project:

- `front-service` and `api` are **ClusterIP**.
- `ingress-nginx-controller` is a **LoadBalancer** that receives all public traffic and routes it internally.
