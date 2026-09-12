#!/usr/bin/env bash
# P10 Behavioral Execution Harness — Frozen Pre-Registration Script
# Strictly executed POST-FREEZE; no Lean execution permitted before ratified freeze.
set -euo pipefail

# 0. Canonical repository root resolution (independent of execution cwd)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

TOOLCHAIN_DIR="$(realpath "$1")"
POC_FILE="$(realpath "${2:-${REPO_ROOT}/sources/PoC.lean}")"
OUTPUT_DIR="$(realpath -m "${3:-${REPO_ROOT}/evidence/behavioral/run}")"

LEAN_BIN="${TOOLCHAIN_DIR}/bin/lean"
if [ ! -x "${LEAN_BIN}" ]; then
  echo "Error: Lean binary not executable at ${LEAN_BIN}" >&2
  exit 2
fi

if [ ! -f "${POC_FILE}" ]; then
  echo "Error: PoC file not found at ${POC_FILE}" >&2
  exit 2
fi

mkdir -p "${OUTPUT_DIR}"
cd "${OUTPUT_DIR}"

# 1. Preflight check: verify limits and resource wrappers using /bin/true (zero Lean execution)
set +e
prlimit --as=4294967296 timeout --kill-after=5s 60s /bin/true >/dev/null 2>&1
PREFLIGHT_LIMIT_EXIT=$?
set -e

write_preflight_blocker_metadata() {
  local reason="$1"
  local start_utc="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local kernel_ver="$(uname -r)"
  local libc_ver="$(python3 -c 'import platform; print(" ".join(platform.libc_ver()))' 2>/dev/null || echo 'unknown')"
  local toolchain_ver="$(basename "${TOOLCHAIN_DIR}")"
  local user_inf="$(id -u):$(id -g) ($(id -un))"
  local is_stub="${TEST_STUB_MODE:-0}"

  python3 -c "
import json
meta = {
  'start_time_utc': '${start_utc}',
  'end_time_utc': '${start_utc}',
  'duration_seconds': 0,
  'kernel_version': '${kernel_ver}',
  'libc_version': '${libc_ver}',
  'toolchain_version': '${toolchain_ver}',
  'toolchain_dir': '${TOOLCHAIN_DIR}',
  'execution_user': '${user_inf}',
  'preflight_limit_exit': int('${PREFLIGHT_LIMIT_EXIT}'),
  'recreation_byte_match': False,
  'first_run_exit_code': None,
  'second_run_exit_code': None,
  'first_run_outcome': None,
  'second_run_outcome': None,
  'final_behavioral_outcome': 'EXTERNAL_EXECUTION_BLOCKER',
  'blocker_reason': '${reason}',
  'test_stub_mode': '${is_stub}' == '1'
}
with open('run_metadata.json', 'w') as f:
    json.dump(meta, f, indent=2)
"
}

if [ "${PREFLIGHT_LIMIT_EXIT}" -ne 0 ]; then
  echo "Error: Preflight resource limit check failed with exit code ${PREFLIGHT_LIMIT_EXIT}" >&2
  write_preflight_blocker_metadata "preflight_resource_limit_failed"
  exit 2
fi

# 2. Input and Toolchain Integrity Verification
PINNED_POC_SHA256="ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b"
ACTUAL_POC_SHA256="$(sha256sum "${POC_FILE}" | awk '{print $1}')"

if [ "${TEST_STUB_MODE:-0}" != "1" ]; then
  if [ "${ACTUAL_POC_SHA256}" != "${PINNED_POC_SHA256}" ]; then
    echo "Error: PoC SHA-256 mismatch: expected ${PINNED_POC_SHA256}, got ${ACTUAL_POC_SHA256}" >&2
    write_preflight_blocker_metadata "poc_sha256_mismatch"
    exit 2
  fi

  # Verify toolchain binary against pinned toolchain_pins.json
  PINS_JSON="${REPO_ROOT}/harness/toolchain_pins.json"
  TOOLCHAIN_VER="$(basename "${TOOLCHAIN_DIR}")"
  ACTUAL_BIN_SHA="$(sha256sum "${LEAN_BIN}" | awk '{print $1}')"

  EXPECTED_BIN_SHA="$(python3 -c "
import json
with open('${PINS_JSON}') as f:
    d = json.load(f)
print(d.get('toolchains', {}).get('${TOOLCHAIN_VER}', {}).get('bin_lean_sha256') or '')
" 2>/dev/null || echo '')"

  if [ -z "${EXPECTED_BIN_SHA}" ] || [ "${ACTUAL_BIN_SHA}" != "${EXPECTED_BIN_SHA}" ]; then
    echo "Error: Toolchain binary SHA-256 mismatch for ${TOOLCHAIN_VER}: expected '${EXPECTED_BIN_SHA}', got '${ACTUAL_BIN_SHA}'" >&2
    write_preflight_blocker_metadata "lean_bin_sha256_mismatch"
    exit 2
  fi

  # Verify libleanshared.so against pinned toolchain_pins.json (B-13)
  SHARED_SO="${TOOLCHAIN_DIR}/lib/lean/libleanshared.so"
  if [ ! -f "${SHARED_SO}" ]; then
    echo "Error: Toolchain shared library not found at ${SHARED_SO}" >&2
    write_preflight_blocker_metadata "libleanshared_so_missing"
    exit 2
  fi

  ACTUAL_SO_SHA="$(sha256sum "${SHARED_SO}" | awk '{print $1}')"
  EXPECTED_SO_SHA="$(python3 -c "
import json
with open('${PINS_JSON}') as f:
    d = json.load(f)
print(d.get('toolchains', {}).get('${TOOLCHAIN_VER}', {}).get('libleanshared_so_sha256') or '')
" 2>/dev/null || echo '')"

  if [ -z "${EXPECTED_SO_SHA}" ] || [ "${ACTUAL_SO_SHA}" != "${EXPECTED_SO_SHA}" ]; then
    echo "Error: Toolchain shared library SHA-256 mismatch for ${TOOLCHAIN_VER}: expected '${EXPECTED_SO_SHA}', got '${ACTUAL_SO_SHA}'" >&2
    write_preflight_blocker_metadata "libleanshared_so_sha256_mismatch"
    exit 2
  fi
fi

# 3. Capture git commit from REPO_ROOT
git -C "${REPO_ROOT}" rev-parse HEAD > git_commit.txt 2>/dev/null || echo "GIT_NOT_AVAILABLE" > git_commit.txt

# 4. Write literal execution command script containing exact absolute paths, environment, and enforcement
# Per Operator decision (2026-09-11), kernel network-namespace isolation (unshare --net) is not required;
# zero network operations are permitted during execution runs, enforced contractually with pinned toolchain pre-extraction.
cat << CMD_EOF > command.sh
#!/usr/bin/env bash
set -euo pipefail
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LEAN_PATH=""
export PATH="${TOOLCHAIN_DIR}/bin:/usr/bin:/bin"

# Capture the exact execution environment variables
env | sort > env.txt

prlimit --as=4294967296 timeout --kill-after=5s 60s "${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 "${POC_FILE}" > stdout.bin 2> stderr.bin || echo \$? > exit-code.txt
if [ ! -s exit-code.txt ]; then
  echo 0 > exit-code.txt
fi
CMD_EOF
chmod +x command.sh

START_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
START_EPOCH="$(date +%s)"

# 5. First Run
./command.sh

# 6. Archive First Run
mkdir -p first-run
cp stdout.bin stderr.bin exit-code.txt first-run/

# Helper function to classify run outputs using behavior_matcher.py
classify_run() {
  local dir="$1"
  local ecode
  ecode="$(cat "${dir}/exit-code.txt" | tr -d '[:space:]')"

  if [ "${ecode}" -eq 124 ]; then
    echo "EXTERNAL_EXECUTION_BLOCKER"
  else
    python3 -c "
import sys
sys.path.insert(0, '${REPO_ROOT}/scripts')
try:
    import behavior_matcher
    print(behavior_matcher.classify(
        open('${POC_FILE}', encoding='utf-8').read(),
        open('${dir}/stdout.bin', encoding='utf-8', errors='replace').read(),
        open('${dir}/stderr.bin', encoding='utf-8', errors='replace').read(),
        int('${ecode}')
    ))
except Exception as exc:
    print('EVIDENCE_INSUFFICIENT')
"
  fi
}

FIRST_RUN_OUTCOME="$(classify_run first-run)"

# 7. Between-Run Cleanup (PRESERVING first-run/)
rm -rf .lake build *.olean *.ilean *.c stdout.bin stderr.bin exit-code.txt

# 8. Second Run (Recreation)
./command.sh
mkdir -p second-run
mv stdout.bin stderr.bin exit-code.txt second-run/

SECOND_RUN_OUTCOME="$(classify_run second-run)"

END_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
END_EPOCH="$(date +%s)"
DURATION_SECONDS=$(( END_EPOCH - START_EPOCH ))

# 9. Byte-for-byte Recreation Verification
RECREATION_MATCH="True"
cmp -s first-run/stdout.bin second-run/stdout.bin || RECREATION_MATCH="False"
cmp -s first-run/stderr.bin second-run/stderr.bin || RECREATION_MATCH="False"
cmp -s first-run/exit-code.txt second-run/exit-code.txt || RECREATION_MATCH="False"

# Determine final behavioral outcome with strict precedence per INSTANCE_RULES.md:67 & Operator authority:
# 1. Recreation byte mismatch -> EVIDENCE_INSUFFICIENT
# 2. Solely listed external blocker (both runs EEB) -> EXTERNAL_EXECUTION_BLOCKER
# 3. Both runs produce identical valid matcher outcome -> that outcome (ACCEPT or EXPECTED_NATIVE_REJECTION)
# 4. All other cases (mixed outcomes, divergent classifications) -> EVIDENCE_INSUFFICIENT
if [ "${RECREATION_MATCH}" != "True" ]; then
  FINAL_BEHAVIORAL_OUTCOME="EVIDENCE_INSUFFICIENT"
elif [ "${FIRST_RUN_OUTCOME}" = "EXTERNAL_EXECUTION_BLOCKER" ] && [ "${SECOND_RUN_OUTCOME}" = "EXTERNAL_EXECUTION_BLOCKER" ]; then
  FINAL_BEHAVIORAL_OUTCOME="EXTERNAL_EXECUTION_BLOCKER"
elif [ "${FIRST_RUN_OUTCOME}" = "${SECOND_RUN_OUTCOME}" ]; then
  FINAL_BEHAVIORAL_OUTCOME="${FIRST_RUN_OUTCOME}"
else
  FINAL_BEHAVIORAL_OUTCOME="EVIDENCE_INSUFFICIENT"
fi

# 9. Compute artifact hashes
python3 -c "
import hashlib, json

def h(path):
    with open(path, 'rb') as f:
        return hashlib.sha256(f.read()).hexdigest()

data = {
    'poc_sha256': h('${POC_FILE}'),
    'lean_bin_sha256': h('${LEAN_BIN}'),
    'first_run_stdout_sha256': h('first-run/stdout.bin'),
    'first_run_stderr_sha256': h('first-run/stderr.bin'),
    'first_run_exit_code': open('first-run/exit-code.txt').read().strip(),
    'second_run_stdout_sha256': h('second-run/stdout.bin'),
    'second_run_stderr_sha256': h('second-run/stderr.bin'),
    'second_run_exit_code': open('second-run/exit-code.txt').read().strip(),
    'recreation_match': ${RECREATION_MATCH},
    'final_behavioral_outcome': '${FINAL_BEHAVIORAL_OUTCOME}'
}
with open('hashes.json', 'w') as f:
    json.dump(data, f, indent=2)
"

# 10. Extract host system metadata and write run_metadata.json
KERNEL_VERSION="$(uname -r)"
LIBC_VERSION="$(python3 -c 'import platform; print(" ".join(platform.libc_ver()))' 2>/dev/null || echo 'unknown')"
TOOLCHAIN_VERSION="$(basename "${TOOLCHAIN_DIR}")"
USER_INFO="$(id -u):$(id -g) ($(id -un))"

python3 -c "
import json

metadata = {
  'start_time_utc': '${START_TIME_UTC}',
  'end_time_utc': '${END_TIME_UTC}',
  'duration_seconds': int('${DURATION_SECONDS}'),
  'kernel_version': '${KERNEL_VERSION}',
  'libc_version': '${LIBC_VERSION}',
  'toolchain_version': '${TOOLCHAIN_VERSION}',
  'toolchain_dir': '${TOOLCHAIN_DIR}',
  'execution_user': '${USER_INFO}',
  'preflight_limit_exit': int('${PREFLIGHT_LIMIT_EXIT}'),
  'recreation_byte_match': ${RECREATION_MATCH},
  'first_run_exit_code': int(open('first-run/exit-code.txt').read().strip()),
  'second_run_exit_code': int(open('second-run/exit-code.txt').read().strip()),
  'first_run_outcome': '${FIRST_RUN_OUTCOME}',
  'second_run_outcome': '${SECOND_RUN_OUTCOME}',
  'final_behavioral_outcome': '${FINAL_BEHAVIORAL_OUTCOME}',
  'test_stub_mode': '${TEST_STUB_MODE:-0}' == '1'
}

with open('run_metadata.json', 'w') as f:
    json.dump(metadata, f, indent=2)
"

echo "Behavioral run completed. First: ${FIRST_RUN_OUTCOME}, Second: ${SECOND_RUN_OUTCOME}, Recreation match: ${RECREATION_MATCH}, Final: ${FINAL_BEHAVIORAL_OUTCOME}"
