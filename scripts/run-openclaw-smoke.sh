#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"
# shellcheck source=openclaw-env.sh
. "$SCRIPT_DIR/openclaw-env.sh"

PROFILE="${OPENCLAW_PROFILE:-openclaw-blender}"
MODEL_REF="${OPENCLAW_MODEL_REF:-ollama/${OPENCLAW_OLLAMA_MODEL:-qwen3.6:27b}}"
SESSION="${OPENCLAW_SMOKE_SESSION:-blender-smoke}"
LOG_FILE="$ROOT/logs/openclaw-smoke.json"
VERIFY_FILE="$ROOT/logs/openclaw-smoke-verify.json"
CONFIG="$ROOT/config/mcporter.json"

mkdir -p "$ROOT/logs"
openclaw_require_cli

if ! command -v mcporter >/dev/null 2>&1; then
  echo "mcporter CLI is required to verify the Blender scene." >&2
  exit 1
fi

mcporter --config "$CONFIG" call blender.execute_blender_code \
  code="import bpy; [bpy.data.objects.remove(obj, do_unlink=True) for obj in list(bpy.data.objects) if obj.name == 'OpenClawSmokeCube']" \
  user_prompt="clear any previous OpenClawSmokeCube smoke object" >/dev/null

set +e
openclaw --profile "$PROFILE" agent \
  --local \
  --session-id "$SESSION" \
  --model "$MODEL_REF" \
  --timeout "${OPENCLAW_AGENT_TIMEOUT:-600}" \
  --message "Use the Blender MCP tool to create a red cube named OpenClawSmokeCube in the center of the scene, then verify it exists." \
  --json > "$LOG_FILE" 2>&1
agent_status=$?
set -e

cat "$LOG_FILE"

mcporter --config "$CONFIG" call blender.get_object_info \
  object_name=OpenClawSmokeCube \
  user_prompt="verify the OpenClawSmokeCube smoke object" > "$VERIFY_FILE"
cat "$VERIFY_FILE"

if grep -q "OpenClawSmokeCube" "$VERIFY_FILE"; then
  echo "OpenClaw Blender smoke verified: OpenClawSmokeCube exists in the Blender scene."
  exit 0
fi

if [ "$agent_status" -ne 0 ]; then
  echo "OpenClaw agent exited with status $agent_status and the Blender object was not verified." >&2
  exit "$agent_status"
fi

echo "OpenClaw Blender smoke response completed, but the expected object was not verified." >&2
exit 1
