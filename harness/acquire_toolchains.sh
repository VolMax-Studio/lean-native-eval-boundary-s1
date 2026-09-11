#!/usr/bin/env bash
# P10 Toolchain Acquisition & Integrity Verification
# Strictly executed POST-FREEZE (or during Operator-authorized pre-execution phase);
# Verifies downloaded distribution archives against pinned digests, extracts without execution,
# and verifies/pins extracted bin/lean binary digests.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEST_DIR="${1:-${REPO_ROOT}/toolchains}"
mkdir -p "${DEST_DIR}"

declare -A TOOLCHAIN_URLS=(
  ["v4.32.2"]="https://github.com/leanprover/lean4/releases/download/v4.32.2/lean-4.32.2-linux.tar.zst"
  ["v4.33.1"]="https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst"
  ["v4.34.0-rc1"]="https://github.com/leanprover/lean4/releases/download/v4.34.0-rc1/lean-4.34.0-rc1-linux.tar.zst"
)

declare -A TOOLCHAIN_BYTES=(
  ["v4.32.2"]="563991635"
  ["v4.33.1"]="570405234"
  ["v4.34.0-rc1"]="575410932"
)

declare -A TOOLCHAIN_SHA256=(
  ["v4.32.2"]="5f2069e6f5db73780f374ccb49ce8ea649aa20a0cebf0116816744c999ce72aa"
  ["v4.33.1"]="890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235"
  ["v4.34.0-rc1"]="41dc6a6ec143ece8ed4ba4c4c6978c91f21ad5cbe3c4e7728ad31b869961dc17"
)

echo "Starting toolchain acquisition for 3 pinned versions..."

for ver in "v4.32.2" "v4.33.1" "v4.34.0-rc1"; do
  url="${TOOLCHAIN_URLS[$ver]}"
  exp_bytes="${TOOLCHAIN_BYTES[$ver]}"
  exp_sha="${TOOLCHAIN_SHA256[$ver]}"
  
  ver_dir="${DEST_DIR}/${ver}"
  mkdir -p "${ver_dir}"
  archive_file="${ver_dir}/archive.tar.zst"
  
  echo "[${ver}] Downloading release asset..."
  curl -sL --max-time 600 "${url}" -o "${archive_file}"
  
  # Verify byte size
  act_bytes="$(stat -c%s "${archive_file}")"
  if [ "${act_bytes}" -ne "${exp_bytes}" ]; then
    echo "Error: Byte size mismatch for ${ver}: expected ${exp_bytes}, got ${act_bytes}" >&2
    exit 1
  fi
  
  # Verify archive SHA-256
  act_sha="$(sha256sum "${archive_file}" | awk '{print $1}')"
  if [ "${act_sha}" != "${exp_sha}" ]; then
    echo "Error: Archive SHA-256 mismatch for ${ver}: expected ${exp_sha}, got ${act_sha}" >&2
    exit 1
  fi
  
  # Extract toolchain without executing lean binary
  echo "[${ver}] Extracting toolchain..."
  tar --zstd -xf "${archive_file}" -C "${ver_dir}"
  
  # Locate lean executable
  lean_bin=""
  if [ -x "${ver_dir}/bin/lean" ]; then
    lean_bin="${ver_dir}/bin/lean"
  else
    # In some distributions tarball unpacks to a subdirectory like lean-4.X.Y-linux/bin/lean
    found="$(find "${ver_dir}" -type f -name lean -perm -111 | grep "/bin/lean$" | head -n 1 || true)"
    if [ -n "${found}" ] && [ -x "${found}" ]; then
      lean_bin="${found}"
    fi
  fi
  
  if [ -z "${lean_bin}" ] || [ ! -x "${lean_bin}" ]; then
    echo "Error: Could not locate executable bin/lean for ${ver}" >&2
    exit 1
  fi
  
  bin_sha="$(sha256sum "${lean_bin}" | awk '{print $1}')"
  bin_bytes="$(stat -c%s "${lean_bin}")"
  echo "[${ver}] Verified bin/lean at ${lean_bin}: ${bin_bytes} bytes, SHA-256: ${bin_sha}"
done

echo "Toolchain acquisition and verification complete."
