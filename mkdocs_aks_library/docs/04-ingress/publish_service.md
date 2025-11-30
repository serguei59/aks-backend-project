# publishService.enabled=true Explained

The Helm value:

```bash
--set controller.publishService.enabled=true
```

tells the nginx ingress controller to **publish its Service information** so the cloud-provider can:

- detect which Service represents the ingress endpoint,
- assign / manage the external Load Balancer correctly,
- keep `.status.loadBalancer.ingress[0].ip` in sync.

Without this flag:

- The controller does not expose the right status.
- The Azure cloud-provider may not attach the Load Balancer properly.
- You often end up with no external IP or a partially configured setup.

With this flag enabled:

- `kubectl get svc -n ingress-nginx ingress-nginx-controller -o yaml`  
  will show an updated `status.loadBalancer.ingress.ip`,
- which is exactly what you use in your CI/CD to build `EXTERNAL_IP.nip.io`.
