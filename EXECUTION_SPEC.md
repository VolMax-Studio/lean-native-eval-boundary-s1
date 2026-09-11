# Execution Specification — Frozen Toolchains, Environment, Harness, and Limits

Status: PRE-FREEZE CANDIDATE SPECIFICATION  
Execution Authorization: PENDING FORMAL GATE REVIEW AND OPERATOR RATIFICATION  
Pre-freeze Prohibition: `LEAN_RUNS=0` (no execution on test artifact prior to ratified freeze)

---

## 1. Pinned Behavioral Toolchains (T-A)

The behavioral evaluation tests three specific Lean 4 release artifacts for Linux x86_64:

| Version | Asset Filename | Byte Size | SHA-256 Digest | Official Distribution URL |
| :--- | :--- | :--- | :--- | :--- |
| **Lean v4.32.2** | `lean-4.32.2-linux.tar.zst` | 563,991,635 | `5f2069e6f5db73780f374ccb49ce8ea649aa20a0cebf0116816744c999ce72aa` | `https://github.com/leanprover/lean4/releases/download/v4.32.2/lean-4.32.2-linux.tar.zst` |
| **Lean v4.33.1** | `lean-4.33.1-linux.tar.zst` | 570,405,234 | `2f8c10644606d7cb99c51267e2e0acd2bf90eac9619efbfa37330cfd9eb78bbf` | `https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst` |
| **Lean v4.34.0-rc1** | `lean-4.34.0-rc1-linux.tar.zst` | 575,410,932 | `41dc6a6ec143ece8ed4ba4c4c6978c91f21ad5cbe3c4e7728ad31b869961dc17` | `https://github.com/leanprover/lean4/releases/download/v4.34.0-rc1/lean-4.34.0-rc1-linux.tar.zst` |

Retrieval and verification provenance:
- Assets retrieved directly from official GitHub releases of repository `leanprover/lean4`.
- Stream-verified SHA-256 digests and exact content lengths recorded on 2026-09-11.
- Unpacking mechanism: `tar --zstd -xf <archive> -C <toolchain_dir>`.
- Lean executable path: `<toolchain_dir>/bin/lean`.

---

## 2. Target Execution Environment

- **Operating System:** Linux x86_64 (reference platform: Ubuntu 24.04.1 LTS / Linux kernel 7.0.0-31-generic or compatible standard Linux x86_64).
- **Architecture:** x86_64 (64-bit).
- **C Library (libc):** GNU C Library (glibc) version >= 2.38 (reference: `glibc 2.39`).
- **C Compiler:** GCC >= 13.0 (reference: `gcc 13.3.0` x86_64-linux-gnu).
- **Shell:** `/bin/bash` with strict settings (`set -euo pipefail`).
- **Required Environment Variables:**
  ```bash
  export LANG="C.UTF-8"
  export LC_ALL="C.UTF-8"
  export LEAN_PATH=""
  export PATH="<toolchain_dir>/bin:${PATH}"
  ```
- **Execution isolation:** Each run executes in a dedicated, isolated temporary workspace directory with network isolation (e.g. `unshare --net` or isolated runner environment) to guarantee outcome blindness and eliminate network side-effects.

---

## 3. Exact Execution Harness & Command

### Literal Invocation Command
Per `INSTANCE_RULES.md#behavioral-criteria-and-recreation` and `DIAGNOSTIC_PROFILE.json`:
```bash
"${LEAN_BIN}" -D printMessageEndPos=false -D maxErrors=0 PoC.lean > stdout.bin 2> stderr.bin || echo $? > exit-code.txt
```
If the command exits with code 0:
```bash
echo 0 > exit-code.txt
```

### Input & Output Paths
- Input file: `PoC.lean` (UTF-8 encoded; extracted per `scripts/extract_poc.py`).
- Output binary stream 1: `stdout.bin` (raw binary stream; literal UTF-8 bytes).
- Output binary stream 2: `stderr.bin` (raw binary stream; literal UTF-8 bytes).
- Exit code: `exit-code.txt` (ASCII decimal integer followed by newline).

---

## 4. Deterministic Recreation Sequence

For each of the three pinned toolchain versions:
1. **Preserve clean environment:** Prepare clean isolated workspace. Place `PoC.lean`.
2. **First Run:** Execute the literal invocation command. Capture `stdout.bin`, `stderr.bin`, `exit-code.txt`.
3. **Archive First Run:** Move captured outputs and intermediate artifacts to directory `first-run/`.
4. **Cleanup:** Execute the frozen cleanup sequence removing only items on the cleanup allowlist.
5. **Second Run (Recreation):** Re-execute the identical invocation command with the identical input and environment. Capture fresh `stdout.bin`, `stderr.bin`, `exit-code.txt` to directory `second-run/`.
6. **Byte-for-Byte Comparison:**
   ```bash
   cmp -s first-run/stdout.bin second-run/stdout.bin
   cmp -s first-run/stderr.bin second-run/stderr.bin
   cmp -s first-run/exit-code.txt second-run/exit-code.txt
   ```
   Any byte mismatch immediately yields `EVIDENCE_INSUFFICIENT` for affected claims. Timestamps are retained solely as separate metadata and are not compared as deterministic stream content.

---

## 5. Cleanup Allowlist

Only the following enumerated relative paths within the isolated execution workspace may be deleted during workspace resets or between first-run and recreation:
- `.lake/`
- `build/`
- `*.olean`
- `*.ilean`
- `*.c`
- `first-run/`
- `second-run/`
- `stdout.bin`
- `stderr.bin`
- `exit-code.txt`

**Strict Prohibition:** Absolutely nothing outside this enumerated allowlist may be deleted. Source inputs, toolchain files, scripts, manifests, and parent files are immutable.

---

## 6. Resource Limits

- **Per-invocation timeout:** 60 seconds (enforced via `timeout --kill-after=5 60s`).
- **Concurrency:** Strictly sequential (concurrency = 1).
- **Resident Set Size (RSS) memory cap:** 4096 MB.
- **Workspace disk capacity:** 2048 MB.
