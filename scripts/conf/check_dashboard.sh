#!/bin/bash

set -e

NAMESPACE="sbuasa"
INGRESS_NAME="front-ingress"

echo "📡 Récupération de l'IP publique du Ingress..."
EXTERNAL_IP=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$EXTERNAL_IP" ]; then
  echo "❌ Impossible de récupérer l'External IP."
  exit 1
fi

BASE_URL="http://${EXTERNAL_IP}.nip.io"
API_BASE="${BASE_URL}/sbuasa"
FRONT_URL="${BASE_URL}/sbuasa-streamlit"

echo "🌐 Ingress IP : $EXTERNAL_IP"
echo "🌐 API Base  : $API_BASE"
echo "🌐 Front     : $FRONT_URL"

echo ""
echo "=============================="
echo "        🔍 TEST API"
echo "=============================="

test_endpoint() {
  local url=$1
  local label=$2

  echo -n "➡️  Test $label ($url) ... "

  http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo "✔️  OK ($http_code)"
  else
    echo "❌ FAIL ($http_code)"
    exit 1
  fi
}

# Endpoints à tester
test_endpoint "${API_BASE}/health" "Healthcheck"
test_endpoint "${API_BASE}/clients" "Liste clients"
test_endpoint "${API_BASE}" "API root"

echo ""
echo "=============================="
echo "     🖥️  TEST FRONT STREAMLIT"
echo "=============================="

http_code=$(curl -s -o /dev/null -w "%{http_code}" "$FRONT_URL")

if [ "$http_code" = "200" ]; then
  echo "✔️  Streamlit accessible"
else
  echo "❌ Streamlit renvoie un code anormal ($http_code)"
  exit 1
fi

echo ""
echo "=============================="
echo "       ✅ TOUT EST OK"
echo "=============================="
echo "API et front sont accessibles via l'ingress."
