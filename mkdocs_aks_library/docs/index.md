# AKS & Kubernetes Technical Library

This mini-site is a personal technical knowledge base built around a concrete Azure Kubernetes Service (AKS) project:

- A Streamlit frontend
- A Python API backend
- A MySQL database
- Everything deployed on AKS with nginx-ingress
- Automated with a GitHub Actions CI/CD pipeline

The goal of this documentation is **not** to be an exhaustive theory book, but a **practical, opinionated reference** you can reuse across real projects.

Each section is focused on answering questions like:

- *"What is this object really for?"*
- *"Where does this resource live in Azure?"*
- *"What happens on the network path from the browser to my Pod?"*
- *"Why do I need this flag in Helm or this patch in my pipeline?"*

You can read it sequentially, or jump directly to the topics that matter for your current debugging session.

## Sections

- **01 – Kubernetes Fundamentals**: Pods, Services, Deployments, Namespaces, ConfigMaps, Secrets, Volumes, NodePorts and probes.
- **02 – AKS Specifics**: nodeResourceGroup, Azure Load Balancer, Public IPs and the Azure cloud-provider.
- **03 – Networking**: ClusterIP vs NodePort vs LoadBalancer, Azure NAT, health probes and the full HTTP path.
- **04 – Ingress & Ingress Controller**: ingress-nginx, publishService, nip.io, JSON patching and HTTPS with cert-manager.
- **05 – CI/CD with GitHub Actions**: building images, pushing to GHCR, deploying to AKS and dynamically patching Ingress.
- **06 – Architecture & Best Practices**: separation of concerns, security, logging and overall AKS architecture.

Use this as your **living notebook**: extend it, adapt it to new projects, and keep track of the things that were painful to understand the first time.
