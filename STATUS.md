---
phase: pre-gate
execution_state: HALT
verdict: null
last_formal_gate_result: FIXES-PENDING
last_formal_gate_fix: F-N
prereg_frozen: false
---

This commit is an F-N rule clarification submitted for review, not a scientific result or preregistration freeze. Scope is T-A/T-B only; T-B1 is descriptive. The last Gate reviewed ZIP SHA-256 8ed9d0e685f343a8d03bfc522958b39a3787132e2ae9929aa15465c1cbc6d051. Only the named Gate can issue the next formal result over the new commit.

The last formal Gate applies to ae4ae63d630bfc1aaf47381c286fcc5243d3ee1d and closes N-1 through N-4; it does not review future execution pins. The mandatory separate review of the complete candidate freeze commit is defined in [INSTANCE_RULES.md — Freeze boundary](INSTANCE_RULES.md#freeze-boundary). No Lean invocation is authorized. Executor confirmation, role disclosures, authority adoption/pin, direct tag object/commit resolution, toolchain/userland/harness/cleanup/resource pins remain outstanding.

All subsequent changes, including freeze, require a PR. Ivan performs the merge/ratification; this task does not merge its own repair. G-1 decision: prepare public tree without raw data; no history rewrite. This PR externalizes raw evidence, but main and historical commits are unchanged until the Operator acts.
