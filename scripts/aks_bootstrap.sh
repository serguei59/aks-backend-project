#!/bin/bash
set -e

RG="RG_AKS_SBUASA"
AKS="cluster-sbuasa"
LOCATION="francecentral"

echo "🔍 Checking Resource Group..."
if ! az group show -n $RG >/dev/null 2>&1; then
  echo "➡️ Creating Resource Group..."
  az group create -n $RG -l $LOCATION
else
  echo "✔️ Resource Group already exists."
fi

echo "🔍 Checking AKS cluster..."
if ! az aks show -g $RG -n $AKS >/dev/null 2>&1; then
  echo "➡️ Creating AKS cluster..."
  az aks create \
    -g $RG \
    -n $AKS \
    --node-count 2 \
    --enable-addons monitoring \
    --generate-ssh-keys

  echo "⏳ Waiting for AKS provisioning to complete..."
  az aks show -g $RG -n $AKS --query "provisioningState" -o tsv \
    | grep -q "Succeeded"
else
  echo "✔️ AKS cluster already exists."
fi

echo "🔐 Getting AKS credentials..."
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

echo "⏳ Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s

echo "🔍 Checking ingress-nginx namespace..."
if ! kubectl get namespace ingress-nginx >/dev/null 2>&1; then
  echo "➡️ Creating namespace ingress-nginx..."
  kubectl create namespace ingress-nginx
else
  echo "✔️ Namespace ingress-nginx already exists."
fi

echo "🌐 Checking NGINX Ingress Controller..."
if ! kubectl get deployment ingress-nginx-controller -n ingress-nginx >/dev/null 2>&1; then
  
  echo "➡️ Adding Helm repository for ingress-nginx..."
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update

  echo "➡️ Installing ingress-nginx..."
  helm install ingress-nginx ingress-nginx/ingress-nginx -n $NS
else
  echo "✔️ NGINX ingress controller already installed."
fi

echo "⏳ Waiting for ingress controller to become Ready..."
kubectl rollout status deployment/ingress-nginx-controller -n $NS --timeout=180s

echo "⏳ Waiting for public LoadBalancer IP..."
INGRESS_IP=""
for i in {1..20}; do
    INGRESS_IP=$(kubectl get svc nginx-ingress-nginx-controller -n $NS -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [[ -n "$INGRESS_IP" ]]; then
        echo "✔️ Ingress public IP: $INGRESS_IP"
        break
    fi
    echo "⏳ Still waiting for LoadBalancer IP (attempt $i/20)..."
    sleep 15
done

if [[ -z "$INGRESS_IP" ]]; then
    echo "❌ Could not obtain the Ingress LoadBalancer IP."
    exit 1
fi

echo "🎉 AKS bootstrap completed successfully!"
