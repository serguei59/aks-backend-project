# Multi-Job Pipelines in GitHub Actions

In your project, the CI/CD pipeline has two main jobs:

1. **build-image-front**
   - Checks out the repo,
   - Logs in to GHCR,
   - Builds the Streamlit Docker image,
   - Pushes the image to GHCR.

2. **deploy-to-aks**
   - Waits for the build job (`needs: build-image-front`),
   - Logs in to Azure,
   - Bootstraps AKS (cluster + ingress),
   - Applies Kubernetes manifests,
   - Patches the Ingress with the actual external IP.

This separation is good practice:

- build job is independent and cacheable,
- deploy job only runs if build succeeds,
- you can later add tests between build and deploy.
