# ConfigMaps

A **ConfigMap** stores non-sensitive configuration data (plain text).

Typical usages:

- Environment variables,
- Application settings (URLs, flags),
- Small configuration files.

Important:

- ConfigMaps are **not encrypted**; never put passwords or secrets inside.
- They can be:
  - mounted as files,
  - consumed as environment variables.

Example in your project:

- `front-config` (or similar) ConfigMap that sets:
  - `API_URL` used by the Streamlit frontend to call the backend API.
