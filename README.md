# OpenClaw Blender Demo

OpenClaw-only version of the Blender MCP demo. It starts a visible Blender GUI
on the host, connects Blender MCP through `mcporter`, and exposes the demo
through the native OpenClaw dashboard.

The default local model is:

```text
ollama/qwen3.6:27b
```

See [PREREQUISITES.md](PREREQUISITES.md) for the clean-instance requirements
ledger.

## Quick Start

Run these commands on the Spark or Ubuntu host with a display attached:

```bash
git clone https://github.com/nv-drollins/openclaw-blender.git
cd openclaw-blender
chmod +x install.sh scripts/*.sh
./install.sh
```

This demo was created and tested with OpenClaw CLI `2026.5.12`. The installer
uses that version by default. To intentionally test a different OpenClaw
release, pass it through the install command:

```bash
OPENCLAW_CLI_VERSION=2026.5.12 ./install.sh
```

Use `OPENCLAW_CLI_VERSION=latest ./install.sh` only when validating the latest
OpenClaw release.

`install.sh` installs missing host prerequisites, ensures Ollama and
`qwen3.6:27b` are available, starts Blender with the Blender MCP add-on, starts
the MCP proxy, creates a native OpenClaw profile, starts the OpenClaw gateway,
and prints the dashboard URL and token.

Try this prompt in the dashboard:

```text
Create a clean product-style render scene with a compact AI workstation board on a plinth, metallic heat spreader, memory modules, subtle labels, and studio lighting.
```

Other good prompts:

```text
Create a small desktop AI development board scene with a chip package, cooling fins, ports, and labeled components.
```

```text
Add three camera-ready material variants to the scene: brushed metal, matte black, and translucent green circuit board.
```

```text
Move the camera and lights so the scene is ready for a 16:9 product screenshot, then describe what changed.
```

## What You Get

- A visible host-side Blender session
- Blender MCP on `127.0.0.1:9876`
- `mcp-proxy` HTTP/SSE bridge on `127.0.0.1:9877`
- A native OpenClaw workspace restricted to the `blender` and `mcporter` skills
- A local Ollama/Qwen model path
- Start, stop, dashboard, prerequisite, and smoke-test scripts

## Day-2 Commands

Start or repair the full demo:

```bash
./scripts/start-demo.sh
```

Stop the OpenClaw gateway, MCP proxy, and Blender instance started by the demo:

```bash
./scripts/stop-demo.sh
```

Run direct Blender MCP checks:

```bash
./scripts/run-mcporter-smoke.sh
```

Run a native OpenClaw agent smoke test that modifies the Blender scene:

```bash
./scripts/run-openclaw-smoke.sh
```

Show the dashboard URL and token:

```bash
./scripts/show-dashboard.sh
```

## Configuration

| Variable | Default | Purpose |
|---|---:|---|
| `OPENCLAW_CLI_VERSION` | `2026.5.12` | OpenClaw CLI npm package version installed by the prereq script |
| `OPENCLAW_PROFILE` | `openclaw-blender` | Native OpenClaw profile name |
| `OPENCLAW_OLLAMA_MODEL` | `qwen3.6:27b` | Ollama model to pull and use |
| `OPENCLAW_MODEL_REF` | `ollama/${OPENCLAW_OLLAMA_MODEL}` | OpenClaw model id |
| `OPENCLAW_GATEWAY_PORT` | `18790` | Dashboard/gateway port |
| `OPENCLAW_GATEWAY_BIND` | `loopback` | Gateway bind mode; use `lan` only on trusted networks |
| `BLENDER_MCP_PORT` | `9876` | Blender MCP socket port |
| `BLENDER_MCP_PROXY_HOST` | `127.0.0.1` | MCP proxy bind host |
| `BLENDER_MCP_PROXY_PORT` | `9877` | MCP proxy HTTP/SSE port |
| `BLENDER_MCP_ADDON` | `assets/blender_mcp_addon.py` | Optional path to a different Blender MCP add-on |
| `DISPLAY` | `:0` | Display used to launch Blender |

## Notes

This project deliberately does not install or use NemoClaw, OpenShell, Docker,
or vLLM. Native OpenClaw runs on the host and calls Blender through `mcporter`.

The setup script sets `agents.defaults.skills` to `["blender","mcporter"]` so
the agent sees only the Blender workflow it needs.

The scripts assume a real desktop session is available. If Blender opens but
the MCP socket does not become ready, check the Blender sidebar for the
BlenderMCP tab and click its connect button, then rerun:

```bash
./scripts/start-demo.sh --no-install
```
