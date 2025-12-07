
# AKS Troubleshooting Guide  
Comprehensive troubleshooting reference for Azure Kubernetes Service (AKS)

---

## 1. Diagnose Ingress & Load Balancer Issues

### ❌ External IP stuck at `<pending>`
Check the LoadBalancer service:

```bash
kubectl get svc ingress-nginx-controller -n ingress-nginx
```

Possible causes:

1. **Missing Helm parameter**
   ```bash
   --set controller.publishService.enabled=true
   ```

2. Azure Public IP quota exceeded  
3. Wrong resource group for Public IP  
4. Network policy preventing connectivity (rare)

---

### ❌ Ingress created but not routing traffic
Describe the Ingress:

```bash
kubectl describe ingress front-ingress -n sbuasa
```

Check for:

- Wrong `host`
- Wrong `path`
- Wrong service name or port
- Missing ingressClass (`ingressClassName: nginx`)

Then check nginx logs:

```bash
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller
```

---

## 2. Service & Networking Troubleshooting

### ❌ Service does not route to Pods
Check endpoints:

```bash
kubectl get endpoints front-service -n sbuasa
```

If empty:

- Pod labels do not match Service selector  
- Pods are not Ready (probe failures)

---

### ❌ Pod is running but failing readiness/liveness probes
Describe Pod:

```bash
kubectl describe pod <pod> -n sbuasa
```

Check:

- readinessProbe path  
- livenessProbe port  
- container startup time  
- slow DB/API initialization  

---

## 3. Deployment & Image Troubleshooting

### ❌ ImagePullBackOff
Check:

```bash
kubectl describe pod <pod>
```

Likely reasons:

- Wrong image name  
- Missing imagePullSecret  
- GHCR PAT incorrect  

Fix secret:

```bash
kubectl create secret docker-registry ghcr-secret   --docker-server=ghcr.io   --docker-username=<USER>   --docker-password=<TOKEN>   -n sbuasa
```

---

### ❌ CrashLoopBackOff
Check logs:

```bash
kubectl logs <pod> -n sbuasa
```

Most common causes:

- App cannot reach DB  
- Wrong environment variables  
- Database not ready at startup  
- Missing dependencies in image  

---

## 4. MySQL Troubleshooting

### ❌ DB Pod stuck in Pending
Probably PVC issue:

```bash
kubectl get pvc -n sbuasa
kubectl describe pvc mysql-pvc -n sbuasa
```

Check:

- StorageClass exists  
- Azure Disk quota ok  
- PVC bound correctly  

---

### ❌ App cannot connect to DB
Exec into API or FE:

```bash
kubectl exec -it <api-pod> -n sbuasa -- env | grep MYSQL
```

Verify:

- host = `mysql`
- port = `3306`
- correct password (stored in secret)

Test connection:

```bash
kubectl exec -it <api-pod> -- nc -zv mysql 3306
```

---

## 5. API / Frontend Troubleshooting

### ❌ Frontend cannot reach API
Exec inside FE container:

```bash
kubectl exec -it <frontend-pod> -n sbuasa -- curl api:5000/health
```

If failing:

- Wrong `API_URL` environment variable  
- API Service name mismatch  
- API Pod not Ready  

---

### ❌ API returns 500 errors
Check API logs:

```bash
kubectl logs deploy/api -n sbuasa
```

Check environment variables:

```bash
kubectl describe deploy/api -n sbuasa
```

---

## 6. AKS Cluster-Level Troubleshooting

### ❌ Nodes NotReady
```bash
kubectl get nodes
kubectl describe node <node>
```

Typical causes:

- VMSS scaling failure  
- Out of disk space  
- Network CNI restart  
- AKS upgrade in progress  

---

### ❌ Pod Pending (unschedulable)
```bash
kubectl describe pod <pod> -n sbuasa
```

Causes:

- Not enough CPU/Memory  
- Node pool taints  
- Missing storage (PVC)  
- Affinity/anti-affinity constraints  

---

## 7. GitHub Actions Troubleshooting

### ❌ Pipeline fails at Azure login
Check:

- Secret `AZURE_CREDENTIALS` present  
- JSON valid  
- SP has Contributor role  

---

### ❌ kubectl cannot connect to cluster
Ensure AKS + kubeconfig created:

```bash
az aks get-credentials -n <cluster> -g <rg>
```

If pipeline:

- Check service principal role  
- Check AKS creation logs  

---

### ❌ Ingress patching fails
Pipeline loop shows empty IP:

- LB did not receive IP  
- Missing `publishService.enabled=true`  
- Azure Public IP quota reached  

---

# ✔ Recommended Debug Commands Cheat Sheet

```bash
kubectl get all -A
kubectl get pods -o wide
kubectl describe pod <name>
kubectl logs <pod>
kubectl logs deploy/<name>
kubectl get svc -A
kubectl get ingress -A
kubectl exec -it <pod> -- /bin/sh
kubectl port-forward svc/api 5000:5000
```

---

# ✔ Download

This file is available below.
