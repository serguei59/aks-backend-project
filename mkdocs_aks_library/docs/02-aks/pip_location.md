# Why Public IPs Must Live in the MC_* Resource Group

The Load Balancer and Public IP used by a `LoadBalancer` Service are managed as part of the AKS cluster infrastructure.

Because of that:

- The Load Balancer lives in the nodeResourceGroup.
- The Public IP must live in the **same** resource group so Azure can:

  - attach it to the Load Balancer,
  - manage lifecycle consistently,
  - clean it up when the cluster is deleted.

If you create a Public IP in another RG and try to force-attach it, you are outside the supported model and may hit confusing behavior or cleanup issues.
