# CHECK DASHBOARD COMPLET – Streamlit + FastAPI + MySQL + Ingress

## 🔗 Lien Front
👉 **Front Streamlit : https://placeholder.nip.io**

---

## 🧪 1 — Vérification des Endpoints

### 🎨 FRONT — Streamlit
- `curl -I https://placeholder.nip.io`
- `curl -I https://placeholder.nip.io/streamlit/healthz`

### ⚙️ API — FastAPI
- `curl -I https://placeholder.nip.io/api`
- `curl https://placeholder.nip.io/api/health`
- `curl https://placeholder.nip.io/api/predict -X POST -d '{}'`

### API interne (ClusterIP)
```
kubectl exec -it <pod-front> -- curl http://api:5000/health
```

---

## 🛢️ 2 — MySQL
- `kubectl exec -it <pod-api> -- nslookup mysql`
- `kubectl exec -it <pod-api> -- mysql -h mysql -u user -p -e "SELECT 1;"`

---

## 🚀 3 — Services K8s
```
kubectl get ingress -n sbuasa
kubectl describe ingress front-ingress -n sbuasa
kubectl get svc -n sbuasa
```

---

## 🧱 4 — Déploiements
```
kubectl get deploy -n sbuasa
kubectl describe deploy front-deployment -n sbuasa
kubectl describe deploy api-deployment -n sbuasa
kubectl describe deploy mysql -n sbuasa
```

---

## 🧵 5 — Logs
- `kubectl logs deploy/front-deployment -n sbuasa`
- `kubectl logs deploy/api-deployment -n sbuasa`
- `kubectl logs statefulset/mysql -n sbuasa`

---

## 🔐 6 — Secrets
```
kubectl get secret -n sbuasa
kubectl describe secret mysql-secret -n sbuasa
```

---

## 📡 7 — Communication FRONT → API
```
kubectl exec -it $(kubectl get pod -n sbuasa -l app=front -o jsonpath='{.items[0].metadata.name}') -n sbuasa -- curl http://api:5000/health
```

---

## 🌍 8 — DNS Public
```
nslookup placeholder.nip.io
```

---

## 📊 9 — Health Dashboard Synthétique
| Composant | État | Commande |
|----------|------|----------|
| Front | 🔵 | curl -I / |
| API | 🔵 | curl /api/health |
| DB | 🔵 | SELECT 1 |
| Ingress | 🔵 | describe ingress |
| DNS | 🔵 | nslookup nip.io |
| front → api | 🔵 | curl internal |
| Secrets | 🔵 | get secret |

---

## 🎁 10 — Version courte
**Tous les services fonctionnent : front, API, DB, ingress, DNS, communications internes.**  
👉 **Front : https://placeholder.nip.io**
