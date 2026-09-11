# Resource limits and execution plan — frozen limits, execution pending authorization

## 1. Denominator Source Estimates (T-B1)
DERIVED: The two captured reference-source representations total 228,341 bytes. Across all 45 resolved denominator tags, this yields approximately 10.3 MB as a rough payload estimate. Plan 90 primary source-file reads, direct object/commit resolution (completed in TAG_MANIFEST.json), one deterministic source scan and its byte-identical recreation.

## 2. Behavioral Execution Limits (T-A)
The behavioral matrix evaluates three pinned versions (Lean v4.32.2, v4.33.1, v4.34.0-rc1) across six fresh Lean process invocations (first-run and recreation for each version).

Frozen runtime and resource bounds:
- **Per-invocation timeout:** 60 seconds. A bounded run that times out produces TIMEOUT_BLOCKER, never successful rejection.
- **Concurrency limit:** 1 (strictly sequential execution; no parallel Lean invocations).
- **Process memory limit (RSS):** 4096 MB maximum resident set size per invocation.
- **Workspace disk capacity:** 2048 MB maximum per isolated run workspace.
- **Process permissions:** Standard non-root user execution, network isolation during PoC compilation/evaluation (`--unshare-net` or unprivileged sandboxing).

## 3. Cleanup Allowlist
Only the following enumerated paths in the isolated run directory may be removed between first-run and recreation:
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

Strict prohibition: Nothing outside this enumerated allowlist may be deleted. Source inputs (`PoC.lean`), toolchain binaries, and parent workspace files are immutable.

## 4. Execution Authorization Status
Execution status: PENDING FORMAL GATE REVIEW AND OPERATOR RATIFICATION. No Lean execution is authorized by this document (`LEAN_RUNS=0`).
