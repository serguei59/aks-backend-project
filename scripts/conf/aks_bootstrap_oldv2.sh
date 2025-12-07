#!/bin/bash
set -e

RG="RG_AKS_SBUASA"
AKS="cluster-sbuasa"
LOCATION="francecentral"

echo "==============================================="
echo "🔧 AKS BOOTSTRAP SCRIPT — START"
echo "==============================================="

############################################
# RESOURCE GROUP
############################################
echo "🔍 Checking Resource Group..."
if ! az group show -n $RG >/dev/null 2>&1; then
  echo "➡️ Creating Resource Group..."
  az group create -n $RG -l $LOCATION
else
  echo "✔️ Resource Group already exists."
fi

############################################
# AKS CLUSTER
############################################
echo "🔍 Checking AKS cluster..."
if ! az aks show -g $RG -n $AKS >/dev/null 2>&1; then
  echo "➡️ Creating AKS cluster (may take several minutes)..."
  az aks create \
    -g $RG \
    -n $AKS \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys
else
  echo "✔️ AKS cluster already exists."
fi

echo "🔐 Getting AKS credentials..."
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

############################################
# WAIT FOR NODES
############################################
echo "⏳ Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s

############################################
# INGRESS-NGINX NAMESPACE
############################################
echo "🔍 Checking ingress-nginx namespace..."
if ! kubectl get namespace ingress-nginx >/dev/null 2>&1; then
  echo "➡️ Creating namespace ingress-nginx..."
  kubectl create namespace ingress-nginx
else
  echo "✔️ Namespace ingress-nginx already exists."
fi

############################################
# INSTALL INGRESS CONTROLLER (helm)
############################################
echo "🌐 Checking NGINX Ingress Controller..."
if ! kubectl get deployment ingress-nginx-controller -n ingress-nginx >/dev/null 2>&1; then
  echo "➡️ Adding Helm repository for ingress-nginx..."
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update

  echo "➡️ Installing ingress-nginx controller..."
  helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --set controller.publishService.enabled=true
else
  echo "✔️ NGINX ingress controller already installed."
fi

echo "⏳ Waiting for ingress controller deployment to become Ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=300s

############################################
# CREATE OR REUSE A PUBLIC IP IN nodeResourceGroup (MC_...)
############################################
echo "🔍 Determining AKS node resource group (nodeResourceGroup)..."
NODE_RG=$(az aks show -g $RG -n $AKS --query nodeResourceGroup -o tsv)
if [[ -z "$NODE_RG" ]]; then
  echo "❌ Could not determine nodeResourceGroup. Aborting."
  exit 1
fi
echo "✔ nodeResourceGroup = $NODE_RG"

PIP_NAME="sbuasa-nginx-pip"

# create public ip if not exists
if ! az network public-ip show -g "$NODE_RG" -n "$PIP_NAME" >/dev/null 2>&1; then
  echo "➡️ Creating Public IP '$PIP_NAME' in resource group $NODE_RG..."
  az network public-ip create \
    --resource-group "$NODE_RG" \
    --name "$PIP_NAME" \
    --sku Standard \
    --allocation-method Static \
    --query "publicIp.ipAddress" -o tsv >/dev/null
  echo "✔ Public IP resource created: $PIP_NAME (in $NODE_RG)"
else
  echo "✔ Public IP $PIP_NAME already exists in $NODE_RG"
fi

# Annotate the ingress service to use this PIP (this will instruct Azure LB to use the given public ip)
echo "➡️ Annotating ingress-nginx service to use PIP '$PIP_NAME'..."
kubectl -n ingress-nginx patch svc ingress-nginx-controller \
  -p "{\"metadata\": {\"annotations\": {\"service.beta.kubernetes.io/azure-pip-name\": \"$PIP_NAME\"}}}" || true

# Wait for the LoadBalancer to get an external IP
echo "⏳ Waiting for public LoadBalancer IP..."
INGRESS_IP=""
for i in {1..40}; do
  INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  if [[ -n "$INGRESS_IP" && "$INGRESS_IP" != "null" ]]; then
    echo "✔️ Ingress public IP: $INGRESS_IP"
    break
  fi
  echo "⏳ LoadBalancer IP not assigned yet (attempt $i/40)..."
  sleep 15
done

if [[ -z "$INGRESS_IP" ]]; then
  echo "❌ Could not obtain the Ingress LoadBalancer IP after waiting. Inspect the service and Azure PIP."
  kubectl get svc ingress-nginx-controller -n ingress-nginx -o yaml
  exit 1
fi

echo #!/bin/bash
set -e

RG="RG_AKS_SBUASA"
AKS="cluster-sbuasa"
LOCATION="francecentral"
PIP_NAME="sbuasa-nginx-pip"

echo "==============================================="
echo "🔧 AKS BOOTSTRAP SCRIPT — START (Corrected)"
echo "==============================================="

############################################
# RESOURCE GROUP
############################################
echo "🔍 Checking Resource Group..."
if ! az group show -n $RG >/dev/null 2>&1; then
  echo "➡️ Creating Resource Group..."
  az group create -n $RG -l $LOCATION
else
  echo "✔️ Resource Group already exists."
fi

############################################
# AKS CLUSTER
############################################
echo "🔍 Checking AKS cluster..."
if ! az aks show -g $RG -n $AKS >/dev/null 2>&1; then
  echo "➡️ Creating AKS cluster..."
  az aks create \
    -g $RG \
    -n $AKS \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys
else
  echo "✔️ AKS cluster already exists."
fi

echo "🔐 Getting AKS credentials..."
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

############################################
# WAIT FOR NODES
############################################
echo "⏳ Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s

############################################
# DETERMINE NODE RESOURCE GROUP
############################################
echo "🔍 Determining AKS node resource group (MC_...)"
NODE_RG=$(az aks show -g $RG -n $AKS --query nodeResourceGroup -o tsv)
echo "✔ nodeResourceGroup = $NODE_RG"

############################################
# CREATE / RETRIEVE PUBLIC IP FOR INGRESS
############################################
echo "🔍 Ensuring Public IP exists in $NODE_RG..."

if ! az network public-ip show -g "$NODE_RG" -n "$PIP_NAME" >/dev/null 2>&1; then
  echo "➡️ Creating Public IP '$PIP_NAME'..."
  az network public-ip create \
    --resource-group "$NODE_RG" \
    --name "$PIP_NAME" \
    --sku Standard \
    --allocation-method Static \
    --query "publicIp.ipAddress" -o tsv >/dev/null
else
  echo "✔️ Public IP already exists."
fi

echo "🔍 Retrieving Public IP address..."
PIP=$(az network public-ip show -g "$NODE_RG" -n "$PIP_NAME" --query "ipAddress" -o tsv)
echo "✔️ Public IP = $PIP"

############################################
# INSTALL NGINX INGRESS CONTROLLER (Helm)
############################################
echo "🌐 Installing ingress-nginx with Static Public IP..."

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.publishService.enabled=true \
  --set controller.service.loadBalancerIP="$PIP" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-pip-name"="$PIP_NAME"

############################################
# WAIT FOR INGRESS CONTROLLER READY
############################################
echo "⏳ Waiting for ingress controller to become Ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=300s

############################################
# WAIT FOR LB TO OBTAIN IP
############################################
echo "⏳ Waiting for LoadBalancer to receive IP..."

for i in {1..40}; do
  INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)

  if [[ -n "$INGRESS_IP" && "$INGRESS_IP" != "null" ]]; then
    echo "✔️ Ingress LoadBalancer IP = $INGRESS_IP"
    break
  fi

  echo "⏳ Waiting... (attempt $i/40)"
  sleep 10
done

if [[ -z "$INGRESS_IP" ]]; then
  echo "❌ ERROR: Ingress LoadBalancer IP could not be retrieved."
  kubectl get svc -n ingress-nginx ingress-nginx-controller -o wide
  exit 1
fi

echo "==============================================="
echo "🎉 AKS BOOTSTRAP COMPLETED SUCCESSFULLY"
echo "🌐 Ingress IP: $INGRESS_IP"
echo "==============================================="

echo "🎉 AKS BOOTSTRAP COMPLETED SUCCESSFULLY! (INGRESS IP: $INGRESS_IP)"
echo "==============================================="
