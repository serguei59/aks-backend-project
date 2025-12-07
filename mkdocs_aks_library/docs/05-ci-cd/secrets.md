# Secrets in GitHub Actions (GHCR_PAT, AZURE_CREDENTIALS)

In the pipeline, you use several secrets:

- `GITHUB_TOKEN` or `GHCR_PAT`:
  - for authenticating with GHCR,
  - to push Docker images.
- `AZURE_CREDENTIALS`:
  - JSON with service principal credentials,
  - used by `azure/login@v1` to obtain an access token.

Key rules:

- Never hard-code credentials in the repository.
- Store them in GitHub Actions secrets.
- Pass them via environment variables or action inputs only.

Example (login to Azure):

```yaml
- name: Azure login
  uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}
```
