# How Routing Works Internally

When a request hits the ingress controller, nginx uses:

- The `Host` header (e.g. `EXTERNAL_IP.nip.io`),
- The request path (e.g. `/`, `/api`, `/static`),

to select the matching Ingress rule and backend.

Example for your frontend:

- Any request with host `EXTERNAL_IP.nip.io` and path `/`:
  - is forwarded to `front-service:8501`.

You can later extend this pattern:

- `/api` → `api-service:5000`
- `/admin` → another Service
- etc.

This lets you expose multiple services behind a single Public IP and domain.
