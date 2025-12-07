# Enabling HTTPS with cert-manager

To serve HTTPS, you usually:

1. Install **cert-manager** in the cluster.
2. Create a `ClusterIssuer` (e.g. using Let's Encrypt).
3. Annotate your Ingress with TLS settings and issuer reference.

High-level steps:

- cert-manager watches Ingress resources with TLS sections,
- it creates Certificate resources,
- it performs ACME HTTP-01 challenges via a temporary Ingress/Service,
- once validated, it stores TLS certificates in Secrets,
- nginx-ingress uses those Secrets to terminate TLS.

For local or IP-based testing (with nip.io), you often start with HTTP only.  
For production, you switch to a real domain name and add cert-manager on top.
