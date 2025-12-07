# What kubectl rollout restart Really Does

`kubectl rollout restart deployment <name>`:

- Tells Kubernetes to restart all Pods in a Deployment.
- It does this by:
  - bumping an internal annotation on the Pod template,
  - which triggers the Deployment controller to create new Pods,
  - and terminate old ones.

Use cases:

- You changed a ConfigMap or Secret that is **not** mounted as a volume (only via env vars),
- You want to force Pods to reload configuration without changing container images.

In the projects's pipeline, you might use it after updating config maps or secrets that the app reads only at startup.
