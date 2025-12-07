
# Volumes & PersistentVolumeClaims (PVCs)

Containers are **ephemeral** by nature: their local filesystem is lost when a Pod
is restarted or recreated.
In Kubernetes, **Volumes** and **PersistentVolumeClaims (PVCs)** are the standard
mechanism used to persist data beyond the Pod lifecycle.

- A **Volume** is storage attached to a Pod.
- A **PersistentVolume (PV)** represents physical storage in the cluster
  (Azure Disk, NFS, etc.).
- A **PersistentVolumeClaim (PVC)** is a request for storage with a given size
  and access mode.

Typical flow:

1. A PVC is created (for example `mysql-pvc`, 1Gi, `ReadWriteOnce`).
2. Kubernetes binds the PVC to a PV (often backed by an Azure Disk via a `StorageClass`).
3. The Pod mounts the PVC (e.g. on `/var/lib/mysql`).
4. When the Pod is deleted or restarted, the data remains available in the PV.

---

## Design choice in THIS project (No PVC)

In the **current validated version of this project**, we **intentionally do NOT use
a PersistentVolumeClaim for MySQL**.

This decision was made to:

- Keep the deployment **simple and reproducible** for evaluation,
- Avoid additional Azure dependencies (managed disks),
- Reduce operational complexity and cloud cost,
- Stay aligned with the **course brief**, which does not require
  production-grade persistence.

### What this means concretely

- MySQL runs using the **official `mysql:8.4` image**
- No `PersistentVolumeClaim` is defined in `db-deployment.yaml`
- Database files are stored on the **ephemeral filesystem of the Pod**
- When the MySQL Pod is deleted or recreated, the database is reset

This behavior is **expected and accepted** for this project version.

---

## Link with SQL initialization (`init.sql`)

Instead of relying on persistent storage, this project guarantees a
**deterministic database state** using an initialization SQL script.

Mechanism:

- The official MySQL image executes all `*.sql` files located in
  `/docker-entrypoint-initdb.d/` **on first startup**, when the data directory
  is empty.
- In this project:
  - The database schema,
  - The application user,
  - The required tables,
  are created automatically by `init.sql`.

Observed in MySQL logs:

```text
[Entrypoint]: Creating database clients
[Entrypoint]: Creating user admin
[Entrypoint]: Giving user admin access to schema clients
[Entrypoint]: /docker-entrypoint-initdb.d/init.sql
```

---

## Configuration consistency (important)

The FastAPI backend connects to MySQL using environment variables provided by
Kubernetes:

```yaml
data:
  database_name: clients
  database_host: mysql
  database_port: "3306"
```

The following elements **must match exactly**:

1. Database name created in `init.sql`
2. `database_name` value in the ConfigMap
3. Database name used by the backend application

Any mismatch results in database access errors.

---

## Limitations of the current approach

This **"no PVC" design is NOT suitable for production**, because:

- All MySQL data is lost if the Pod is recreated,
- There is no long-term persistence guarantee.

However, for a learning and evaluation context, it provides:

- A clean deployment cycle,
- Predictable behavior,
- Minimal infrastructure overhead.

---

## Planned evolution (Next version)

In the **next iteration of the project**, the following improvements are planned:

1. Introduce a **PersistentVolumeClaim** backed by an Azure Disk
2. Mount the PVC on `/var/lib/mysql` in the MySQL Deployment
3. Optionally replace the official image with a **custom MySQL image**
   including controlled migrations and stricter configuration

These enhancements are intentionally **out of scope for the current version**.
