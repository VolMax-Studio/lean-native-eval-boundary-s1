# Resource limits and execution plan — frozen limits, execution pending authorization

## 1. Denominator Source Estimates (T-B1)
DERIVED: The two captured reference-source representations total 228,341 bytes. Across all 45 resolved denominator tags, this yields approximately 10.3 MB as a rough payload estimate. Plan 90 primary source-file reads, direct object/commit resolution (completed in TAG_MANIFEST.json), one deterministic source scan and its byte-identical recreation.

## 2. Behavioral Execution Limits (T-A)
The behavioral matrix evaluates three pinned versions (Lean v4.32.2, v4.33.1, v4.34.0-rc1) across six fresh Lean process invocations (first-run and recreation for each version).

Frozen runtime and resource bounds:
- **Per-invocation timeout:** 60 seconds (enforced via `timeout --kill-after=5s 60s`). A bounded run that times out produces `EXTERNAL_EXECUTION_BLOCKER`, never successful rejection.
- **Concurrency limit:** 1 (strictly sequential execution; no parallel Lean invocations).
- **Process memory limit:** 4096 MB virtual address space enforced via `prlimit --as=4294967296`.
- **Process isolation:** Network namespace isolation enforced via `unshare --net --`.
- **Disk workspace expectation:** Expected temporary disk usage is < 200 MB per run; workspace exhaustion produces `EXTERNAL_EXECUTION_BLOCKER`.

## 3. Between-Run Cleanup Allowlist
Only the following transient build outputs in the isolated run directory may be removed between first-run and recreation:
- `.lake/`
- `build/`
- `*.olean`
- `*.ilean`
- `*.c`
- `stdout.bin` (root workspace)
- `stderr.bin` (root workspace)
- `exit-code.txt` (root workspace)

**STRICT PRESERVATION INVARIANT:** `first-run/` is an immutable evidence record and **MUST NEVER BE DELETED** during between-run cleanup. It persists until byte comparison against `second-run/` is complete. Nothing outside this enumerated allowlist may be deleted. Source inputs (`PoC.lean`), toolchain binaries, and parent workspace files are immutable.

## 4. Execution Authorization Status
Execution status: PENDING FORMAL GATE REVIEW AND OPERATOR RATIFICATION. No Lean execution is authorized by this document (`LEAN_RUNS=0`).
