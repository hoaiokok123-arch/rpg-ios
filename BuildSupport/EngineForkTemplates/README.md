# Engine Fork Templates

This directory contains starter templates for two separate engine-port
repositories:

- `EasyRPGBridgePort`
- `MKXPZBridgePort`

Each template already includes:

- a minimal dynamic framework target exposing the bridge class expected by the app
- a `ci/build_ios_xcframework.sh` script compatible with this app repo contract
- a sample GitHub Actions workflow that builds an `XCFramework`
- a shared launch-context header so the engine can receive save/cache/runtime paths
- porting notes that list the first upstream files you will need to modify

These templates are intentionally conservative:

- they let you stand up the CI pipeline first
- they include stub `EasyRPGCore` and `MKXPZCore` classes for end-to-end smoke tests
- they do not pretend that the native engine port is already complete
