# game3d
Component based framework built on top of Mojo3D for the Monkey2 programming language.
Still very early in development and missing tons of features, but I want to ensure the features below are working very well before adding anything else.

Main features:
- Add gameplay and new features by simply creating new components and attaching them to game objects.
- Embraces Mojo3D's design. The Component system works "on top" of Mojo3D's Scenes, Entities, Etc.
- Json based scene files, with "hot reloading" - no need to recompile to see changes!
- Name based textures, materials and game objects

Main stuff missing:
- Player system (WIP)
- A lot more work is needed on the 2D side of things (WIP)
- A more robust set of Core components
- Animation handling, with Json loading.
- Mojo3D Physics/Collisions
- Configuration load/save

