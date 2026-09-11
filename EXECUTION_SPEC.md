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
| **Lean v4.33.1** | `lean-4.33.1-linux.tar.zst` | 570,405,234 | `2f8c10644606d7cb99c51267e2e0acd2bf90eac9619efbfa37330cfd9eb78bbf` | `https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst` |
| **Lean v4.34.0-rc1** | `lean-4.34.0-rc1-linux.tar.zst` | 575,410,932 | `41dc6a6ec143ece8ed4ba4c4c6978c91f21ad5cbe3c4e7728ad31b869961dc17` | `https://github.com/leanprover/lean4/releases/download/v4.34.0-rc1/lean-4.34.0-rc1-linux.tar.zst` |

Retrieval, extraction, and invocation provenance:
- Assets retrieved directly from official GitHub releases of repository `leanprover/lean4`.
- Exact stream-verified SHA-256 digests and content lengths established and recorded in `harness/pin_provenance.json`.
- Unpacking mechanism: `tar --zstd -xf <archive> -C <toolchain_dir>`.
- Lean executable path: literal absolute path `<toolchain_dir>/bin/lean`.
- Invariant: Invocation occurs strictly through the direct unpacked binary path; elan proxies and dynamic toolchain dispatch wrappers are prohibited.

---

## 2. Pinned Execution Environment

The execution environment is pinned to a single, concrete reference platform:

- **Operating System:** Linux kernel 7.0.0-31-generic x86_64.
- **Userland Distribution:** Ubuntu 24.04.1 LTS (noble).
- **Architecture:** x86_64 (64-bit).
- **C Library (libc):** Ubuntu GLIBC 2.39-0ubuntu8.8 (`libc.so.6`).
- **C Compiler:** GCC 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1).
- **Shell:** `/bin/bash` version 5.2.21(1)-release.
- **Network Isolation:** Process network namespace isolation enforced via `unshare --net --`.
- **Memory Bound:** Maximum virtual memory limit 4096 MB enforced via `prlimit --as=4294967296`.
- **Required Environment Variables:**
  ```bash
  export LANG="C.UTF-8"
  export LC_ALL="C.UTF-8"
  export LEAN_PATH=""
  export PATH="<toolchain_dir>/bin:/usr/bin:/bin"
  ```

---

## 3. Exact Execution Harness & Command

### Literal Invocation Script (`command.sh`)
Per `INSTANCE_RULES.md#behavioral-criteria-and-recreation` and `DIAGNOSTIC_PROFILE.json`, with network namespace isolation, virtual address space limit (4096 MB), per-invocation timeout (60s), and environment enforcement:
```bash
#!/usr/bin/env bash
set -euo pipefail
export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"
export LEAN_PATH=""
export PATH="${TOOLCHAIN_DIR}/bin:/usr/bin:/bin"

# Capture the exact execution environment variables
env | sort > env.txt

unshare --net -- prlimit --as=4294967296 timeout --kill-after=5s 60s "${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 "${POC_FILE}" > stdout.bin 2> stderr.bin || echo $? > exit-code.txt
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

---

## 4. Deterministic Recreation Sequence

For each of the three pinned toolchain versions:
1. **Preserve clean environment:** Prepare clean isolated workspace. Place `PoC.lean`. Record `git_commit.txt`. Generate and execute `command.sh` (which writes active `env.txt`).
2. **First Run:** Execute `command.sh`. Capture `stdout.bin`, `stderr.bin`, `exit-code.txt`.
3. **Archive First Run:** Create directory `first-run/` and copy `stdout.bin`, `stderr.bin`, `exit-code.txt` into `first-run/`.
4. **Between-Run Cleanup:** Execute cleanup removing strictly items on the Between-Run Allowlist. `first-run/` is preserved and must never be deleted.
5. **Second Run (Recreation):** Re-execute `command.sh` with identical inputs and environment in directory `second-run/`. Move outputs into `second-run/`.
6. **Byte-for-Byte Comparison:**
   ```bash
   cmp -s first-run/stdout.bin second-run/stdout.bin
   cmp -s first-run/stderr.bin second-run/stderr.bin
   cmp -s first-run/exit-code.txt second-run/exit-code.txt
   ```
   Any byte mismatch immediately yields `EVIDENCE_INSUFFICIENT` for affected subclaims.
7. **Package Evidence:** Package the full P10 evidence-run artifacts into `evidence/behavioral/{version}/`.

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
- `run_metadata.json`: UTC start/end timestamps, duration, host kernel/libc version, toolchain version, and byte comparison verdict.

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
