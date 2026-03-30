#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${ROOT_DIR}/BuildSupport"
ENGINE_SRC_DIR="${WORK_DIR}/engines-src"

EASYRPG_REPO_URL="${EASYRPG_REPO_URL:-}"
EASYRPG_REF="${EASYRPG_REF:-main}"
MKXPZ_REPO_URL="${MKXPZ_REPO_URL:-}"
MKXPZ_REF="${MKXPZ_REF:-main}"

clone_or_update() {
  local repo_url="$1"
  local target_dir="$2"
  local ref="$3"

  if [[ -d "${target_dir}/.git" ]]; then
    git -C "${target_dir}" fetch --all --tags
    git -C "${target_dir}" checkout "${ref}"
    git -C "${target_dir}" pull --ff-only origin "${ref}"
    return
  fi

  git clone --depth 1 --branch "${ref}" "${repo_url}" "${target_dir}"
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Engine build script must be run on macOS with Xcode installed." >&2
  exit 1
fi

if [[ -z "${EASYRPG_REPO_URL}" || -z "${MKXPZ_REPO_URL}" ]]; then
  cat >&2 <<'EOF'
Missing engine port repositories.

Export these variables before running:
  EASYRPG_REPO_URL=https://github.com/<owner>/<repo>
  EASYRPG_REF=<branch-or-tag>
  MKXPZ_REPO_URL=https://github.com/<owner>/<repo>
  MKXPZ_REF=<branch-or-tag>

Each engine repo must implement:
  ci/build_ios_xcframework.sh

See BuildSupport/BridgeContracts/README.md for the contract.
EOF
  exit 1
fi

command -v git >/dev/null 2>&1 || { echo "Missing command: git" >&2; exit 1; }
command -v xcodegen >/dev/null 2>&1 || { echo "Missing command: xcodegen" >&2; exit 1; }

mkdir -p "${ENGINE_SRC_DIR}"
mkdir -p "${ROOT_DIR}/Vendor"

chmod +x "${ROOT_DIR}/Scripts/build_engine_from_repo_contract.sh"
chmod +x "${ROOT_DIR}/Scripts/generate_xcode_project.sh"

clone_or_update "${EASYRPG_REPO_URL}" "${ENGINE_SRC_DIR}/EasyRPG-Player" "${EASYRPG_REF}"
clone_or_update "${MKXPZ_REPO_URL}" "${ENGINE_SRC_DIR}/mkxp-z" "${MKXPZ_REF}"

rm -rf "${ROOT_DIR}/Vendor/EasyRPGBridge.xcframework" "${ROOT_DIR}/Vendor/MKXPZBridge.xcframework"

"${ROOT_DIR}/Scripts/build_engine_from_repo_contract.sh" \
  "EasyRPG" \
  "EasyRPGBridge" \
  "${ENGINE_SRC_DIR}/EasyRPG-Player" \
  "${ROOT_DIR}/Vendor"

"${ROOT_DIR}/Scripts/build_engine_from_repo_contract.sh" \
  "mkxp-z" \
  "MKXPZBridge" \
  "${ENGINE_SRC_DIR}/mkxp-z" \
  "${ROOT_DIR}/Vendor"

"${ROOT_DIR}/Scripts/generate_xcode_project.sh"

cat <<'EOF'
Native engine artifacts are ready in Vendor/.
Next steps:
  1. pod install
  2. open RPGPlayerClone.xcworkspace
  3. build the app or run the GitHub Actions IPA workflow
EOF
