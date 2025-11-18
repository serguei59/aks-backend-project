# Azure Credentials Setup Guide for CI/CD on AKS

This document explains how to configure Azure credentials to run the
GitHub Actions CI/CD pipeline for deploying AKS, Ingress, backend
services, and the Streamlit frontend.

## 1. Prerequisites

-   Azure account
-   Azure subscription with Contributor access
-   GitHub repository (your fork/clone)

## 2. Create an Azure Service Principal

Run the following:

``` bash
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"

az ad sp create-for-rbac   --name "github-aks-deployer"   --role contributor   --scopes /subscriptions/<YOUR_SUBSCRIPTION_ID>   --sdk-auth
```

This returns a JSON block. Keep it safe.

## 3. Add Credentials to GitHub Secrets

-   Go to **Settings → Secrets and variables → Actions**
-   Create a secret named:

```{=html}
<!-- -->
```
    AZURE_CREDENTIALS

-   Paste the Service Principal JSON.

This is used by the workflow:

``` yaml
- uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}
```

## 4. Trigger Deployment

Push to:

    feature/k8s
    main

The pipeline will: - Authenticate to Azure - Deploy the Resource Group
(if missing) - Deploy AKS - Install Ingress Controller - Apply
Kubernetes manifests

## 5. Important Notes

-   Each user/reviewer must use **their own** Azure credentials.
-   Credentials **must not** be shared.
-   The project cannot deploy without `AZURE_CREDENTIALS`.
