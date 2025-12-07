# OCI Image Policy (GHCR)

Using GHCR (GitHub Container Registry) as your image source:

- Keeps images close to your code repository.
- Integrates well with GitHub Actions.
- Allows fine-grained access control via:
  - repository permissions,
  - personal access tokens (PATs),
  - GitHub Environments if needed.

Best practices:

- Use immutable tags for releases (e.g. `v1.2.3`) in addition to `latest`.
- Restrict who can push images.
- Avoid pulling images from random public registries in production clusters.
