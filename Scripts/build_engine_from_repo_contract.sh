#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <engine-name> <product-name> <engine-source-dir> <output-dir>" >&2
  exit 1
fi

ENGINE_NAME="$1"
PRODUCT_NAME="$2"
ENGINE_SOURCE_DIR="$3"
OUTPUT_DIR="$4"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENGINE_BUILD_SCRIPT="${ENGINE_SOURCE_DIR}/ci/build_ios_xcframework.sh"
EXPECTED_OUTPUT="${OUTPUT_DIR}/${PRODUCT_NAME}.xcframework"
CONTRACT_HEADER="${ROOT_DIR}/BuildSupport/BridgeContracts/${PRODUCT_NAME}.h"
CONTRACT_DIR="${ROOT_DIR}/BuildSupport/BridgeContracts"
LAUNCH_CONTEXT_HEADER="${CONTRACT_DIR}/NativeEngineLaunchContext.h"

if [[ ! -d "${ENGINE_SOURCE_DIR}" ]]; then
  echo "${ENGINE_NAME}: engine source directory not found: ${ENGINE_SOURCE_DIR}" >&2
  exit 1
fi

if [[ ! -f "${ENGINE_BUILD_SCRIPT}" ]]; then
  echo "${ENGINE_NAME}: missing required build script: ${ENGINE_BUILD_SCRIPT}" >&2
  echo "${ENGINE_NAME}: the engine fork must implement the contract described in BuildSupport/BridgeContracts/README.md" >&2
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"
chmod +x "${ENGINE_BUILD_SCRIPT}"

echo "==> Building ${ENGINE_NAME} with contract script ${ENGINE_BUILD_SCRIPT}"
(
  cd "${ENGINE_SOURCE_DIR}"
  OUTPUT_DIR="${OUTPUT_DIR}" \
  PRODUCT_NAME="${PRODUCT_NAME}" \
  APP_REPO_ROOT="${ROOT_DIR}" \
  BRIDGE_CONTRACT_DIR="${CONTRACT_DIR}" \
  BRIDGE_CONTRACT_HEADER="${CONTRACT_HEADER}" \
  BRIDGE_LAUNCH_CONTEXT_HEADER="${LAUNCH_CONTEXT_HEADER}" \
  ./ci/build_ios_xcframework.sh
)

if [[ ! -d "${EXPECTED_OUTPUT}" ]]; then
  echo "${ENGINE_NAME}: expected output not found: ${EXPECTED_OUTPUT}" >&2
  find "${OUTPUT_DIR}" -maxdepth 3 -print >&2 || true
  exit 1
fi

echo "==> ${ENGINE_NAME} output ready at ${EXPECTED_OUTPUT}"
