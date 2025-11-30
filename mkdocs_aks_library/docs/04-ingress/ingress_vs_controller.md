# Ingress vs Ingress Controller

- An **Ingress** (resource) is a **set of rules**:
  - which hostnames,
  - which paths,
  - which backend Services/ports.

- An **Ingress Controller** is the **actual implementation** that:
  - watches Ingress objects,
  - configures a reverse proxy (nginx, Envoy, etc.),
  - handles the traffic.

You can think of it like this:

- Ingress = configuration (desired state).
- Ingress Controller = engine (actual data plane).

In your project:

- You installed **nginx-ingress** via Helm as the controller.
- You created `front-ingress` as the configuration that tells nginx how to route to `front-service`.
