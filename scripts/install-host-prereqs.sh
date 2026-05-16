#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"
# shellcheck source=openclaw-env.sh
. "$SCRIPT_DIR/openclaw-env.sh"

bash "$SCRIPT_DIR/ensure-sudo.sh"

echo "[prereqs] Installing Ubuntu packages"
sudo apt-get update
sudo apt-get install -y ca-certificates curl git lsof python3 python3-requests sudo zstd blender

openclaw_source_nvm
if [ "$(openclaw_node_major)" -lt 22 ]; then
  echo "[prereqs] Installing nvm + Node.js 22"
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    NVM_VERSION="${NVM_VERSION:-v0.40.3}"
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" -o /tmp/install-nvm.sh
    bash /tmp/install-nvm.sh
  fi
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
  nvm install 22
  nvm alias default 22
  nvm use 22 >/dev/null
fi

openclaw_require_node22

if ! command -v openclaw >/dev/null 2>&1; then
  echo "[prereqs] Installing OpenClaw CLI"
  npm install -g openclaw@latest
else
  echo "[prereqs] OpenClaw already installed: $(openclaw --version)"
fi

if ! command -v mcporter >/dev/null 2>&1; then
  echo "[prereqs] Installing mcporter CLI"
  npm install -g mcporter@latest
else
  echo "[prereqs] mcporter already installed: $(mcporter --version 2>/dev/null || echo present)"
fi

export PATH="$HOME/.local/bin:$PATH"
if ! command -v uvx >/dev/null 2>&1; then
  echo "[prereqs] Installing uv/uvx"
  curl -LsSf https://astral.sh/uv/install.sh -o /tmp/install-uv.sh
  sh /tmp/install-uv.sh
fi

ADDON="$ROOT/assets/blender_mcp_addon.py"
if [ ! -f "$ADDON" ]; then
  echo "[prereqs] Downloading Blender MCP addon"
  mkdir -p "$ROOT/assets"
  curl -fsSL https://raw.githubusercontent.com/ahujasid/blender-mcp/main/addon.py -o "$ADDON"
else
  echo "[prereqs] Blender MCP addon already present"
fi

if [ "${OPENCLAW_SKIP_OLLAMA_INSTALL:-0}" != "1" ]; then
  bash "$SCRIPT_DIR/install-ollama.sh"
else
  echo "[prereqs] Skipping Ollama install because OPENCLAW_SKIP_OLLAMA_INSTALL=1"
fi

echo "[prereqs] Complete"
echo "Repo: $ROOT"
