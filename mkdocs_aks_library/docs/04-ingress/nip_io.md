# nip.io Explained

`nip.io` is a wildcard DNS service that converts IP addresses into hostnames:

- `51.103.75.78.nip.io` resolves to `51.103.75.78`.
- `anything.51.103.75.78.nip.io` also resolves to `51.103.75.78`.

This is extremely convenient when:

- you do not have a real domain name yet,
- you want to test host-based routing in Kubernetes,
- you want to use Ingress with a real `Host` header, without managing DNS.

In this project:

- You patch the Ingress host with `${EXTERNAL_IP}.nip.io`.
- No manual DNS configuration is required.
