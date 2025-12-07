# Ingress YAML Structure

A basic Ingress for your Streamlit frontend looks like this:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: front-ingress
  namespace: sbuasa
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: YOUR_IP.nip.io
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: front-service
                port:
                  number: 8501
```

Important elements:

- `ingressClassName: nginx`  
  tells Kubernetes which controller should handle this Ingress.

- `annotations`  
  configure behavior specific to nginx-ingress (e.g., disable HTTPS redirect, rewrite path).

- `rules.host`  
  is the **public host** (FQDN, can be `<IP>.nip.io`).

- `backend.service`  
  points to your **internal Service** (ClusterIP) and port.
