#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_FILES=("${ROOT_DIR}/project.yml")
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/rpgplayerclone-xcodegen.XXXXXX")"
TEMP_SPEC="${TEMP_DIR}/project.yml"

cleanup() {
  rm -rf "${TEMP_DIR}"
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

if [[ "${#SPEC_FILES[@]}" -eq 1 ]]; then
  xcodegen generate --spec "${ROOT_DIR}/project.yml"
  exit 0
fi

{
  echo "name: RPGPlayerClone"
  echo "include:"
  for spec in "${SPEC_FILES[@]}"; do
    printf "  - path: '%s'\n" "${spec}"
  done
} > "${TEMP_SPEC}"

xcodegen generate --spec "${TEMP_SPEC}"
