# PNG Chaser

## Brief

PNG Chaser is a 3D survival horror game heavily inspired by Garry's Mod's "nextbot chase" game mode. The game was built
with a custom engine in C++ developed from scratch over the course of a 12-week semester, utilizing OpenGL for
rendering.

- **Project Type**: Solo
- **Skills**: C++, Game Engine development, OpenGL, ECS Architecture, Data-Oriented Design, Collision Detection (
  GJK/EPA), Pathfinding, Spatial Acceleration Structures
  
<video src="pngchaser_demo.mp4"> </video>

#### [Repo Link](https://github.com/mwinter02/3D-Game-Engine-Data-oriented/)

## Overview

PNG Chaser is a first-person survival horror game where you're trapped in a procedurally generated backrooms
environment. The goal is to avoid the PNG chaser for as long as possible. The chaser uses spatial audio
with left/right channel positioning and distance-based volume, so you can hear it getting closer.

The project was inspired by an Instagram trend at the time, combined with nostalgia for Garry's Mod's nextbot chase game
mode. The game was built as part of Brown University's CSCI 1950u - "3D Game Engine Development" course, entirely from
scratch using C++ and OpenGL.

### Engine Architecture

The engine was built with a focus on performance and scalability. I implemented an Entity Component System (ECS) using
data-oriented design principles, storing components as structures of arrays instead of arrays of structures. This
approach allows for better parallelization, more efficient memory usage, and faster processing. Collision detection uses
the GJK/EPA algorithms for accurate physics responses. Navigation is handled through navigation meshes paired with A*
pathfinding and string pulling for intelligent AI movement. Spatial acceleration structures, including BVH (Bounding
Volume Hierarchy) for static geometry and hierarchical grids for dynamic objects, allow for hundreds of dynamic
colliders
with no framerate drops.

<!-- Image: Engine Architecture Diagram -->

### Development Timeline

The project was structured around six milestone assignments over the 12-week semester:

1. **Weeks 1-2, Engine Architecture**: OpenGL renderer, input handling, camera initialization, basic 3D scene rendering
2. **Weeks 3-4, Gameworld, ECS, Systems**: Entity management and data-oriented systems, basic collisions, movement
3. **Weeks 5-6, Platformer (Collisions)**: Advanced collision detection with GJK/EPA and physics responses
4. **Weeks 7-8, Optimizations**: Spatial acceleration structures (BVH, hierarchical grids)
5. **Weeks 9-10, Pathfinding and AI**: Navigation meshes, A* pathfinding, funnel algorithm, and AI behavior trees
6. **Weeks 11-12, Final Project**: Procedural maze generation, spatial audio, and gameplay polish

## Development Log

### Project 0: Engine Architecture

The first step was setting up the core rendering and game loop systems using OpenGL and GLFW. I implemented vertex and
fragment shaders with texture mapping and used the Phong lighting model for realistic surface illumination. Input
handling is managed through GLFW for keyboard and mouse events. The game loop uses a fixed timestep for physics
calculations to keep everything deterministic, while rendering uses a variable timestep to maximize frame rate.

<!-- Image: Early renderer test -->

This project established the basic framework for all the future engine features. The early stages were pretty
straightforward, and the real challenges came later when I had to integrate more complex systems like collision
detection and
spatial acceleration.

### Project 1: Gameworld, ECS, Systems

This project introduced the Entity Component System (ECS) architecture with a focus on data-oriented design.
Entities are simple IDs, with each system keeping a mapping from entity ID to array index for O(1) lookups using
`std::unordered_map`. Components are pure data structures stored using the "structure of arrays" approach instead of the
traditional "array of structures."

Instead of storing components as traditional structs in a vector:

```cpp
// Traditional approach (Array of Structures)
struct PhysicsComponent {
    vec3 position;
    vec3 velocity;
    float mass;
};
std::vector<PhysicsComponent> components;
```

I used separate arrays for each component field (Structure of Arrays):

```cpp
// Data-Oriented approach (Structure of Arrays)
struct PhysicsSystem {
    std::unordered_map<EntityID, size_t> entityToIndex;
    std::vector<vec3> positions;
    std::vector<vec3> velocities;
    std::vector<float> masses;
};
```

Departing from the object-oriented design I was most familiar with, I opted to make this engine data-oriented, which
required a great deal of out-of-the-box thinking and is still relatively uncommon in practice. The key design
difference is using structures of arrays instead of arrays of structures, and opting for contiguous memory storage
wherever possible. In the context of a game engine, this creates real engineering challenges: fast lookups for specific
objects during collision checks, and cleanly representing the wide variety of components a game object might have.

I solved this with a typed vector template class that wraps a `std::vector<T>` for any given type, while also
extending a base `DataVector` class. This lets each system hold a collection of `DataVector` pointers for easy
iteration over all component fields, while still being strongly typed. Each system extends an abstract base system class
containing an `unordered_map<uint32, size_t>` for quick lookup of a game object's ID to its index in the data vectors.

The `GameWorld` exposes a template `getSystem<T>()` method so component systems can communicate with each other
directly. For example, the collision system can fetch current velocities from the physics system without needing it
passed in explicitly, keeping the architecture clean and decoupled.

This approach has some major performance benefits:

- **Cache efficiency**: Related data is stored next to each other in memory, which improves cache hit rates
- **Parallelization**: Systems can easily process components in parallel batches
- **Memory access patterns**: Sequential memory access is far more efficient than pointer-chasing through scattered
  objects

<!-- Image: ECS architecture diagram -->

I implemented several core component types including Transform (position, rotation, scale), Shape (mesh data for
rendering), Controller (input response data), and Physics (velocity, forces, mass). Systems are organized by their
update frequency: Rendering Systems run draw calls each frame with variable timestep, Tick Systems update game logic
each frame, Physics Systems run on fixed timestep for consistent simulation, and Input Systems handle player input.

Building a template-based DOD ECS system was tricky, especially trying to keep type safety while still getting the
performance benefits of data-oriented design. I had to think carefully about memory layout and how systems would
interface with each other to make sure everything stayed flexible and fast.

For more on data-oriented design principles, see [Data-Oriented Design](https://www.dataorienteddesign.com/dodbook/).

### Project 2: Platformer (Collisions)

This project focused on getting collision detection and physics-accurate collision responses working. To test
everything, I built a simple platformer game, though most of the work was on the engine side since it was pretty
complex.

I used the Gilbert-Johnson-Keerthi (GJK) algorithm for collision detection and the Expanding Polytope Algorithm (EPA)
for collision resolution. These are industry-standard algorithms that work with any convex shape, giving a lot of
flexibility. For a detailed overview, see these guides for [GJK](https://winter.dev/articles/gjk-algorithm)
and [EPA](https://winter.dev/articles/epa-algorithm).

The collision system supports a variety of shapes: cubes (both axis-aligned and oriented bounding boxes),
spheres, cones, cylinders, convex hulls, and triangle meshes.

<!-- Image: Collision shapes visualization -->

Collision responses use impulse-based physics with Newtonian mechanics. I calculate impulses and momentum based on the
masses and velocities of colliding objects, then apply forces in the direction of the Minimum Translation Vector (MTV)
that EPA provides. This preserves energy conservation and makes things behave realistically.

<!-- Image: Collision response diagram -->

Getting GJK/EPA working was one of the hardest parts of the whole project. The algorithms are complex and require a
solid understanding of computational geometry. The biggest pain point was floating-point precision errors causing
oversized MTVs for shallow collisions. I had to add careful numerical stability checks and epsilon thresholds to address
it. Still, when I finally got it working and saw objects colliding with accurate physics, it was very rewarding after
all that debugging.

### Project 3: Optimizations (Spatial Acceleration)

With collision detection working, the next challenge was handling hundreds of dynamic objects. Without spatial
acceleration, checking every object against every other object (O(n²)) quickly became a bottleneck. This project
introduced two different spatial acceleration structures for different use cases.

- Bounding Volume Hierarchy (BVH)

BVH works great for static geometry. The idea is to start with all primitives and recursively split them in half,
using the Surface Area Heuristic (SAH) to choose splits that minimize bounding volume surface area and maximize
traversal efficiency. At query time, if a node's bounding box is not hit, the entire subtree is skipped. Since the
structure only needs to be built once and then queried constantly, it is a natural fit for level geometry and static
props. For more detail, see [this BVH overview](https://jacco.ompf2.com/2022/04/13/how-to-build-a-bvh-part-1-basics/).

- Hierarchical Grid

For moving objects, rebuilding a BVH every frame would be too expensive, so I used a **hierarchical grid** — a sparse,
voxel-based spatial data structure that updates cheaply and handles broad-phase queries efficiently. The structure
consists of multiple grid levels, where each successive level has cells twice the size of the previous. Each object is
inserted into the grid level whose cell size best fits its bounding volume — small objects live in fine-grained grids,
large objects in coarser ones. Crucially, only occupied cells are stored (hence sparse), so memory usage stays
proportional to the number of objects rather than the size of the world.

At query time, only the grid levels relevant to the querying object's size are checked, and only the cells that
overlap its bounding volume are tested. This cuts the number of collision candidates down dramatically compared to a
flat grid or brute-force approach, and avoids the expensive rebuild cost of tree structures like BVH on dynamic
geometry.

> | 1D Hierarchical grid visualization |
> |:--:|
> | ![hgrid.png](/assets/assets/images/projects/pngchaser/hgrid.png) |

- Frustum culling

I also added frustum culling to optimize rendering. Each object's bounding box is tested against the view frustum, and
anything outside it is skipped entirely, cutting down on draw calls.

The performance improvement was massive. In a stress test with 100 static floor tiles and 2500 dynamic colliding
spheres exploding outward, the engine runs at a stable framerate with no drops. This proved that combining
BVH for static objects with hierarchical grids for dynamic objects really works.

> | 2500 tightly packed spheres with stable 100+ fps |
> |:--:|
> | ![explode.gif](/assets/assets/images/projects/pngchaser/explode.gif) |

Debugging hierarchical grids in 3D was surprisingly difficult. 1D and 2D examples made sense, but extending to three
dimensions with multiple resolution levels took a lot of spatial reasoning. Figuring out which objects belonged in which
grid cells and verifying the multi-level queries worked correctly took significant debugging time.

### Project 4: Pathfinding and AI

This project brought the AI to life, getting the PNG chaser to actually hunt the player through complex environments.

Navigation meshes are automatically loaded from OBJ files, with each triangle becoming a navigable surface. This makes
level design flexible, since you can export navigation geometry directly from your 3D modeling tools and the engine
processes it automatically.

<!-- Image: Navigation mesh visualization -->

#### A* Pathfinding

The pathfinding uses A* to find paths across the navigation mesh. The triangles form a graph where adjacent triangles
are connected as neighbors. A* uses a cost heuristic combining total traveled distance and Euclidean distance to the
goal, which means it only explores the most promising candidates rather than exhaustively searching like BFS or
Dijkstra. This finds the shortest path efficiently. For a thorough explanation, see
[this A* introduction](https://www.redblobgames.com/pathfinding/a-star/introduction.html).

#### Funnel Algorithm (String Pulling)

A* gives you a valid sequence of triangles, but naively navigating to the center of each produces a zigzagging path
that looks robotic. The funnel algorithm, also called string pulling, fixes this by finding the most direct route
through the triangle corridor.

Starting from the current origin, the algorithm uses cross products to maintain a funnel representing the visible
region ahead. If the next waypoint falls within the funnel, it can potentially be skipped. When a point falls outside
the funnel, the current triangle vertex becomes a new origin point appended to the final path, and iteration continues
from there. The result is the straightest possible route the AI can travel without leaving the navigation mesh, making
movement look natural and deliberate. For more detail, see
[this overview of the funnel algorithm](https://digestingduck.blogspot.com/2010/03/simple-stupid-funnel-algorithm.html).

<!-- Image: Before/after string pulling comparison -->

I used behavior trees to control AI decision-making and pick target destinations based on game state. These are easy
to extend with new behaviors when needed.

The pathfinding integrates with the ECS architecture cleanly. The Pathfinding Component stores the navigation mesh
reference and current path. The Decision Tree System updates where the AI wants to go. The Navigation System queries
the pathfinding component, runs A* and the funnel algorithm, then updates entity velocities to follow the path. This
separation means multiple AI entities can share the same navigation mesh while keeping their own paths and behaviors.

Getting pathfinding to work with the data-oriented ECS took careful thought. Paths vary in length and need frequent
updates, so finding a cache-friendly representation that still fit the structure-of-arrays approach required some
creative solutions.

### Project 5: Final Project

The final project brought everything together into an actual game, with procedural generation, spatial audio, and
polish.

The backrooms environment is procedurally generated using a modified Wilson's algorithm, which produces unbiased maze
layouts. I paired this with a modular asset system where walls, floors, and ceilings are designed as modular pieces.
By providing just a few core assets, the system automatically assembles a complete backrooms-themed maze. Each
playthrough generates a completely different layout that captures that liminal, unsettling atmosphere.

> | Chaser approaching player |
> |:--:|
> | ![chaser_lurking.png](/assets/assets/images/projects/pngchaser/chaser_lurking.png) |

The audio system uses RAudio for immersive 3D sound. Stereo panning shifts audio between left and right channels based
on the chaser's position relative to the player, and volume drops with distance, building tension as it closes in. You
are forced to navigate by sound as much as sight, turning the game from simple avoidance into a tense cat-and-mouse
experience where you are constantly listening for danger.

<!-- Image: Audio visualization -->

The final game delivers the core mechanics of a horror experience. The UI is minimal to preserve immersion. If the PNG
chaser touches you, it is game over. Lighting, textures, and audio were all tuned to create that moody, unsettling
atmosphere that fits the survival horror genre.

<!-- Image: Final gameplay screenshot -->

The main challenge was time management. With limited time to integrate everything, polish the experience, and fix bugs,
I had to prioritize carefully and focus on delivering a solid core that showcased what the engine could do while keeping
the game cohesive and playable.

## Conclusion

PNG Chaser was the result of a full semester of engine development, going from a basic OpenGL renderer to complex
systems like collision detection, spatial acceleration, and AI pathfinding. Building a 3D game engine from scratch
reinforced how much performance-critical programming depends on the right design decisions from the ground up.
Data-oriented design and spatial acceleration structures made a dramatic difference in practice. Implementing GJK/EPA
and the funnel algorithm required a solid grasp of computational geometry. Getting physics, rendering, AI, and audio to
all work together in one cohesive system took careful planning throughout the whole semester.

The best part was watching everything come together in the final weeks. Seeing the PNG chaser intelligently navigate
a procedurally generated maze while you frantically try to escape, guided by terrifying spatial audio cues, was
genuinely satisfying. What started as a simple OpenGL renderer became a full game engine capable of creating a
compelling experience.

This project validated data-oriented design and modern C++ techniques for game development, and reinforced how
important it is to pick the right algorithms and optimize early. Every challenge along the way deepened my understanding
of game engine architecture and real-time graphics programming.