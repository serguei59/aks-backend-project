# Logs & Observability

Observability in Kubernetes typically includes:

- **Logs**:
  - `kubectl logs` for quick debugging,
  - centralized logging via tools like Azure Monitor, Loki, or ELK.
- **Metrics**:
  - CPU, memory, request rates, errors,
  - scraped by Prometheus-like systems.
- **Traces**:
  - Distributed tracing for microservices.

On AKS:

- You can enable Azure Monitor / Container Insights.
- You can also deploy your own logging stack.

For your project, starting with:

- `kubectl logs`,
- basic metrics from AKS,
- and explicit logging in your API and frontend

is already a strong first step.
