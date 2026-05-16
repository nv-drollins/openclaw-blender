#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"
# shellcheck source=openclaw-env.sh
. "$SCRIPT_DIR/openclaw-env.sh"

PORT="${BLENDER_MCP_PROXY_PORT:-9877}"
HOST="${BLENDER_MCP_PROXY_HOST:-127.0.0.1}"
CONFIG="$ROOT/config/mcporter.json"

openclaw_require_node22

if ! command -v mcporter >/dev/null 2>&1; then
  echo "mcporter CLI is required. Run ./scripts/install-host-prereqs.sh first." >&2
  exit 1
fi

mkdir -p "$ROOT/config" "$ROOT/logs"
cat > "$CONFIG" <<JSON
{
  "mcpServers": {
    "blender": {
      "type": "http",
      "baseUrl": "http://${HOST}:${PORT}/sse"
    }
  }
}
JSON

echo "mcporter Blender route written to $CONFIG"
echo "Blender MCP proxy: http://${HOST}:${PORT}/sse"

