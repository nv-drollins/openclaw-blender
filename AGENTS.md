# Agent Notes

This is an OpenClaw-only Blender demo. It intentionally does not install or use
NemoClaw, OpenShell, Docker, vLLM, or a sandboxed `/sandbox/bin/mcporter`.

The local model path defaults to:

```text
ollama/qwen3.6:27b
```

Blender control flows through:

```text
OpenClaw agent -> mcporter -> mcp-proxy on 127.0.0.1:9877 -> blender-mcp on 127.0.0.1:9876 -> Blender
```

Assume the user is at the Spark or Ubuntu host with a display attached. Do not
try to create a virtual monitor for this project. If Blender cannot connect,
check `logs/blender.log`, `logs/mcp-proxy.log`, and `config/mcporter.json`.

