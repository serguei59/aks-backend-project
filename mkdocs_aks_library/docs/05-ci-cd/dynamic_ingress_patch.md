# Dynamic Ingress Patching

Our GitHub Actions workflow:

1. Bootstraps AKS and installs ingress-nginx.
2. Waits for `ingress-nginx-controller` to get an external IP.
3. Patches `front-ingress` with `host: EXTERNAL_IP.nip.io`.

This pattern allows us to:

- Work in ephemeral clusters or dynamic environments.
- Avoid hard-coding domain names.
- Still use host-based routing and nip.io.

It is a pragmatic compromise between full GitOps and the real-world need for dynamic environment provisioning.
