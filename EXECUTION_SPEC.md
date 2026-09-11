# Execution Specification — Frozen Toolchains, Environment, Harness, and Limits

Status: PRE-FREEZE CANDIDATE SPECIFICATION  
Execution Authorization: PENDING FORMAL GATE REVIEW AND OPERATOR RATIFICATION  
Pre-freeze Prohibition: `LEAN_RUNS=0` (no execution on test artifact prior to ratified freeze)

---

## 1. Pinned Behavioral Toolchains (T-A)

The behavioral evaluation tests three specific Lean 4 release distribution archives for Linux x86_64:

| Version | Asset Filename | Byte Size | SHA-256 Digest | Official Distribution URL |
| :--- | :--- | :---: | :---: | :--- |
| **Lean v4.32.2** | `lean-4.32.2-linux.tar.zst` | 563,991,635 | `5f2069e6f5db73780f374ccb49ce8ea649aa20a0cebf0116816744c999ce72aa` | `https://github.com/leanprover/lean4/releases/download/v4.32.2/lean-4.32.2-linux.tar.zst` |
| **Lean v4.33.1** | `lean-4.33.1-linux.tar.zst` | 570,405,234 | `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235` | `https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst` |
| **Lean v4.34.0-rc1** | `lean-4.34.0-rc1-linux.tar.zst` | 575,410,932 | `41dc6a6ec143ece8ed4ba4c4c6978c91f21ad5cbe3c4e7728ad31b869961dc17` | `https://github.com/leanprover/lean4/releases/download/v4.34.0-rc1/lean-4.34.0-rc1-linux.tar.zst` |

Retrieval, extraction, and invocation provenance:
- Assets retrieved directly from official GitHub releases of repository `leanprover/lean4`.
- Exact full-archive verified SHA-256 digests and content lengths established and recorded in `harness/pin_provenance.json`.
- Pre-invocation integrity check: Prior to extraction and execution, the archive file SHA-256 digest is verified against the pinned digest; any mismatch produces `EXTERNAL_EXECUTION_BLOCKER`.
- Unpacking mechanism: `tar --zstd -xf <archive> -C <toolchain_dir>`.
- Lean executable path: literal absolute path `<toolchain_dir>/bin/lean`.
- Invariant: Invocation occurs strictly through the direct unpacked binary path; elan proxies and dynamic toolchain dispatch wrappers are prohibited.

---

## 2. Pinned Execution Environment

The execution environment is pinned to a single, concrete reference platform:

- **Operating System:** Linux kernel 7.0.0-31-generic x86_64.
- **Userland Distribution:** Ubuntu 24.04.4 LTS (noble).
- **Architecture:** x86_64 (64-bit).
- **Execution User:** `volmax-studio` (UID 1000, GID 1000).
- **C Library (libc):** Ubuntu GLIBC 2.39-0ubuntu8.8 (`libc.so.6`).
- **C Compiler:** GCC 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1).
- **Shell:** `/bin/bash` version 5.2.21(1)-release.
- **Memory Bound:** Maximum virtual memory limit 4096 MB enforced via `prlimit --as=4294967296`.
- **Per-Invocation Timeout:** 60 seconds enforced via `timeout --kill-after=5s 60s`.
- **Network Isolation:** Per explicit Operator decision (2026-09-11), kernel network-namespace isolation (`unshare --net`) is not required on the host platform. Instead, zero network operations are permitted during behavioral execution runs, enforced contractually with pinned toolchain pre-extraction.
- **Required Environment Variables:**
  ```bash
  export LANG="C.UTF-8"
  export LC_ALL="C.UTF-8"
  export LEAN_PATH=""
  export PATH="<toolchain_dir>/bin:/usr/bin:/bin"
  ```

---

## 3. Exact Execution Harness, Preflight & Command

### Toolchain Acquisition Phase
Per Operator decision (2026-09-11), toolchain acquisition and verification is a dedicated, pinned pre-execution phase executed via `harness/acquire_toolchains.sh`:
1. The distribution archive is downloaded from the pinned release asset URL.
2. The byte length and SHA-256 digest of the archive are verified strictly against the pinned values in `EXECUTION_SPEC.md` and `harness/pin_provenance.json`. Any mismatch terminates with exit code 1.
3. The archive is unpacked without Lean execution: `tar --zstd -xf <archive> -C <toolchain_dir>`.
4. The unpacked executable `<toolchain_dir>/bin/lean` is located, verified executable, and its SHA-256 digest is measured.

### Preflight Limit & Input Integrity Verification
Before any test artifact run, the behavioral harness verifies wrapper availability and permissions using `/bin/true` (zero Lean execution):
```bash
prlimit --as=4294967296 timeout --kill-after=5s 60s /bin/true
```
If this preflight command fails, execution halts, records `EXTERNAL_EXECUTION_BLOCKER` in `run_metadata.json`, and exits with code 2.

Next, input integrity is verified before execution:
- `PoC.lean` SHA-256 digest is verified against the pinned digest (`ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b`).
- `LEAN_BIN` must exist and be executable.
Any input verification failure halts execution, writes `run_metadata.json` with `final_behavioral_outcome: "EXTERNAL_EXECUTION_BLOCKER"`, and exits with code 2 without invoking Lean.

### Literal Invocation Script (`command.sh`)
Per `INSTANCE_RULES.md#behavioral-criteria-and-recreation` and `DIAGNOSTIC_PROFILE.json`, with virtual address space limit (4096 MB), per-invocation timeout (60s), and environment enforcement:
```bash
#!/usr/bin/env bash
set -euo pipefail
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LEAN_PATH=""
export PATH="${TOOLCHAIN_DIR}/bin:/usr/bin:/bin"

# Capture the exact execution environment variables
env | sort > env.txt

prlimit --as=4294967296 timeout --kill-after=5s 60s "${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 "${POC_FILE}" > stdout.bin 2> stderr.bin || echo $? > exit-code.txt
if [ ! -s exit-code.txt ]; then
  echo 0 > exit-code.txt
fi
```

### Input & Output Paths
- Input file: `PoC.lean` (UTF-8 encoded; extracted per `scripts/extract_poc.py`).
- Output binary stream 1: `stdout.bin` (raw binary stream; literal UTF-8 bytes).
- Output binary stream 2: `stderr.bin` (raw binary stream; literal UTF-8 bytes).
- Exit code: `exit-code.txt` (ASCII decimal integer followed by newline).
- Environment capture: `env.txt` (sorted snapshot of active environment variables during invocation).

### Wrapper Error Classification & Matcher Invocation
Per `INSTANCE_RULES.md:47`, wrapper-level failures (timeout, host permission denial) take precedence over Lean behavioral parsing:
- If exit code is `124` (timeout): classify run outcome as `EXTERNAL_EXECUTION_BLOCKER`.
- Exit code `137` (SIGKILL / OOM / crash) without an independently verified host external blocker is conservatively classified as `EVIDENCE_INSUFFICIENT` rather than assuming resource-limit exhaustion.
- Otherwise, invoke `scripts/behavior_matcher.py`:
  ```bash
  python3 scripts/behavior_matcher.py "${POC_FILE}" stdout.bin stderr.bin $(cat exit-code.txt)
  ```
  yielding `ACCEPT`, `EXPECTED_NATIVE_REJECTION`, or `EVIDENCE_INSUFFICIENT`.

### Final Behavioral Outcome Precedence
For the two-run deterministic recreation sequence, the overall run outcome (`final_behavioral_outcome`) is evaluated strictly in accordance with `INSTANCE_RULES.md:67`:
1. `recreation mismatch` (`RECREATION_MATCH != "True"`) $\to$ `EVIDENCE_INSUFFICIENT`
2. `solely listed external blocker` (both runs produce `EXTERNAL_EXECUTION_BLOCKER`, or preflight/integrity failure) $\to$ `EXTERNAL_EXECUTION_BLOCKER`
3. `both recreated runs produce identical valid matcher outcome` $\to$ that outcome (`ACCEPT` or `EXPECTED_NATIVE_REJECTION`)
4. `all other cases` (divergent outcomes, unexpected errors, mixed runs) $\to$ `EVIDENCE_INSUFFICIENT`

---

## 4. Deterministic Recreation Sequence

For each of the three pinned toolchain versions:
1. **Preflight verification:** Run non-Lean wrapper check with `/bin/true`.
2. **Preserve clean environment:** Prepare clean isolated workspace. Place `PoC.lean`. Record `git_commit.txt`. Generate and execute `command.sh` (which writes active `env.txt`).
3. **First Run:** Execute `command.sh`. Capture `stdout.bin`, `stderr.bin`, `exit-code.txt`. Classify run 1 outcome.
4. **Archive First Run:** Create directory `first-run/` and copy `stdout.bin`, `stderr.bin`, `exit-code.txt` into `first-run/`.
5. **Between-Run Cleanup:** Execute cleanup removing strictly items on the Between-Run Allowlist. `first-run/` is preserved and must never be deleted.
6. **Second Run (Recreation):** Re-execute `command.sh` with identical inputs and environment in the workspace. Move recreated outputs `stdout.bin`, `stderr.bin`, `exit-code.txt` into `second-run/`. Classify run 2 outcome.
7. **Byte-for-Byte Comparison:**
   ```bash
   cmp -s first-run/stdout.bin second-run/stdout.bin
   cmp -s first-run/stderr.bin second-run/stderr.bin
   cmp -s first-run/exit-code.txt second-run/exit-code.txt
   ```
   Any byte mismatch immediately yields `EVIDENCE_INSUFFICIENT` for affected subclaims.
8. **Package Evidence:** Package the full P10 evidence-run artifacts into `evidence/behavioral/{version}/`.

---

## 5. Cleanup Allowlist & Invariants

### Between-Run Allowlist (run 1 -> run 2)
Only the following transient build artifacts may be deleted between first-run and recreation:
- `.lake/`
- `build/`
- `*.olean`
- `*.ilean`
- `*.c`
- `stdout.bin` (in root workspace)
- `stderr.bin` (in root workspace)
- `exit-code.txt` (in root workspace)

**STRICT PRESERVATION INVARIANT:**  
`first-run/` is an immutable evidence record and **MUST NEVER BE DELETED** during between-run cleanup. It persists until byte comparison against `second-run/` has finished and the comparison verdict is logged.

### Absolute Prohibitions
Nothing outside the enumerated between-run allowlist may be deleted. Source inputs (`PoC.lean`), toolchain binaries, parent repository files, manifests, and archived run outputs are protected from deletion.

---

## 6. Complete P10 Evidence-Run Package

For each version run, the frozen harness outputs a standardized evidence bundle containing:
- `command.sh`: Exact literal shell script executed.
- `stdout.bin`: Raw byte capture of standard output.
- `stderr.bin`: Raw byte capture of standard error.
- `exit-code.txt`: Literal exit code.
- `env.txt`: Captured runtime environment variables.
- `git_commit.txt`: Exact commit SHA of repository during execution.
- `hashes.json`: SHA-256 hashes of input (`PoC.lean`), outputs (`stdout.bin`, `stderr.bin`), toolchain binary, and exit code.
- `run_metadata.json`: UTC start/end timestamps, duration, host user/kernel/libc version, toolchain version, recreation byte comparison verdict, wrapper error classification, individual run outcomes, and `final_behavioral_outcome`.

---

## 7. Pinned T-B1 Acquisition & Execution Procedure (Post-Freeze)

For all 45 denominator tags resolved in `TAG_MANIFEST.json`, the post-freeze acquisition and execution procedure is pinned as follows:

1. **Commit Resolution:** Use the exact `resolved_commit_sha` recorded in `TAG_MANIFEST.json`.
2. **Deterministic URL Template:**
   - `Basic.lean`: `https://raw.githubusercontent.com/leanprover/lean4/{resolved_commit_sha}/src/Init/Data/String/Basic.lean`
   - `object.cpp`: `https://raw.githubusercontent.com/leanprover/lean4/{resolved_commit_sha}/src/runtime/object.cpp`
3. **Storage & Hash Capture:**
   - Target files saved to `evidence/t_b1/{tag}/Basic.lean` and `evidence/t_b1/{tag}/object.cpp`.
   - Record HTTP status codes, byte sizes, and SHA-256 hashes in `evidence/t_b1_manifest.json`.
4. **Source Proxy Invocation:**
   ```bash
   python3 scripts/source_proxy.py evidence/t_b1/{tag}/Basic.lean evidence/t_b1/{tag}/object.cpp
   ```
5. **Output Capture:** Record literal stdout, stderr, exit code, and classification (`MISMATCH` / `NO_MISMATCH` / `PREDICATE_INAPPLICABLE`) in `evidence/t_b1_results.json`.
6. **Pre-Freeze Prohibition:** Neither source retrieval nor `source_proxy.py` execution on denominator members is permitted prior to formal freeze.
