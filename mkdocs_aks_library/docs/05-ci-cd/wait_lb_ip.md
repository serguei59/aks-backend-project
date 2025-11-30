# Waiting for LB External IP in Scripts

When a LoadBalancer Service is created, it can take some time for the cloud-provider to:

- allocate the Public IP,
- configure the Load Balancer,
- update the Service status.

In your script:

```bash
EXTERNAL_IP=""
for i in {1..40}; do
  EXTERNAL_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx     -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  if [[ -n "$EXTERNAL_IP" && "$EXTERNAL_IP" != "null" ]]; then
    break
  fi
  sleep 10
done
```

This loop:

- polls the Service status,
- waits up to ~400 seconds,
- fails early if the IP never appears.

Without such a loop, your pipeline might patch the Ingress with an empty host, breaking routing.
