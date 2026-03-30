# MKXPZBridgePort

Starter repository template for an iOS port of mkxp-z that exports the bridge
class expected by `RPGPlayerClone`.

What this template gives you now:

- `MKXPZBridge.xcframework` can be produced on GitHub Actions
- the framework exports `MKXPZBridge`
- the bridge already ships with a stub `MKXPZCore` so the app can smoke-test launch context wiring

What still remains your responsibility:

- adapt the existing macOS-centric Xcode project to produce an iOS framework
- replace AppKit/macOS-only integrations with UIKit-safe code paths
- replace the stub files `Bridge/MKXPZCore.h` and `Bridge/MKXPZCore.m`
- route input and shutdown calls into the native engine loop

Expected runtime contract inside this framework:

- class name: `MKXPZCore`
- class methods:
  - `+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context;`
  - `+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path;`
  - `+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed;`
  - `+ (void)shutdownEngine;`

Recommended launch context keys:

- `gameId`
- `gameName`
- `gameType`
- `gamePath`
- `engineIdentifier`
- `runtimePath`
- `savesPath`
- `cachePath`
