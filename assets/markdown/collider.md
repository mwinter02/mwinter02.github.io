# Interactive Collider Design for 3D Meshes

## Brief

Interactive Collider Design is a computational design tool for creating convex collision meshes (colliders) for both
static and skeletal 3D assets. Built over 4 weeks as part of Brown University's CSCI 2952Y - "Special Topics in
Computational Design and Fabrication" course.

- **Project Type**: Team (Marcus Winter, Gordan Milovac, Patrick Ortiz)
- **My Contributions**: Static mesh decomposition interface, skeletal mesh decomposition algorithm and interface,
  collider export system
- **Skills**: C++, Mesh Processing, Skinned Meshes, Computational Geometry, Assimp, OpenGL, ImGUI, UI Development
- **Dependencies**: Assimp, CoACD, GLFW, GLEW, GLM, Native File Dialogue Extended, Quickhull, ImGUI

<video src="collider_demo.mp4"> </video>

## Overview

After working on collision detection for my custom game engine (PNG Chaser), I realized that creating collision meshes
was surprisingly difficult and unintuitive. Algorithms like V-HACD and CoACD handle mesh decomposition, but on their own
they offer no visual feedback on results and can't export to usable formats. This makes it hard to tune parameters and
find the right balance between detail and performance. On top of that, tools in Unreal and Unity can generate colliders
for rigged meshes, but those assets aren't exportable or usable in other engines.

The goal of this project was to build a practical tool that fills that gap. It provides a comprehensive ImGUI interface
for generating collision meshes for both static and skeletal 3D assets, letting users visualize and adjust quality
parameters in real time to balance performance against accuracy. The tool is aimed at anyone who needs convex colliders
for physics, whether for simulations or game engines.

For static meshes, we integrated CoACD, a newer algorithm that improves on V-HACD by avoiding voxelization, and wrapped
it in a UI for real-time parameter tuning. For skeletal meshes, I developed a custom algorithm that decomposes the mesh
based on bone weights and hierarchy, producing convex hulls rigged directly to the original skeleton. All generated
colliders can be exported as `.obj` or `.fbx` files that work in any engine or DCC tool.

GitHub Repository: [https://github.com/mwinter02/CS2952Y_Final](https://github.com/mwinter02/CS2952Y_Final)

## Development

The project was split into several key components, with my work focused on the static mesh decomposition interface, the
skeletal mesh decomposition algorithm, and the export system.

### Asset Importing

For opening and importing 3D files, we used the Open Asset Import Library (Assimp), an open-source C++ library that
supports nearly every widely used 3D format, from legacy `.obj` to modern `.fbx`. Once a file is imported, we load the
associated textures and populate the OpenGL buffers for rendering.

### Static Mesh Decomposition

For static meshes, I built the UI wrapper around CoACD to make it genuinely usable. CoACD is a powerful decomposition
algorithm, but as a standalone library it provides no visual feedback whatsoever. I exposed the key parameters through
sliders and controls so users can tune things like decomposition threshold, maximum convex hull count, and outset
distance, seeing the results update in real time.

To help users understand what they're looking at, I added wireframe overlay modes so both the original mesh and the
generated colliders are visible simultaneously, making it easy to spot areas where the collider is too coarse or too
detailed.

The static decomposition interface offers two modes. Simple mode provides a set of presets covering various quality
levels, giving users a quick starting point. Advanced mode exposes the full set of CoACD parameters directly through GUI
sliders for users who want precise control.

Both modes also include an AABB option, which represents each decomposed region as an axis-aligned bounding box rather
than a convex hull. This trades some accuracy for maximum runtime efficiency, which is useful in performance-sensitive
contexts.

> | Static mesh decomposition UI |
> |:--:|
> | ![static_ui.png](/assets/assets/images/projects/collider/static_ui.png) |

### Skeletal Mesh Decomposition

This was the more novel part of the project. No readily available algorithm existed for decomposing skinned meshes into
convex parts that follow skeleton structure, so I designed one from scratch.

The algorithm analyzes bone weights and the skeleton hierarchy, and assigns each vertex to the bone with the greatest
weight influence. A convex hull is then generated per selected bone using all the vertices assigned to it. There are
three selection modes:

**Important Bones** uses a custom heuristic that scores each bone based on its number of children and the volume of the
vertices it influences. Bones that control a larger, more geometrically significant portion of the mesh are flagged as
important and given their own collider. This keeps the collider count manageable while ensuring meaningful coverage.

**All Bones** generates a collider for every bone in the skeleton, useful when complete coverage is needed.

**Custom Bones** presents a dropdown list of every bone in the file with individual checkboxes, letting users toggle
specific bones on and off. This is practical when you know exactly which parts need collision, such as just the limbs or
just the torso.

The generated colliders are then rigged to the same skeleton as the input mesh, meaning they deform correctly during
animation and can be exported as a complete skinned mesh asset. As with static meshes, a bounding box mode is available.
Because the bones rotate and translate during animation, these boxes do not remain axis-aligned at runtime, but they are
still represented as cuboids, which keeps them efficient relative to full convex hulls.

> | Skeletal mesh decomposition UI |
> |:--:|
> | ![skeletal_ui.png](/assets/assets/images/projects/collider/skeletal_ui.png) |

> | Rigged colliders with animation |
> |:--:|
> | ![backflip.gif](/assets/assets/images/projects/collider/backflip.gif) |

### Export System

Once colliders are generated, they need to be exported in formats that game engines can actually use. I implemented the
export system using Assimp's exporter, which handles both `.obj` files for static meshes and `.fbx` for skeletal meshes
with full rigging data. Notably, since `.fbx` is not an open format, using Assimp's exporter meant we could support it
without significant additional effort.

For skeletal meshes, I had to ensure the bone hierarchy, vertex weights, and bind poses all exported correctly so the
colliders remain properly attached to the skeleton in the destination application. The exports were tested in Blender to
verify that colliders maintained their rigging and deformed correctly. Both static and skeletal exports preserve the
coordinate system and scale of the original mesh, so they slot into any engine or DCC tool without manual adjustment.

> | Exported colliders |
> |:--:|
> | ![export.png](/assets/assets/images/projects/collider/export.png) |

### Camera and Viewport

I came into this project with the mindset of building a tool I'd genuinely want to use myself, and that shaped a few
specific decisions around the viewport experience.

One of those was implementing an orbit camera. It responds naturally to click-and-drag input and uses a
longitude/latitude coordinate system paired with a distance-from-center value, with the camera always looking at the
origin. Scrolling moves the camera closer or further, allowing precise view angles. This was completely outside the
requirements of the project brief, but having a camera that feels natural makes inspecting a model from different angles
fast and effortless, which matters a lot when you're iterating on decomposition parameters.

The ImGUI panel also includes object transform sliders and camera controls alongside the decomposition parameters,
keeping everything accessible from one place.

### Team Contributions

While I focused on the decomposition algorithms and export system, my teammates handled other critical parts of the
tool. Gordan and Patrick implemented the 3D viewer, performance metrics display, animation preview system, and conducted
a user study. The metrics panel was particularly valuable for quantifying the accuracy-performance tradeoffs between
different decomposition strategies.

## Conclusion

This project addressed a real problem I had run into during game development. Creating good collision meshes is harder
than it should be, and existing tools either lack visual feedback, produce non-exportable results, or don't support
skeletal meshes at all. By wrapping existing algorithms in an interactive interface and developing a new approach for
skeletal meshes, the tool is practical for real production use.

The skeletal decomposition algorithm was the most technically interesting piece. Understanding how to partition a mesh
by bone influence, generate convex hulls per bone, and rig those hulls back to the original skeleton required getting
comfortable with both the geometry and the animation side of skinned meshes. Seeing the colliders deform correctly with
animations and export cleanly as `.fbx` files was a satisfying result.

Building on my earlier work with collision detection in PNG Chaser, this project gave me a much deeper understanding of
the content creation side: not just how collision works inside an engine, but how the actual collision geometry gets
made in the first place.