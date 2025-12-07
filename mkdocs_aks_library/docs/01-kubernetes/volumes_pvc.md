# Volumes & PersistentVolumeClaims

Containers are ephemeral; their local filesystem disappears when Pods die.  
**Volumes** and **PersistentVolumeClaims (PVCs)** solve this.

- A **Volume** is storage attached to a Pod.
- A **PersistentVolume (PV)** is a piece of storage in the cluster (disk on Azure, NFS, etc.).
- A **PersistentVolumeClaim (PVC)** is a request for a PV with specific size and access mode.

Flow:

1. You create a PVC (e.g., `mysql-pvc` with 20Gi).
2. Kubernetes binds it to a PV (backed by an Azure Disk via a StorageClass).
3. The Pod mounts the PVC and can read/write data.
4. When the Pod is deleted, the data persists in the PV.

In your project:

- The MySQL Deployment mounts a PVC so that DB data is not lost when the Pod is restarted.
