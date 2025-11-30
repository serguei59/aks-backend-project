# What Is the nodeResourceGroup (MC_...)?

When you create an AKS cluster, Azure automatically creates a **managed resource group**:

- Name pattern: `MC_<RG>_<AKS_NAME>_<LOCATION>`
- Example: `MC_RG_AKS_SBUASA_cluster-sbuasa_francecentral`

This group contains:

- Virtual Machine Scale Sets (nodes),
- Network interfaces,
- Disks,
- Load Balancers,
- Public IPs attached to the cluster.

You should **never delete or modify** resources here by hand unless you know exactly what you are doing.  
Your app-specific resources go into your own RG; the MC\_RG is for AKS internals.
