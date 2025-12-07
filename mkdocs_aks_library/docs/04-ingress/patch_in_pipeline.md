# Why We Patch the Ingress in the Pipeline

The Ingress host depends on the **external IP** of the Load Balancer:

- This IP is only known **after**:
  - the cluster is created,
  - the ingress-nginx Service of type LoadBalancer is created,
  - the Azure cloud-provider has reconciled the Load Balancer.

Therefore:

- You cannot hard-code the host in the YAML ahead of time.
- You must:
  1. Deploy nginx-ingress,
  2. Wait for `EXTERNAL_IP` of `ingress-nginx-controller`,
  3. Patch the Ingress to set `host: ${EXTERNAL_IP}.nip.io`.

That patch is what your GitHub Actions pipeline does.  
It is a natural pattern for dynamic environments where you don’t have a fixed DNS record for each environment.
