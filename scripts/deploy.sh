#!/bin/bash
# deploy.sh — Idempotent deployment of the MCP server with RBAC
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "═══════════════════════════════════════════════"
echo "  🔐 MCP Kubernetes Server Deployment"
echo "═══════════════════════════════════════════════"

# Step 1: Apply RBAC (readonly by default)
echo "📋 Applying readonly RBAC manifests..."
kubectl apply -f "${DIR}/k8s/mcp-rbac-readonly.yaml"

# Step 2: Deploy MCP server
echo "🚀 Deploying MCP Kubernetes Server..."
kubectl apply -f "${DIR}/k8s/mcp-server-deployment.yaml"

# Step 3: Wait for ready
echo "⏳ Waiting for MCP server to be ready..."
kubectl wait --for=condition=Available=True \
  deployment/mcp-kubernetes-server \
  -n swarmsre-system \
  --timeout=120s

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅ MCP Server Deployed Successfully!"
echo "═══════════════════════════════════════════════"
kubectl get pods -n swarmsre-system
echo ""
echo "  Access via: kubectl port-forward svc/mcp-kubernetes-server 3000:3000 -n swarmsre-system"

# Step 4: Verify RBAC
echo ""
bash "${DIR}/scripts/verify-rbac.sh"
