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
assert m['final_outcome'] == 'EXTERNAL_EXECUTION_BLOCKER'
"

# 3. Test execution from arbitrary working directory (/tmp) to verify cwd-independence
(
  cd /tmp
  bash "${REPO_ROOT}/harness/run_behavioral.sh" "${TMP_DIR}/fake_toolchain" "${TMP_DIR}/PoC.lean" "${TMP_DIR}/run_out_cwd_test"
)

test -f "${TMP_DIR}/run_out_cwd_test/hashes.json"
test -f "${TMP_DIR}/run_out_cwd_test/run_metadata.json"

echo "ALL HARNESS STUB TESTS PASSED (0 Lean runs)."
