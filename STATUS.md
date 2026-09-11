---
phase: pre-gate
execution_state: HALT
verdict: null
last_formal_gate_result: BLOCKED
last_formal_gate_fix: B-1..B-4, F-1..F-9
prereg_frozen: false
operator: Operator
ratifier: final Ratifier
gate: formal Gate (external)
executor: confirmed Executor (authority effective upon freeze)
creator: Creator
role_assignments: external/GOVERNANCE.md
---

This commit is a candidate freeze package submitted for formal Gate review, not an authorized execution run or ratified freeze. Scope is T-A/T-B only; T-B1 is descriptive. Execution state remains HALT (`LEAN_RUNS=0`). All 45 denominator tags are resolved to commit objects; the three toolchains, execution environment, execution harness, resource bounds and cleanup allowlist are pinned in EXECUTION_SPEC.md and RESOURCE_PLAN.md. Participant roles, Executor appointment, and authority adoption are recorded in external/GOVERNANCE.md.

Gate review history:
- Formal review over commit `d9e97a9`: `SURVIVES-REVIEW`.
- Administrative branch merge PR #3 into `main` (`f849538`): not a freeze ratification (`FAILURES.md#f-015`).
- Formal Gate review over candidate `c1398ed` (PR #3 head): `BLOCKED` (citing B-1, B-2, B-3, B-4 and F-1 through F-9).
- Mandatory separate review of this complete candidate freeze commit is defined in [INSTANCE_RULES.md — Freeze boundary](INSTANCE_RULES.md#freeze-boundary).

Exhaustive scope of `LEAN_RUNS=0`:
Zero Lean binaries are executed against test artifacts prior to formal Gate and ratification (`LEAN_RUNS=0` / `TARGET_LEAN_RUNS=0`). Permitted non-Lean commands during pre-freeze preparation are strictly limited to:
1. Shell syntax validation (`bash -n`).
2. Harness self-test using mock/stub executables (`/bin/true`, non-Lean shell stubs).
3. Metadata inspection (`git`, `ls-remote`, `cat-file`, `stat`, `sha256sum`, `platform.libc_ver()`).
4. Read-only HTTP metadata / API queries (release asset headers, tree metadata).
5. Manifest checksum calculation and file verification.

All subsequent changes, including freeze, require a PR. The Operator performs the merge and the final Ratifier records ratification; this task does not merge its own candidate. G-1 decision: public tree without raw data; no history rewrite.
