# MCP Kubernetes Server — SwarmSRE Execution Gateway 🔐

**Kubernetes RBAC manifests and deployment for the Model Context Protocol (MCP) server.**

The MCP server acts as the secure execution gateway between the SwarmSRE Control Plane and target Kubernetes clusters. It enforces strict least-privilege RBAC to ensure AI agents cannot perform destructive operations.

## RBAC Model

SwarmSRE uses a two-tier RBAC model:

| ServiceAccount | Purpose | Verbs |
|---|---|---|
| `swarmsre-mcp-readonly` | Investigation (Phase 1 — MVP) | `get`, `list`, `watch` |
| `swarmsre-mcp-operator` | Non-destructive remediation (Phase 2) | `get`, `list`, `watch`, `patch`, `update` |

**Neither account may `delete`, `create` namespaces, or `escalate` privileges.**

## Quick Start

```bash
# Deploy the readonly MCP server into swarmsre-system
./scripts/deploy.sh

# Verify RBAC is correctly configured
./scripts/verify-rbac.sh
```

## Files

```
k8s/
├── mcp-rbac-readonly.yaml      # ServiceAccount + ClusterRole + Binding (readonly)
├── mcp-rbac-operator.yaml      # ServiceAccount + ClusterRole + Binding (operator)
└── mcp-server-deployment.yaml  # Deployment + Service for the MCP server
scripts/
├── deploy.sh                   # Idempotent deployment script
└── verify-rbac.sh              # RBAC verification commands
```

## License

Apache-2.0