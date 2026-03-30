# mkxp-z iOS Port TODO

Suggested order of work:

1. Fork `mkxp-z/mkxp-z`.
2. Add this template on top of that fork.
3. Keep the bridge target building first, even if it only shows a placeholder.
4. Add a real `MKXPZCore` implementation.
5. Then move the SDL render loop into a UIKit-hosted controller.

Upstream files that are likely first-touch points:

- `macos/mkxp-z.xcodeproj`
  Upstream itself says Meson is no longer used for Darwin. The real iOS port will
  almost certainly branch from the Xcode project.

- `macos/config/*.xcconfig`
  These currently target `macosx`, not `iphoneos` / `iphonesimulator`.

- `macos/Dependencies/*.make`
  The dependency build system is hardcoded for macOS architectures and deployment.

- `src/main.cpp`
  Current engine bootstrap is desktop-SDL oriented.

- `macos/views/TouchBar.*`
  AppKit and Touch Bar code must not flow into iOS targets.

- `macos/views/SettingsMenuController.*`
  Another AppKit-only surface that needs to be excluded or replaced on iOS.

- `src/system/systemImplApple.mm` and `src/filesystem/filesystemImplApple.mm`
  Good places to split shared Apple code from macOS-only code.

Concrete milestone definitions:

- Milestone 1:
  `MKXPZBridge.xcframework` builds and app loads placeholder UI.

- Milestone 2:
  `MKXPZCore.createViewControllerWithGamePath:` renders a real frame.

- Milestone 3:
  `sendInputWithButton:pressed:` maps to gameplay input.

- Milestone 4:
  save/load, audio, suspend/resume, and orientation are stable on device.
