# EasyRPGBridgePort

Starter repository template for an iOS port of EasyRPG that exports the bridge
class expected by `RPGPlayerClone`.

What this template gives you now:

- `EasyRPGBridge.xcframework` can be produced on GitHub Actions
- the framework exports `EasyRPGBridge`
- the bridge already ships with a stub `EasyRPGCore` so the app can smoke-test launch context wiring

What still remains your responsibility:

- adapt upstream EasyRPG sources for iOS
- replace the stub files `Bridge/EasyRPGCore.h` and `Bridge/EasyRPGCore.m`
- route input and shutdown calls into the native engine
- package any engine assets required at runtime

Expected runtime contract inside this framework:

- class name: `EasyRPGCore`
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
