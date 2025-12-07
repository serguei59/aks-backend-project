# AKS Backend–Frontend Project  
Technical Documentation Library

This documentation provides a **practical and opinionated reference** built from the AKS Backend–Frontend project.

Repository:
👉 https://github.com/serguei59/aks-backend-project

---

## 🎯 Purpose of this Documentation

This is **not a theory book**.

It is a **technical notebook**, designed to answer real questions such as:

- What does this Kubernetes object really do?
- Where does this resource live in Azure?
- What is the full request path from browser to Pod?
- Why is this flag required in Helm or CI/CD?

You can read it sequentially or jump directly to what you need while debugging.

---

## 📚 Covered Topics

- **Kubernetes Fundamentals**
  Pods, Services, Deployments, ConfigMaps, Secrets, Volumes

- **AKS Specifics**
  nodeResourceGroup, Azure Load Balancer, Public IPs

- **Networking**
  ClusterIP vs NodePort vs LoadBalancer, DNS, NAT, probes

- **Ingress**
  ingress-nginx, publishService, nip.io, dynamic patching

- **CI/CD**
  GitHub Actions, GHCR, AKS deployment strategies

- **Architecture & Best Practices**
  Security, separation of concerns, scaling

---

## 🧠 Philosophy

This documentation exists because:

> “Things that hurt to understand the first time  
should never hurt again.”

Use it as a **living reference**, evolve it, reuse it across projects.

---

## 📦 Related Project

This documentation is based on the following deployment:

- Streamlit frontend
- FastAPI backend
- MySQL database
- Azure Kubernetes Service
- GitHub Actions CI/CD
- ingress-nginx

See the full project here:
👉 https://github.com/serguei59/aks-backend-project

