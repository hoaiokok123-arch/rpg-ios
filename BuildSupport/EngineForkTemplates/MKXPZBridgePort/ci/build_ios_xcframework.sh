#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-${ROOT_DIR}/build-output}"
PRODUCT_NAME="${PRODUCT_NAME:-MKXPZBridge}"
SCHEME="${SCHEME:-MKXPZBridge}"
DERIVED_DATA_DIR="${ROOT_DIR}/build/DerivedData"
DEVICE_ARCHIVE="${ROOT_DIR}/build/${PRODUCT_NAME}-iphoneos.xcarchive"
SIM_ARCHIVE="${ROOT_DIR}/build/${PRODUCT_NAME}-iphonesimulator.xcarchive"
XCFRAMEWORK_PATH="${OUTPUT_DIR}/${PRODUCT_NAME}.xcframework"

command -v xcodegen >/dev/null 2>&1 || { echo "Missing command: xcodegen" >&2; exit 1; }
command -v xcodebuild >/dev/null 2>&1 || { echo "Missing command: xcodebuild" >&2; exit 1; }

rm -rf "${ROOT_DIR}/build" "${XCFRAMEWORK_PATH}"
mkdir -p "${OUTPUT_DIR}"

echo "Generating Xcode project for ${PRODUCT_NAME}"
xcodegen generate

echo "Archiving ${PRODUCT_NAME} for iphoneos"
xcodebuild archive \
  -project "${ROOT_DIR}/${PRODUCT_NAME}.xcodeproj" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "${DEVICE_ARCHIVE}" \
  -derivedDataPath "${DERIVED_DATA_DIR}" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Archiving ${PRODUCT_NAME} for iphonesimulator"
xcodebuild archive \
  -project "${ROOT_DIR}/${PRODUCT_NAME}.xcodeproj" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${SIM_ARCHIVE}" \
  -derivedDataPath "${DERIVED_DATA_DIR}" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Creating XCFramework"
xcodebuild -create-xcframework \
  -framework "${DEVICE_ARCHIVE}/Products/Library/Frameworks/${PRODUCT_NAME}.framework" \
  -framework "${SIM_ARCHIVE}/Products/Library/Frameworks/${PRODUCT_NAME}.framework" \
  -output "${XCFRAMEWORK_PATH}"

echo "Built ${XCFRAMEWORK_PATH}"
