#!/bin/bash
# verify-rbac.sh — Verify MCP server RBAC permissions
set -e

echo "🔍 Verifying RBAC permissions for swarmsre-mcp-readonly..."
echo ""

SA="system:serviceaccount:swarmsre-system:swarmsre-mcp-readonly"

# Should be ALLOWED
echo "  ✓ Can GET pods?"
kubectl auth can-i get pods --as="$SA" && echo "    → yes ✅" || echo "    → no ❌ (UNEXPECTED)"

echo "  ✓ Can LIST events?"
kubectl auth can-i list events --as="$SA" && echo "    → yes ✅" || echo "    → no ❌ (UNEXPECTED)"

echo "  ✓ Can WATCH deployments?"
kubectl auth can-i watch deployments --as="$SA" && echo "    → yes ✅" || echo "    → no ❌ (UNEXPECTED)"

echo "  ✓ Can GET pods/log?"
kubectl auth can-i get pods/log --as="$SA" && echo "    → yes ✅" || echo "    → no ❌ (UNEXPECTED)"

# Should be DENIED
echo ""
echo "  ✗ Can DELETE pods?"
kubectl auth can-i delete pods --as="$SA" && echo "    → yes ❌ (SECURITY VIOLATION!)" || echo "    → no ✅ (correctly denied)"

echo "  ✗ Can DELETE namespaces?"
kubectl auth can-i delete namespaces --as="$SA" && echo "    → yes ❌ (SECURITY VIOLATION!)" || echo "    → no ✅ (correctly denied)"

echo "  ✗ Can CREATE deployments?"
kubectl auth can-i create deployments --as="$SA" && echo "    → yes ❌ (SECURITY VIOLATION!)" || echo "    → no ✅ (correctly denied)"

echo ""
echo "✅ RBAC verification complete."
