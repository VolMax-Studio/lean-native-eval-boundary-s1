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

# 1. Capture git commit
git rev-parse HEAD > git_commit.txt 2>/dev/null || echo "GIT_NOT_AVAILABLE" > git_commit.txt

# 2. Write literal execution command script containing exact absolute paths, environment, and enforcement
cat << CMD_EOF > command.sh
#!/usr/bin/env bash
set -euo pipefail
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LEAN_PATH=""
export PATH="${TOOLCHAIN_DIR}/bin:/usr/bin:/bin"

# Capture the exact execution environment variables
env | sort > env.txt

unshare --net -- prlimit --as=4294967296 timeout --kill-after=5s 60s "${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 "${POC_FILE}" > stdout.bin 2> stderr.bin || echo \$? > exit-code.txt
if [ ! -s exit-code.txt ]; then
  echo 0 > exit-code.txt
fi
CMD_EOF
chmod +x command.sh

START_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
START_EPOCH="$(date +%s)"

# 3. First Run
./command.sh

# 4. Archive First Run
mkdir -p first-run
cp stdout.bin stderr.bin exit-code.txt first-run/

# 5. Between-Run Cleanup (PRESERVING first-run/)
rm -rf .lake build *.olean *.ilean *.c stdout.bin stderr.bin exit-code.txt

# 6. Second Run (Recreation)
./command.sh
mkdir -p second-run
mv stdout.bin stderr.bin exit-code.txt second-run/

END_TIME_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
END_EPOCH="$(date +%s)"
DURATION_SECONDS=$(( END_EPOCH - START_EPOCH ))

# 7. Byte-for-byte Recreation Verification
RECREATION_MATCH="true"
cmp -s first-run/stdout.bin second-run/stdout.bin || RECREATION_MATCH="false"
cmp -s first-run/stderr.bin second-run/stderr.bin || RECREATION_MATCH="false"
cmp -s first-run/exit-code.txt second-run/exit-code.txt || RECREATION_MATCH="false"

# 8. Compute artifact hashes
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

# 9. Extract host system metadata and write run_metadata.json
KERNEL_VERSION="$(uname -r)"
LIBC_VERSION="$(python3 -c 'import platform; print(\" \".join(platform.libc_ver()))' 2>/dev/null || echo 'unknown')"
TOOLCHAIN_VERSION="$(basename "${TOOLCHAIN_DIR}")"

cat << META_EOF > run_metadata.json
{
  "start_time_utc": "${START_TIME_UTC}",
  "end_time_utc": "${END_TIME_UTC}",
  "duration_seconds": ${DURATION_SECONDS},
  "kernel_version": "${KERNEL_VERSION}",
  "libc_version": "${LIBC_VERSION}",
  "toolchain_version": "${TOOLCHAIN_VERSION}",
  "toolchain_dir": "${TOOLCHAIN_DIR}",
  "recreation_byte_match": ${RECREATION_MATCH},
  "first_run_exit_code": $(cat first-run/exit-code.txt),
  "second_run_exit_code": $(cat second-run/exit-code.txt)
}
META_EOF

echo "Behavioral run completed. Recreation byte match: ${RECREATION_MATCH}"
