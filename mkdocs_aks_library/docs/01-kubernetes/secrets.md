# Secrets

A **Secret** stores sensitive data:

- passwords,
- API keys,
- connection strings.

Key points:

- Stored base64-encoded in etcd (not encryption by default; need additional setup for real at-rest encryption).
- Must be protected via RBAC.
- Same usage patterns as ConfigMaps:
  - env vars,
  - mounted as files.

In this project:

- A Secret is used to store MySQL credentials for the DB Deployment.
- The API and DB Deployments read those credentials from the Secret instead of hard-coding them in YAML.
