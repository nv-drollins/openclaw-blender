#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"
# shellcheck source=openclaw-env.sh
. "$SCRIPT_DIR/openclaw-env.sh"

CONFIG="$ROOT/config/mcporter.json"

openclaw_require_node22

if ! command -v mcporter >/dev/null 2>&1; then
  echo "mcporter CLI is required. Run ./scripts/install-host-prereqs.sh first." >&2
  exit 1
fi

echo "Listing MCP servers:"
mcporter --config "$CONFIG" list

echo
echo "Blender scene info:"
mcporter --config "$CONFIG" call blender.get_scene_info \
  user_prompt="check that the Blender MCP server is reachable"

