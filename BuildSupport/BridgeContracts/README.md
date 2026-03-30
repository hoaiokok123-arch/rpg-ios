# Native Engine Bridge Contract

This directory defines the Objective-C classes the app expects each native
engine framework to export.

Required framework products:

- `EasyRPGBridge.xcframework`
- `MKXPZBridge.xcframework`

Required Objective-C classes:

- `EasyRPGBridge`
- `MKXPZBridge`

Required class methods for both bridge classes:

- `+ (nullable UIViewController *)createViewControllerWithLaunchContext:(NSDictionary<NSString *, id> *)context;`
- `+ (nullable UIViewController *)createViewControllerWithGamePath:(NSString *)path;`
- `+ (void)sendInputWithButton:(NSString *)button pressed:(BOOL)pressed;`
- `+ (void)shutdownEngine;`

Launch context keys are documented in:

- `BuildSupport/BridgeContracts/NativeEngineLaunchContext.h`

The app will prefer `createViewControllerWithLaunchContext:` and fall back to
`createViewControllerWithGamePath:` for older bridges.

Build contract for engine fork repositories:

- Provide `ci/build_ios_xcframework.sh`.
- Respect the `OUTPUT_DIR` environment variable.
- `APP_REPO_ROOT`, `BRIDGE_CONTRACT_DIR`, `BRIDGE_CONTRACT_HEADER`, and
  `BRIDGE_LAUNCH_CONTEXT_HEADER` are exported for convenience.
- Emit `<PRODUCT_NAME>.xcframework` into `OUTPUT_DIR`.
- Build a dynamic framework so the app can discover bridge classes at runtime.

Starter templates for those repositories live in:

- `BuildSupport/EngineForkTemplates/EasyRPGBridgePort`
- `BuildSupport/EngineForkTemplates/MKXPZBridgePort`
