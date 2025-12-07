# Container Lifecycle & Probes

Kubernetes manages container health with three main probes:

- **livenessProbe**: is the container still alive?  
  - If it fails repeatedly, the container is restarted.
- **readinessProbe**: is the container ready to receive traffic?  
  - If it fails, the Pod is removed from Service endpoints.
- **startupProbe**: gives slow-starting apps extra time.

Probes can be:

- HTTP checks,
- TCP checks,
- command checks (`exec`).

In your project:

- You can (and should) add probes to:
  - the API Deployment (e.g. `/healthz`),
  - the Streamlit frontend (simple HTTP probe on `/`),
  - so that Kubernetes and the Azure LB stop sending traffic to broken Pods.
