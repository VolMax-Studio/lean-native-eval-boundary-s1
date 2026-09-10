# Creator repair self-check — response to formal Gate N-1/N-2

NOT FROZEN. The last formal Gate result is BLOCKED for the reviewed validation-supplement ZIP. This file records implementation repairs and evidence for re-review; it does not change Claude's formal verdict.

Reviewed object: lean-ta-tb-draft2-validation-supplement.zip, SHA-256 d52989959cbbfe28f7e84efe378f53659b6a10d21002fc4be0672ec60c672b9a. The supplied formal review is preserved in external/claude-gate-validation-supplement.txt. The repaired archive is a new object requiring its own review.

| Finding | Repair/evidence | Status of this self-check |
| --- | --- | --- |
| N-1 | Formatter and CLI source from all three pinned commits; text option profile; parser for named labels/end ranges; both-stream error guard; grammar fixtures | Implemented; formal re-review pending |
| N-2 | 49 explicit fixtures and 24 declared mutants, with separate guards, literal logs, mutation witnesses and replay commands | Implemented; formal re-review pending |
| F-A | Decoded full issue body hashes to b089…; PoC stays ed8e…; FAILURES F-008 | Hash-label discrepancy resolved locally and acknowledged by Gate |
| F-B | Operator explicitly confirms Claude's formal draft-1 Gate over pasted text; active provenance corrected | Recorded; no scope transfer to commit |
| F-C | One formal vocabulary: BLOCKED / FIXES-PENDING / SURVIVES-REVIEW | Active governance corrected |
| F-D | v4.32.2 identified as reference/development-exposed member and Gate-reported positive control | Ledger and rules updated |
| F-E | Operator selects descriptive-only T-B1; per-member outcomes and completeness replace scientific proxy verdicts | Rules and mapping updated |
| F-F | Internal-review-only distribution designation, source-notice observations, no public release authorization | external/DISTRIBUTION.md added |
| F-G | Gate's new reported exposure and Creator's new diagnostic-source/test exposure distinguished | Ledger appended |
| F-H | Unused end regex lookup removed from source_proxy.py | Removed before freeze; new hash required |

The original nine-fixture validation evidence remains in the preserved previous commit/archive. Current validation artifacts record new executions of the repaired code and expanded suite, not historical backfill. Tests use synthetic strings only. Each mutant must produce a wrong classification against an explicit fixture to count as killed; exceptions are not kills. A finite suite is not proof that all possible defects have been found.

Draft-1 closure is retained with corrected attribution: B-1/B-2/B-6 were closed by Claude's supplied formal review; B-3 was closed at design level. B-4/B-5 require the present N-1 implementation repair to survive formal re-review. T-B1 now has no scientific verdict by Operator decision, so its descriptive completeness reporting supersedes the former proxy-verdict table without promoting any source claim.

Remaining before freeze: Claude's review of repaired bytes; Executor confirmation and participant disclosures; canonical authority pin or explicit local-rule adoption; direct object-type/commit resolution; toolchain/userland/harness/cleanup/resource pins. The PoC-hash discrepancy is no longer listed as unresolved. No Lean invocation or full-denominator source-proxy scan has been performed in this task. No remote publication or message has been sent.
