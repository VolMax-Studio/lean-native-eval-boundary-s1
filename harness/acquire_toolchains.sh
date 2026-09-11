#!/usr/bin/env bash
# P10 Toolchain Acquisition & Integrity Verification
# Strictly executed POST-FREEZE (or during Operator-authorized pre-execution phase);
# Verifies downloaded distribution archives against pinned digests, extracts without execution,
# and verifies/pins extracted bin/lean binary digests.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEST_DIR="${1:-${REPO_ROOT}/toolchains}"
EVIDENCE_ZIP="${2:-}"
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

# PoC verification: verify existing sources/PoC.lean or extract from private evidence bundle
PINNED_EVIDENCE_SHA256="90407481c8b511fa7c0ba9bef16b08b175f71a551fd3d757d956aebbc423e2a5"
PINNED_POC_SHA256="ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b"
POC_PATH="${REPO_ROOT}/sources/PoC.lean"

if [ -n "${EVIDENCE_ZIP}" ]; then
  if [ ! -f "${EVIDENCE_ZIP}" ]; then
    echo "Error: Specified evidence bundle does not exist: ${EVIDENCE_ZIP}" >&2
    exit 1
  fi
  echo "Verifying external evidence bundle..."
  actual_ev_sha="$(sha256sum "${EVIDENCE_ZIP}" | awk '{print $1}')"
  if [ "${actual_ev_sha}" != "${PINNED_EVIDENCE_SHA256}" ]; then
    echo "Error: Evidence bundle SHA-256 mismatch: expected ${PINNED_EVIDENCE_SHA256}, got ${actual_ev_sha}" >&2
    exit 1
  fi
  mkdir -p "${REPO_ROOT}/sources"
  unzip -p "${EVIDENCE_ZIP}" sources/PoC.lean > "${POC_PATH}"
  echo "Successfully extracted sources/PoC.lean from private evidence bundle."
fi

if [ ! -f "${POC_PATH}" ]; then
  echo "Error: Mandatory PoC artifact not found at ${POC_PATH}. Provide path to verified evidence zip as second argument." >&2
  exit 1
fi

actual_poc_sha="$(sha256sum "${POC_PATH}" | awk '{print $1}')"
if [ "${actual_poc_sha}" != "${PINNED_POC_SHA256}" ]; then
  echo "Error: PoC SHA-256 mismatch at ${POC_PATH}: expected ${PINNED_POC_SHA256}, got ${actual_poc_sha}" >&2
  exit 1
fi
echo "Verified sources/PoC.lean integrity (SHA-256: ${actual_poc_sha})."

echo "Starting toolchain acquisition for 3 pinned versions..."

PINS_JSON="${REPO_ROOT}/harness/toolchain_pins.json"

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
  tar --strip-components=1 --zstd -xf "${archive_file}" -C "${ver_dir}"
  
  # Locate lean executable
  lean_bin=""
  if [ -x "${ver_dir}/bin/lean" ]; then
    lean_bin="${ver_dir}/bin/lean"
  else
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
  echo "[${ver}] Measured bin/lean: ${bin_bytes} bytes, SHA-256: ${bin_sha}"

  # Locate and verify libleanshared.so (B-13)
  shared_so="${ver_dir}/lib/lean/libleanshared.so"
  if [ ! -f "${shared_so}" ]; then
    echo "Error: Could not locate libleanshared.so for ${ver} at ${shared_so}" >&2
    exit 1
  fi
  so_sha="$(sha256sum "${shared_so}" | awk '{print $1}')"
  so_bytes="$(stat -c%s "${shared_so}")"
  echo "[${ver}] Measured libleanshared.so: ${so_bytes} bytes, SHA-256: ${so_sha}"

  # Verify against immutable pins in toolchain_pins.json (F-24)
  python3 -c "
import json, sys
with open('${PINS_JSON}', 'r') as f:
    d = json.load(f)
tc = d.get('toolchains', {}).get('${ver}', {})

exp_bin_sha = tc.get('bin_lean_sha256')
exp_bin_bytes = tc.get('bin_lean_bytes')
exp_so_sha = tc.get('libleanshared_so_sha256')
exp_so_bytes = tc.get('libleanshared_so_bytes')

if '${bin_sha}' != exp_bin_sha:
    sys.exit(f'Error: bin_lean SHA mismatch for ${ver}: expected {exp_bin_sha}, got ${bin_sha}')
if int('${bin_bytes}') != exp_bin_bytes:
    sys.exit(f'Error: bin_lean bytes mismatch for ${ver}: expected {exp_bin_bytes}, got ${bin_bytes}')
if '${so_sha}' != exp_so_sha:
    sys.exit(f'Error: libleanshared.so SHA mismatch for ${ver}: expected {exp_so_sha}, got ${so_sha}')
if int('${so_bytes}') != exp_so_bytes:
    sys.exit(f'Error: libleanshared.so bytes mismatch for ${ver}: expected {exp_so_bytes}, got ${so_bytes}')
print(f'[${ver}] All toolchain binary and library pins verified successfully.')
"
done

echo "Toolchain acquisition and verification complete. All binaries and shared libraries match pinned registry."
