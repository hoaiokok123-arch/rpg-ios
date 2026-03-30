# EasyRPG iOS Port TODO

Suggested order of work:

1. Fork `EasyRPG/Player`.
2. Add this template on top of that fork.
3. Keep the bridge target building first, even if it only shows a placeholder.
4. Add a real `EasyRPGCore` implementation.
5. Only after that, teach the bridge to boot the engine loop.

Upstream files that are likely first-touch points:

- `CMakeLists.txt`
  You need a new iOS-oriented library path, not just the existing executable flow.

- `src/platform/sdl/main.cpp`
  This is where the current SDL app entry path lives. On iOS you usually need a
  view-controller-hosted lifecycle instead of a desktop `main`.

- `src/platform/android/*`
  This is the closest upstream precedent for "engine compiled as a library and
  hosted by a platform shell".

- `src/platform/sdl/sdl2_ui.*`
  Useful when mapping the engine loop to a UIKit-hosted surface.

- `src/player.cpp`
  Central control flow for startup/shutdown.

- `resources/shared/*`
  Runtime assets that may need bundling into the framework or app.

Concrete milestone definitions:

- Milestone 1:
  `EasyRPGBridge.xcframework` builds and app loads placeholder UI.

- Milestone 2:
  `EasyRPGCore.createViewControllerWithGamePath:` renders a real frame.

- Milestone 3:
  `sendInputWithButton:pressed:` maps to gameplay input.

- Milestone 4:
  save/load, audio session, suspend/resume, and orientation are stable on device.
