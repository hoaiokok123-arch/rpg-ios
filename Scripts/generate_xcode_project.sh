#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_FILES=("${ROOT_DIR}/project.yml")
TEMP_SPEC="$(mktemp "${TMPDIR:-/tmp}/rpgplayerclone-xcodegen.XXXXXX.yml")"

cleanup() {
  rm -f "${TEMP_SPEC}"
}

trap cleanup EXIT

if [[ -d "${ROOT_DIR}/Vendor/EasyRPGBridge.xcframework" ]]; then
  SPEC_FILES+=("${ROOT_DIR}/BuildSupport/project.easyrpg.yml")
fi

if [[ -d "${ROOT_DIR}/Vendor/MKXPZBridge.xcframework" ]]; then
  SPEC_FILES+=("${ROOT_DIR}/BuildSupport/project.mkxpz.yml")
fi

echo "Generating Xcode project with specs:"
for spec in "${SPEC_FILES[@]}"; do
  echo "  - ${spec}"
done

{
  echo "include:"
  for spec in "${SPEC_FILES[@]}"; do
    printf "  - path: '%s'\n" "${spec}"
    echo "    relativePaths: false"
  done
} > "${TEMP_SPEC}"

xcodegen generate --spec "${TEMP_SPEC}"
