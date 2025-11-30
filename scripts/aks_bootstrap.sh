#!/bin/bash
set -e

RG="RG_AKS_SBUASA"
AKS="cluster-sbuasa"
LOCATION="francecentral"

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
echo "🔍 Determining AKS node resource group (MC_..)"
NODE_RG=$(az aks show -g $RG -n $AKS --query nodeResourceGroup -o tsv)
echo "✔ nodeResourceGroup = $NODE_RG"

############################################
# INSTALL NGINX INGRESS CONTROLLER (Helm)
############################################
echo "🌐 Installing ingress-nginx using Azure-managed Public IP..."

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.publishService.enabled=true

############################################
# WAIT FOR INGRESS CONTROLLER READY
############################################
echo "⏳ Waiting for ingress controller to become Ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=300s

############################################
# WAIT FOR LB TO OBTAIN AUTOMATIC IP
############################################
echo "⏳ Waiting for LoadBalancer to receive IP...."

INGRESS_IP=""
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
  kubectl get svc -n ingress-nginx ingress-nginx-controller -o yaml
  exit 1
fi

echo "==============================================="
echo "🎉 AKS BOOTSTRAP COMPLETED SUCCESSFULLY"
echo "🌐 Ingress IP: $INGRESS_IP"
echo "==============================================="
