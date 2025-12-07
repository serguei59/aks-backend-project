# Why JSON Patch Instead of Merge Patch

Kubernetes supports multiple patch types:

- strategic merge (not supported for Ingress),
- merge patch,
- JSON Patch (RFC 6902).

Ingress uses arrays (like `spec.rules`), and with merge patch:

- updating `spec.rules` replaces the whole array,
- you risk deleting paths or other hosts by accident.

With **JSON Patch** you can safely target a single field:

```bash
kubectl patch ingress front-ingress -n sbuasa   --type='json'   -p='[
    {"op": "replace",
     "path": "/spec/rules/0/host",
     "value": "EXTERNAL_IP.nip.io"}
  ]'
```

This:

- modifies only the first rule’s `host`,
- leaves paths, annotations, TLS, and other settings untouched.

That’s why JSON Patch is the safest choice for patching Ingress resources in CI/CD.
