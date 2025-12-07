# Pushing Images to GHCR

GHCR (GitHub Container Registry) is used to host your Docker images.

Steps in your pipeline:

1. Login:

```yaml
- uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

2. Build:

```bash
docker build -t ghcr.io/${{ github.repository_owner }}/streamlit-front:latest .
```

3. Push:

```bash
docker push ghcr.io/${{ github.repository_owner }}/streamlit-front:latest
```

Later, your Kubernetes Deployment uses:

```yaml
image: ghcr.io/<owner>/streamlit-front:latest
imagePullSecrets:
  - name: ghcr-secret
```

with `ghcr-secret` created from the same credentials.
