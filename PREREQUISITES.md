# Clean Instance Prerequisites

This repo is intended to work on a fresh DGX Spark / Ubuntu host with a local
desktop session and display attached. The scripts track and install host
prerequisites where possible.

| Requirement | Why it is needed | Installed by |
|---|---|---|
| Ubuntu with `sudo` | First-time package and service setup | Manual host requirement |
| Attached display / desktop session | Blender opens as a visible GUI app | Manual host requirement |
| `git`, `curl`, `ca-certificates`, `lsof`, `python3`, `python3-requests`, `zstd` | Repo checkout, HTTP checks, service management, Blender MCP add-on, Ollama tar extraction | `scripts/install-host-prereqs.sh` |
| Blender | Host-side scene editor controlled by MCP | `scripts/install-host-prereqs.sh` |
| `uv` / `uvx` | Runs `mcp-proxy` and `blender-mcp` without a project venv | `scripts/install-host-prereqs.sh` |
| Node.js 22+ and npm | Native OpenClaw CLI and mcporter runtime | `scripts/install-host-prereqs.sh` via `nvm` if needed |
| OpenClaw CLI | Native agent, gateway, dashboard, model config, and skills | `scripts/install-host-prereqs.sh` via `npm install -g openclaw@latest` |
| `mcporter` CLI | Lets OpenClaw call the Blender MCP tools | `scripts/install-host-prereqs.sh` via npm |
| Ollama 0.22.1 | Local model runtime on DGX Spark / GB10 | `scripts/install-ollama.sh` |
| `qwen3.6:27b` Ollama model | Default local model for this OpenClaw Blender template | `scripts/ensure-model.sh` |
| Browser or SSH tunnel | To open the OpenClaw dashboard from another machine | Manual |

Not required for this OpenClaw-only version:

- NemoClaw
- OpenShell
- Docker
- NVIDIA Container Toolkit
- vLLM
- Hugging Face token
- Virtual display setup

