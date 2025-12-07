# Deployments

A **Deployment** manages a set of identical Pods and handles:

- **Replica count** (scaling up/down),
- **Rolling updates** (deploying a new version without downtime),
- **Rollbacks** (going back to a previous version).

Key ideas:

- You declare a **desired state** (e.g. 2 replicas, image `v1.2.3`).
- The Deployment controller continuously reconciles the actual state to match the desired one.
- When you apply a new Deployment spec with a new image:
  - it creates a new ReplicaSet,
  - gradually shifts traffic from old Pods to new Pods.

In your project:

- `streamlit` Deployment runs the frontend image from GHCR.
- `api` Deployment runs the backend.
- If you change the Docker tag and redeploy, the Deployment performs a rolling update.
