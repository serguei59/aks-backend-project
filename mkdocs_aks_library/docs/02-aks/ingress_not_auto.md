# Why AKS Does Not Create an Ingress Automatically

AKS provides:

- the control plane (managed),
- worker nodes,
- integration with Azure networking, storage, etc.

But:

- It does **not** know which ingress controller you want:
  - nginx-ingress,
  - Traefik,
  - Istio,
  - AGIC (Azure Application Gateway Ingress Controller),
  - etc.

Therefore:

- AKS does **not** create any Ingress or ingress controller by default.
- You must install your own ingress controller (e.g. via Helm) and then create Ingress objects that define routing for your apps.

This is why your script installs `ingress-nginx` separately after creating the cluster.
