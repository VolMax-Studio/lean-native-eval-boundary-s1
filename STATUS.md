---
phase: closed
execution_state: COMPLETED
verdict: Deferred
verdict_rule_basis: "INSTANCE_RULES.md:65 -> :67 (resource limit exhaustion as EXTERNAL_EXECUTION_BLOCKER leads to Deferred)"
t_a: Deferred
t_a_basis: "INSTANCE_RULES.md:65 (resource limit exhaustion classified as EXTERNAL_EXECUTION_BLOCKER)"
t_b1: "descriptive — 13 MISMATCH / 32 PREDICATE_INAPPLICABLE / 0 NO_MISMATCH"
universal_source_claim: Not Demonstrated
prereg_frozen: true
frozen_commit: f11a44a31cf014e73212b73234645ee489bd53e4
frozen_tree: 4df5ed0907a9fd505be9f43ac9c7d6c8fd307aa3
frozen_tag: prereg-frozen-s1-f11a44a
operator: Operator
ratifier: final Ratifier
gate: formal Gate (external)
executor: confirmed Executor (authority effective upon freeze)
creator: Creator
role_assignments: external/GOVERNANCE.md
last_formal_gate_result: SURVIVES-REVIEW
---

This commit is a candidate freeze package submitted for formal Gate review, not an authorized execution run or ratified freeze. Scope is T-A/T-B only; T-B1 is descriptive. Execution state remains HALT (`LEAN_RUNS=0`). All 45 denominator tags are resolved to commit objects; the three toolchains, execution environment, execution harness, resource bounds and cleanup allowlist are pinned in EXECUTION_SPEC.md and RESOURCE_PLAN.md. Participant roles, Executor appointment, and authority adoption are recorded in external/GOVERNANCE.md.

Gate review history:
- Formal review over commit `d9e97a9`: `SURVIVES-REVIEW`.
- Administrative branch merge PR #3 into `main` (`f849538`): not a freeze ratification (`FAILURES.md#f-015`, `f-017`).
- Formal Gate review over candidate `c1398ed`: `BLOCKED` (citing B-1..B-4, F-1..F-9).
- Formal Gate review over candidate `7b28531`: `BLOCKED` (citing B-5, B-6, B-7 and F-10..F-15).
- Formal Gate review over candidate `f66ab40`: `BLOCKED` (citing B-8, B-9, B-10 and F-16, F-17; B-7 confirmed closed by Operator verbatim declaration).
- Formal Gate review over candidate `c8b45d9`: `BLOCKED` (citing B-11, B-12 and F-18..F-20).
- Formal Gate review over candidate `ea0e1a5`: `SURVIVES-REVIEW` (citing non-blocking findings F-21..F-23).
- Formal Gate review over candidate `0822d3c`: `BLOCKED` (citing B-13, F-24).
- Formal Gate review over candidate `f11a44a`: `SURVIVES-REVIEW` (all blockers B-1..B-13 closed; non-blocking F-25 accepted).
- Operator preregistration freeze ratification over commit `f11a44a` (Tree `4df5ed09`): ratified 2026-09-12; tag `prereg-frozen-s1-f11a44a`.
- Formal Gate review over executed evidence package (`cabaf776...`, 1,529,682 B, 318 entries): `SURVIVES-REVIEW`. Final adjudication: T-A `Deferred`, T-B1 descriptive 13/32/0 (`Not Demonstrated`).
- Mandatory separate review of this complete candidate freeze commit is defined in [INSTANCE_RULES.md — Freeze boundary](INSTANCE_RULES.md#freeze-boundary).

Exhaustive scope of `LEAN_RUNS=0`:
Zero Lean binaries are executed against test artifacts prior to formal Gate and ratification (`LEAN_RUNS=0` / `TARGET_LEAN_RUNS=0`). Permitted non-Lean operations during pre-freeze preparation are defined by the explicit Operator allowlist in [INSTANCE_RULES.md](INSTANCE_RULES.md#authority-and-scope). All new denominator source reads or path-existence measurements prior to freeze are prohibited.

All subsequent changes, including freeze, require a PR. The Operator performs the merge and the final Ratifier records ratification; this task does not merge its own candidate. G-1 decision: public tree without raw data; no history rewrite.
