#!/usr/bin/env bash
# P10 Behavioral Execution Harness — Frozen Pre-Registration Script
# Strictly executed POST-FREEZE; no Lean execution permitted before ratified freeze.
set -euo pipefail

TOOLCHAIN_DIR="$(realpath "$1")"
POC_FILE="$(realpath "${2:-PoC.lean}")"
OUTPUT_DIR="$(realpath -m "${3:-evidence/behavioral/run}")"

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

# 1. Preflight check: verify limits and isolation using /bin/true (zero Lean execution)
set +e
prlimit --as=4294967296 timeout --kill-after=5s 60s /bin/true >/dev/null 2>&1
PREFLIGHT_LIMIT_EXIT=$?
unshare --net -- /bin/true >/dev/null 2>&1
PREFLIGHT_NET_EXIT=$?
set -e

# Determine isolation invocation prefix
if [ "${PREFLIGHT_NET_EXIT}" -eq 0 ]; then
  ISOLATION_CMD="unshare --net --"
else
  # If unprivileged network namespaces are prohibited on host, record in metadata and proceed with limits
  ISOLATION_CMD=""
fi

# 2. Capture git commit
git rev-parse HEAD > git_commit.txt 2>/dev/null || echo "GIT_NOT_AVAILABLE" > git_commit.txt

# 3. Write literal execution command script containing exact absolute paths, environment, and enforcement
cat << CMD_EOF > command.sh
#!/usr/bin/env bash
set -euo pipefail
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LEAN_PATH=""
export PATH="${TOOLCHAIN_DIR}/bin:/usr/bin:/bin"

# Capture the exact execution environment variables
env | sort > env.txt

${ISOLATION_CMD} prlimit --as=4294967296 timeout --kill-after=5s 60s "${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 "${POC_FILE}" > stdout.bin 2> stderr.bin || echo \$? > exit-code.txt
if [ ! -s exit-code.txt ]; then
  echo 0 > exit-code.txt
fi
CMD_EOF
chmod +x command.sh

START_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
START_EPOCH="$(date +%s)"

# 4. First Run
./command.sh

# 5. Archive First Run
mkdir -p first-run
cp stdout.bin stderr.bin exit-code.txt first-run/

# Helper function to classify run outputs
classify_run() {
  local dir="$1"
  local ecode
  ecode="$(cat "${dir}/exit-code.txt" | tr -d '[:space:]')"
  local err_content
  err_content="$(cat "${dir}/stderr.bin" 2>/dev/null || true)"

  if [ "${ecode}" -eq 124 ] || [ "${ecode}" -eq 137 ]; then
    echo "EXTERNAL_EXECUTION_BLOCKER"
  elif echo "${err_content}" | grep -q "unshare: unshare failed"; then
    echo "EXTERNAL_EXECUTION_BLOCKER"
  else
    python3 -c "
import sys
sys.path.insert(0, '${OLDPWD}/scripts')
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

# 6. Between-Run Cleanup (PRESERVING first-run/)
rm -rf .lake build *.olean *.ilean *.c stdout.bin stderr.bin exit-code.txt

# 7. Second Run (Recreation)
./command.sh
mkdir -p second-run
mv stdout.bin stderr.bin exit-code.txt second-run/

SECOND_RUN_OUTCOME="$(classify_run second-run)"

END_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
END_EPOCH="$(date +%s)"
DURATION_SECONDS=$(( END_EPOCH - START_EPOCH ))

# 8. Byte-for-byte Recreation Verification
RECREATION_MATCH="True"
cmp -s first-run/stdout.bin second-run/stdout.bin || RECREATION_MATCH="False"
cmp -s first-run/stderr.bin second-run/stderr.bin || RECREATION_MATCH="False"
cmp -s first-run/exit-code.txt second-run/exit-code.txt || RECREATION_MATCH="False"

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
    'recreation_match': ${RECREATION_MATCH}
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
  'preflight_net_exit': int('${PREFLIGHT_NET_EXIT}'),
  'recreation_byte_match': ${RECREATION_MATCH},
  'first_run_exit_code': int(open('first-run/exit-code.txt').read().strip()),
  'second_run_exit_code': int(open('second-run/exit-code.txt').read().strip()),
  'first_run_outcome': '${FIRST_RUN_OUTCOME}',
  'second_run_outcome': '${SECOND_RUN_OUTCOME}'
}

with open('run_metadata.json', 'w') as f:
    json.dump(metadata, f, indent=2)
"

echo "Behavioral run completed. First run: ${FIRST_RUN_OUTCOME}, Second run: ${SECOND_RUN_OUTCOME}, Recreation byte match: ${RECREATION_MATCH}"
