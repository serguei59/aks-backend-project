#!/usr/bin/env bash
set -e

NAMESPACE="sbuasa"
ING_NAME="front-ingress"

echo "📡 Récupération de l'IP publique du Ingress…"
ING_IP=$(kubectl get ingress $ING_NAME -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$ING_IP" ]; then
  echo "❌ Impossible de récupérer l'IP du Ingress."
  exit 1
fi

echo "🌐 Ingress IP : $ING_IP"

# Construction des URLs
FRONT_URL="http://$ING_IP.nip.io/"
API_BASE="http://api.$NAMESPACE.svc.cluster.local:5000"

echo "🌐 Front     : $FRONT_URL"
echo "🌐 API (interne cluster) : $API_BASE"

echo ""
echo "=============================="
echo "        🔍 TEST API"
echo "=============================="

echo "➡️  Test healthcheck : $API_BASE/health"
curl -s -o /dev/null -w "HTTP %{http_code}\n" "$API_BASE/health"
echo ""

echo "➡️  Test GET /clients"
curl -s -o /dev/null -w "HTTP %{http_code}\n" "$API_BASE/clients"
echo ""

echo "➡️  Test POST /clients"
curl -s -X POST -H "Content-Type: application/json" \
    -d '{"first_name":"Test","last_name":"User","email":"auto-'$(date +%s)'@test.com"}' \
    -o /dev/null -w "HTTP %{http_code}\n" \
    "$API_BASE/clients"
echo ""

echo "➡️  Test DELETE /clients/1"
curl -s -X DELETE -o /dev/null -w "HTTP %{http_code}\n" "$API_BASE/clients/1"
echo ""

echo ""
echo "=============================="
echo "    🎯 URL FRONT ACCESSIBLE"
echo "=============================="
echo "👉 $FRONT_URL"
echo ""
echo "➡️  Clique ici pour ouvrir le dashboard (Streamlit) :"
echo "   $FRONT_URL"
