#!/usr/bin/env bash
# Self-test harness execution with stub binaries (zero Lean execution)
set -euo pipefail

TMP_DIR="$(mktemp -d /tmp/harness_stub_test_XXXXXX)"
trap 'rm -rf "${TMP_DIR}"' EXIT

mkdir -p "${TMP_DIR}/fake_toolchain/bin"
mkdir -p "${TMP_DIR}/run_out"

# 0. Set REPO_ROOT
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# 1. Test normal execution with synthetic PoC and stub binary
cat << 'MOCK_EOF' > "${TMP_DIR}/fake_toolchain/bin/lean"
#!/usr/bin/env bash
echo "'flt' depends on axioms: [propext, Classical.choice, Quot.sound, Lean.Elab.Tactic.native_decide]"
exit 0
MOCK_EOF
chmod +x "${TMP_DIR}/fake_toolchain/bin/lean"

cat << 'POC_EOF' > "${TMP_DIR}/PoC.lean"
import Lean
open Lean

theorem flt : False := by
  native_decide
POC_EOF

export TEST_STUB_MODE=1

bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out"

test -f "${TMP_DIR}/run_out/hashes.json"
test -f "${TMP_DIR}/run_out/run_metadata.json"
test -f "${TMP_DIR}/run_out/first-run/stdout.bin"
test -f "${TMP_DIR}/run_out/second-run/stdout.bin"

python3 -c "
import json
with open('${TMP_DIR}/run_out/hashes.json') as f:
    h = json.load(f)
assert h['recreation_match'] is True

with open('${TMP_DIR}/run_out/run_metadata.json') as f:
    m = json.load(f)
assert m['first_run_outcome'] == 'ACCEPT'
assert m['second_run_outcome'] == 'ACCEPT'
assert m['recreation_byte_match'] is True
assert m['final_behavioral_outcome'] == 'ACCEPT'
"

# 2. Test timeout exit code 124 mapping to EXTERNAL_EXECUTION_BLOCKER
cat << 'MOCK_TIMEOUT_EOF' > "${TMP_DIR}/fake_toolchain/bin/lean"
#!/usr/bin/env bash
exit 124
MOCK_TIMEOUT_EOF

bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_timeout"

python3 -c "
import json
with open('${TMP_DIR}/run_out_timeout/run_metadata.json') as f:
    m = json.load(f)
assert m['first_run_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
assert m['second_run_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
assert m['final_behavioral_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
"

# 3. Test exit code 137 (SIGKILL/crash) conservatively mapping to EVIDENCE_INSUFFICIENT
cat << 'MOCK_137_EOF' > "${TMP_DIR}/fake_toolchain/bin/lean"
#!/usr/bin/env bash
exit 137
MOCK_137_EOF

bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_137"

python3 -c "
import json
with open('${TMP_DIR}/run_out_137/run_metadata.json') as f:
    m = json.load(f)
assert m['first_run_outcome'] == 'EVIDENCE_INSUFFICIENT'
assert m['second_run_outcome'] == 'EVIDENCE_INSUFFICIENT'
assert m['final_behavioral_outcome'] == 'EVIDENCE_INSUFFICIENT'
"

# 4. Test mixed run (first run timeout 124, second run ACCEPT 0) -> recreation mismatch -> EVIDENCE_INSUFFICIENT (B-9)
COUNT_FILE="${TMP_DIR}/call_count.txt"
echo 0 > "${COUNT_FILE}"

cat << MOCK_MIXED_EOF > "${TMP_DIR}/fake_toolchain/bin/lean"
#!/usr/bin/env bash
count=\$(cat "${COUNT_FILE}")
count=\$(( count + 1 ))
echo "\${count}" > "${COUNT_FILE}"
if [ "\${count}" -eq 1 ]; then
  exit 124
else
  echo "'flt' depends on axioms: [propext, demo.native_decide.ax_1]"
  exit 0
fi
MOCK_MIXED_EOF

bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_mixed"

python3 -c "
import json
with open('${TMP_DIR}/run_out_mixed/run_metadata.json') as f:
    m = json.load(f)
assert m['first_run_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
assert m['second_run_outcome'] == 'ACCEPT'
assert m['recreation_byte_match'] is False
assert m['final_behavioral_outcome'] == 'EVIDENCE_INSUFFICIENT'
"

# 5. Test PoC digest mismatch in non-test mode writing run_metadata.json and exiting with code 2 (B-8, F-16)
set +e
TEST_STUB_MODE=0 bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_mismatch" 2>/dev/null
POC_MISMATCH_EXIT=$?
set -e

if [ "${POC_MISMATCH_EXIT}" -ne 2 ]; then
  echo "Expected exit 2 on PoC mismatch, got ${POC_MISMATCH_EXIT}" >&2
  exit 1
fi

test -f "${TMP_DIR}/run_out_mismatch/run_metadata.json"
python3 -c "
import json
with open('${TMP_DIR}/run_out_mismatch/run_metadata.json') as f:
    m = json.load(f)
assert m['final_behavioral_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
assert m['blocker_reason'] == 'poc_sha256_mismatch'
"

# 6. Test execution from arbitrary working directory (/tmp) to verify cwd-independence
(
  cd /tmp
  bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_cwd_test"
)

test -f "${TMP_DIR}/run_out_cwd_test/hashes.json"
test -f "${TMP_DIR}/run_out_cwd_test/run_metadata.json"

echo "ALL HARNESS STUB TESTS PASSED (0 Lean runs)."
