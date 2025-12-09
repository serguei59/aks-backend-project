# Secrets Management in Workflow Orchestration
*(GitHub Actions – reusable workflows)*

---

## Context

In this project, the CI/CD is split into **multiple reusable workflows**:

- one workflow to deploy **documentation (MkDocs → GitHub Pages)**,
- one workflow to deploy the **AKS infrastructure and application stack**,
- and **one orchestration workflow** that coordinates them.

This architecture improves:
- readability,
- separation of concerns,
- reuse across projects.

However, it introduces an important concept:
👉 **how secrets and permissions are propagated across workflows**.

---

## The Problem

When a workflow **calls another workflow** using:

```yaml
uses: ./.github/workflows/xxx.yaml
```

**secrets are NOT automatically available** in the called workflow.

This typically results in errors such as:

```text
Login failed with Error: Using auth-type: SERVICE_PRINCIPAL.
Not all values are present. Ensure 'client-id' and 'tenant-id' are supplied.
```

Even though the secret exists at the repository level.

---

## Why This Happens

GitHub Actions enforces **strong isolation** between workflows.

- A **top-level (orchestrator) workflow** has access to repository secrets.
- A **called workflow** runs in its own execution context.
- By default:
  - it does **not** receive secrets,
  - it does **not** inherit permissions.

This is a **security feature**, not a bug.

---

## The Solution: `secrets: inherit`

To explicitly propagate all secrets from the caller to the called workflow, you must use:

```yaml
secrets: inherit
```

### Example (Orchestration Workflow)

```yaml
jobs:
  deploy-aks:
    uses: ./.github/workflows/ci-cd.yaml
    secrets: inherit
```

This allows the called workflow to access:

- `AZURE_CREDENTIALS`
- `GHCR_PAT`
- any other repository secret

✅ This is mandatory when using:
- `azure/login`
- Terraform
- kubectl against cloud resources
- container registries

---

## Permissions: Another Critical Aspect

Secrets alone are **not enough**.

Reusable workflows are also constrained by **permissions boundaries**.

### Example

If the called workflow requires:

```yaml
permissions:
  contents: write
```

Then the orchestrator workflow must explicitly allow it:

```yaml
permissions:
  contents: write
  pages: write
  id-token: write
  packages: write
```

Otherwise, GitHub rejects the run with errors like:

```text
The workflow is requesting 'contents: write',
but is only allowed 'contents: read'
```

---

## Pattern Used in This Project

### Orchestration Workflow

```yaml
permissions:
  contents: write
  pages: write
  id-token: write
  packages: write

jobs:
  deploy-docs:
    uses: ./.github/workflows/mkdocs-deploy.yaml

  deploy-aks:
    needs: deploy-docs
    uses: ./.github/workflows/ci-cd.yaml
    secrets: inherit
```

### Called Workflow (`ci-cd.yaml`)

```yaml
- name: Azure login
  uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}
```

✅ Result:
- Azure authentication works
- No secret duplication
- No hardcoded credentials
- Single source of truth

---

## Why This Design Is Clean

✅ **Security**  
Secrets remain:
- encrypted by GitHub,
- scoped to workflows,
- never exposed in logs.

✅ **Maintainability**  
Secrets are defined **once** at repository level.
Reusable workflows remain portable.

✅ **Scalability**  
This pattern naturally supports:
- multiple environments (dev / prod),
- Terraform-based provisioning,
- multi-cloud CI/CD pipelines.

---

## Common Mistakes to Avoid

❌ Assuming secrets are shared automatically  
❌ Redefining secrets in every workflow  
❌ Hardcoding credentials in YAML  
❌ Forgetting permissions alignment  
❌ Debugging cloud login errors without checking secret inheritance

---

## Key Takeaway

> **Reusable workflows require explicit secret and permission propagation.**  
> `secrets: inherit` is the standard, secure, and recommended solution for orchestration.

This project demonstrates a **production-grade GitHub Actions CI/CD pattern** aligned with best practices.

