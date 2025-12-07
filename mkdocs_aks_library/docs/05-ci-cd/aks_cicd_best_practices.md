# End-to-End AKS CI/CD Best Practices

Key guidelines for your AKS CI/CD pipeline:

1. **Separate build and deploy**
   - Build and push images in one job.
   - Deploy to AKS in another.

2. **Use GitHub Secrets for credentials**
   - Never hard-code SP or PAT tokens.
   - Rotate them regularly.

3. **Treat Kubernetes manifests as code**
   - Store them in the repo.
   - Review them like any other code.

4. **Use apply for static resources, patch for dynamic values**
   - Deployments, Services, ConfigMaps: `kubectl apply`.
   - Dynamic hostnames or IPs: `kubectl patch`.

5. **Wait for readiness**
   - Wait for LoadBalancer IPs before patching Ingress.
   - Optionally, wait for Deployments to become available.

6. **Log URLs at the end**
   - Print the final frontend URL (e.g. `http://EXTERNAL_IP.nip.io`) for quick access.
