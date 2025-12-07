# How AKS Manages Public IPs

For a LoadBalancer Service:

- If you do not specify an IP or annotation:
  - Azure creates a Public IP automatically in the nodeResourceGroup.
- If you want to use your own static IP:
  - you create a Public IP resource yourself in the nodeResourceGroup,
  - you reference it via annotations / Helm values (e.g. `service.beta.kubernetes.io/azure-pip-name` and `loadBalancerIP`).

Key principle:

- **Public IPs used by AKS LoadBalancers must live in the same nodeResourceGroup**.
- The IP associated with your ingress-nginx Service is the one exposed on the internet.
