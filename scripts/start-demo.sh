#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"

RUN_INSTALL=1
RUN_AGENT_SMOKE="${OPENCLAW_RUN_AGENT_SMOKE:-0}"

usage() {
  cat <<EOF
Usage: $0 [--no-install] [--agent-smoke]

Starts the OpenClaw-only Blender demo:
  - installs clean-instance prerequisites when needed
  - ensures Ollama and qwen3.6:27b are available
  - starts Blender with the Blender MCP add-on on the attached display
  - starts an MCP HTTP/SSE proxy and mcporter route
  - configures native OpenClaw
  - starts the OpenClaw gateway and prints dashboard access

Options:
  --no-install   Skip prerequisite installation checks.
  --agent-smoke  Run a native OpenClaw prompt that modifies the Blender scene.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-install) RUN_INSTALL=0 ;;
    --agent-smoke) RUN_AGENT_SMOKE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

echo "[1/7] Checking host prerequisites"
if [ "$RUN_INSTALL" -eq 1 ]; then
  "$SCRIPT_DIR/install-host-prereqs.sh"
else
  echo "Skipping install step"
fi

echo "[2/7] Ensuring local Ollama model"
"$SCRIPT_DIR/ensure-model.sh"

echo "[3/7] Starting Blender MCP"
"$SCRIPT_DIR/start-host-blender-mcp.sh"

echo "[4/7] Starting MCP proxy and mcporter route"
"$SCRIPT_DIR/start-mcp-proxy.sh"
"$SCRIPT_DIR/configure-mcporter.sh"

echo "[5/7] Configuring native OpenClaw"
"$SCRIPT_DIR/setup-openclaw.sh"

echo "[6/7] Smoke checks"
"$SCRIPT_DIR/run-mcporter-smoke.sh"
if [ "$RUN_AGENT_SMOKE" = "1" ]; then
  "$SCRIPT_DIR/run-openclaw-smoke.sh"
fi

echo "[7/7] OpenClaw dashboard"
"$SCRIPT_DIR/start-openclaw-gateway.sh"
"$SCRIPT_DIR/show-dashboard.sh"

cat <<EOF

Try this prompt:
  Create a clean product-style render scene with a compact AI workstation board on a plinth, metallic heat spreader, memory modules, subtle labels, and studio lighting.

Stop the demo with:
  ./scripts/stop-demo.sh
EOF

