---
name: blender
description: "Control Blender directly via MCP tools. Use when the user asks to create, modify, inspect, or render Blender scenes, objects, materials, lighting, cameras, or animations."
---

# Blender MCP

A live Blender instance is connected through the `blender` MCP server. Use
`mcporter` from the repository root so it loads `./config/mcporter.json`.

You have permission to run `mcporter`. Do not use `/sandbox/bin/mcporter` and
do not ask for NemoClaw/OpenShell privileges.

When the user asks you to create or modify a Blender scene:

1. Use `blender.execute_blender_code` for scene edits.
2. Pass `user_prompt` as the original user request.
3. Verify the result with `blender.get_scene_info`,
   `blender.get_object_info`, or `blender.get_viewport_screenshot`.
4. Do not claim a scene change succeeded until a verification call confirms it.

## Available Tools

- `blender.execute_blender_code` - run Python code in Blender.
- `blender.get_scene_info` - get information about the current scene.
- `blender.get_object_info object_name=<name>` - get information about a specific object.
- `blender.get_viewport_screenshot` - capture a screenshot of the 3D viewport.
- `blender.get_polyhaven_status` - check if PolyHaven is enabled.
- `blender.search_polyhaven_assets asset_type=<hdris|textures|models|all>` - search PolyHaven assets.
- `blender.download_polyhaven_asset asset_id=<id> asset_type=<type> resolution=<1k|2k|4k>` - download and import a PolyHaven asset.
- `blender.set_texture object_name=<name> texture_id=<id>` - apply a PolyHaven texture.
- `blender.get_sketchfab_status` - check if Sketchfab is enabled.
- `blender.search_sketchfab_models query=<text>` - search Sketchfab models.
- `blender.download_sketchfab_model uid=<uid> target_size=<float>` - download and import a Sketchfab model.

## Usage Pattern

```bash
mcporter --config ./config/mcporter.json call blender.get_scene_info \
  user_prompt="what is in the scene"

mcporter --config ./config/mcporter.json call blender.execute_blender_code \
  code="import bpy; bpy.ops.mesh.primitive_torus_add(major_radius=1, minor_radius=0.4); bpy.context.active_object.name='OpenClawDonut'" \
  user_prompt="create a donut"
```

Prefer explicit object names so you can verify them afterward.
Break complex scene generation into smaller Python chunks.

## Red Cube Example

```bash
mcporter --config ./config/mcporter.json call blender.execute_blender_code \
  code="import bpy; bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 0)); obj=bpy.context.object; obj.name='OpenClawRedCube'; mat=bpy.data.materials.new('OpenClawRedMaterial'); mat.diffuse_color=(1, 0, 0, 1); obj.data.materials.append(mat)" \
  user_prompt="create a red cube in the center of the Blender scene"

mcporter --config ./config/mcporter.json call blender.get_object_info \
  object_name=OpenClawRedCube \
  user_prompt="verify the red cube"
```

