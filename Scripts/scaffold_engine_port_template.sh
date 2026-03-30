#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <EasyRPGBridgePort|MKXPZBridgePort> <destination-dir>" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_NAME="$1"
DEST_DIR="$2"
SOURCE_DIR="${ROOT_DIR}/BuildSupport/EngineForkTemplates/${TEMPLATE_NAME}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Unknown template: ${TEMPLATE_NAME}" >&2
  exit 1
fi

if [[ -e "${DEST_DIR}" ]]; then
  echo "Destination already exists: ${DEST_DIR}" >&2
  exit 1
fi

mkdir -p "$(dirname "${DEST_DIR}")"
cp -R "${SOURCE_DIR}" "${DEST_DIR}"

echo "Scaffolded ${TEMPLATE_NAME} into ${DEST_DIR}"
