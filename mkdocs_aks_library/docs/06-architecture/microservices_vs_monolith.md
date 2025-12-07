# Microservices vs Monolith on Kubernetes

Kubernetes does not force microservices, but it makes them easier to deploy and operate.

- **Monolith**:
  - A single application container (or tightly coupled set).
  - Still valid for many use cases (like your AKS project).

- **Microservices**:
  - Many small services, each owning a specific responsibility.
  - More complex to orchestrate, but better for large, evolving systems.

On K8s:

- Both patterns use the same primitives:
  - Deployments, Services, Ingress, ConfigMaps, Secrets.
- The main differences are:
  - number of Deployments,
  - number of Services,
  - complexity of communication and observability.

Your current architecture (frontend + API + DB) is already a **small microservice-oriented system**.
