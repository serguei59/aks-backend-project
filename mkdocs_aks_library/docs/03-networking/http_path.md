# Full HTTP Path: Client → Public IP → LB → Ingress → Service → Pod

For your AKS project (Streamlit frontend behind nginx-ingress), the HTTP path is:

1. **Browser / client**
   - Requests `http://EXTERNAL_IP.nip.io/`.

2. **Public Internet**
   - Routes to the Azure Public IP associated with your Load Balancer.

3. **Azure Load Balancer**
   - Receives traffic on port 80.
   - NATs it to one of the AKS nodes on a NodePort.

4. **AKS node / kube-proxy**
   - Forwards traffic to the `ingress-nginx-controller` Pod.

5. **nginx-ingress-controller**
   - Reads the `Host` header (`EXTERNAL_IP.nip.io`) and URL path.
   - Selects the matching Ingress rule.
   - Proxies to the backend `front-service:8501`.

6. **Service front-service**
   - Load-balances across Streamlit Pods.

7. **Pod (Streamlit app)**
   - Handles the HTTP request and returns a response.

Understanding this chain is crucial for debugging where traffic is lost when something goes wrong.
