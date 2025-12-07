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
# INSTALL INGRESS CONTROLLER
############################################
echo "🌐 Checking NGINX Ingress Controller..."
if ! kubectl get deployment ingress-nginx-controller -n ingress-nginx >/dev/null 2>&1; then
  
  echo "➡️ Adding Helm repository for ingress-nginx..."
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update

  echo "➡️ Installing ingress-nginx controller..."
  helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx

else
  echo "✔️ NGINX ingress controller already installed."
fi


############################################
# WAIT FOR INGRESS CONTROLLER
############################################
echo "⏳ Waiting for ingress controller to become Ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=300s


############################################
# GET LOAD BALANCER IP
############################################
echo "⏳ Waiting for public LoadBalancer IP..."
INGRESS_IP=""
for i in {1..20}; do
    INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    if [[ -n "$INGRESS_IP" ]]; then
        echo "✔️ Ingress public IP: $INGRESS_IP"
        break
    fi

    echo "⏳ LoadBalancer IP not assigned yet (attempt $i/20)..."
    sleep 15
done

if [[ -z "$INGRESS_IP" ]]; then
    echo "❌ Could not obtain the Ingress LoadBalancer IP."
    exit 1
fi


echo "==============================================="
echo "🎉 AKS BOOTSTRAP COMPLETED SUCCESSFULLY!"
echo "==============================================="
