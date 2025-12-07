# Public Host vs Internal Service

A very common confusion:

- **Public host**: what the user types in the browser.
  - e.g. `51.103.75.78.nip.io`
  - Handled by ingress and Load Balancer.

- **Internal service**: where traffic is actually sent inside the cluster.
  - e.g. `front-service:8501`
  - Not directly accessible from the internet.

The Ingress is the **bridge**:

```text
Host: 51.103.75.78.nip.io
  └─> front-ingress rule
       └─> backend: front-service:8501
            └─> Streamlit Pod
```

Your frontend code does **not** need to know the public host.  
It just listens on `0.0.0.0:8501`.  
The ingress and Load Balancer handle the outside world.
