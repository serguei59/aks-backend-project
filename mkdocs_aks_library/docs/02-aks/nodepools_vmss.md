# Node Pools & VM Scale Sets (VMSS)

In AKS:

- Each **node pool** is backed by a **Virtual Machine Scale Set (VMSS)**.
- The VMSS is created inside the nodeResourceGroup.
- Scaling the node pool means scaling the VMSS instance count.

You can:

- Have multiple node pools for different workloads (e.g. system vs user),
- Use different VM sizes or SKUs,
- Taint node pools for specific workloads.

For most small to medium projects, a single node pool is enough, but understanding VMSS helps when you debug:

- scheduling issues,
- capacity problems,
- cost optimisation.
