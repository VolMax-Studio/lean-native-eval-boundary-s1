# T-A/T-B — INSTANCE_RULES draft 2

Status: DRAFT / NOT FROZEN / NO LEAN EXECUTION AUTHORIZATION. This is a Creator-prepared review object, not a formal Gate result. Claude is the designated formal Gate; Ivan is final Ratifier. Executor: Ananke proposed in supplied correspondence, Operator confirmation pending. The current assistant is Creator and performs only a disclosed self-check of revision closure, not independent adjudication.

## Authority and scope

[L3 / Operator-adopted instance rule] Creator != Gate != Ratifier. The Operator appoints the Gate and decides conflict acceptability; the Gate supplies disclosure and does not grant itself independence. The appointment of Claude is established by the Operator's direct reply. Canonical authority is reported as “VolMax Observatory — Operating Rules (P10, v2026-08)”; the original has not been retrieved or SHA-pinned. These locally versioned rules adopt the supplied decisions without claiming to authenticate that original. See external/GOVERNANCE.md, outside the claim-bearing instance.

The scientific scope is exhausted by the explicitly registered T-A and T-B claims. Material outside those claim families is non-adjudicated and cannot contribute to any instance verdict. Scope expansion invalidates the current Gate scope and requires a new scope determination. Instance prose may not name or evaluate an excluded subject. Raw source snapshots may preserve unrelated source sentences as immutable evidence bytes; this does not import them as instance claims. Manifest entries identify those files by hash without reproducing unrelated content. External governance and supplied review correspondence are not instance-body text or scientific appendices.

UAF execution is excluded. Timing subclaims remain Exploratory and never carry a verdict. No material from any pre-freeze Lean invocation may be used to define, refine, or relax acceptance, rejection, diagnostic, or axiom-matching criteria. Any such invocation remains permanently Exploratory and is a protocol deviation; it cannot be relabeled as a preregistered run.

## Claims and permitted interpretations

CLAIM_OF_RECORD.md contains the verbatim source claims, author, URLs, source hashes and semantic-fidelity mapping. T-B1 is an investigator-defined source-structure proxy, not a source claim attributed to the publisher. Its mapping to universal behavioral “affects” is UNDERDETERMINED. Neither MISMATCH nor NO_MISMATCH under this proxy supplies Verified or Not Verified for the original behavioral universal claim.

T-A checks exact-PoC acceptance on v4.32.2 and v4.33.1 and the preregistered rejection path on v4.34.0-rc1. The observation is acceptance/diagnostics/axiom output; attribution to semantic model/runtime disagreement is DERIVED using the PoC reasoning and stated trust assumptions, not a direct runtime-value measurement. T-B2 records the three per-version outcomes from the same execution evidence. Three versions cannot establish “all stable”; control rejection also does not by itself establish patch incorporation or merge ancestry.

T-A and T-B2 may share the same frozen run artifacts. T-A consumes the acceptance + axiom + control pattern; T-B2 consumes the per-version matrix. The preregistered mapping does not increase replication counts and does not let one target modify another's rules. v4.34.0-rc1 is the candidate fixed control; rc2 is outside the primary matrix.

## Denominator and pins

Use the saved sources/lsremote_tags.txt, not a future ref query, with regex `^v4\.\d+\.\d+$` and numeric version <= 4.33.1. The current captured snapshot yields 45 members. Freeze this artifact, its SHA-256, exact command and UTC retrieval interval. A future differing snapshot requires an explicit pre-freeze amendment; never silently replace this one. rc, milestone and nightly names are excluded.

For every member retain tag name, direct ref object SHA, object type and peeled commit SHA where applicable. An absent `^{}` line alone does not constitute an independent object-type measurement. The current manifest records unresolved types honestly. Both source files must be fetched at the resolved commit, hashed, and supplied to the predicate; a ref name or shared file hash never proves commit identity.

PoC pinning uses sources/issue-14684.connector.json, scripts/extract_poc.py, and sources/PoC.lean, each separately hashed in MANIFEST.json. The JSON is the connector-returned document saved as UTF-8 with a final newline, not an assertion about HTTP wire serialization. Extraction selects the sole Lean fence in Steps to Reproduce, decodes its JSON string and encodes it as UTF-8 without code changes. Ambiguity aborts. Any adaptation is a separate, pre-gated artifact and is not part of this matrix.

## T-B1: executable syntactic proxy

The definition is scripts/source_proxy.py at its manifest hash. It is fixed before the full-denominator scan. Input paths are src/Init/Data/String/Basic.lean and src/runtime/object.cpp, from one commit. No alternate path, new pattern or API alias may be discovered and added during the scan.

The join key is `lean_string_utf8_extract`. The script recognizes an explicitly bounded extern annotation and logical declaration, normalizes whitespace and the two spellings Pos.Raw/Pos, and requires the entire registered logical-body signature. It also requires one registered C function definition with the fixed parameter signature. Multiple declarations sharing an extern key are not automatically a match: exactly one logical-body signature and one C definition must match. Missing or unrecognized shapes are PREDICATE_INAPPLICABLE.

For applicable inputs, MISMATCH means that the registered logical signature co-occurs with the C leading scalar-guard/return-input signature. NO_MISMATCH means the logical signature and C definition were recognized but the registered leading C signature is absent. These are syntactic labels only: NO_MISMATCH does not mean semantic correctness, and MISMATCH does not prove exploitability. If the files are unavailable, do not run the predicate or convert retrieval failure into INAPPLICABLE.

The signature was selected after exposure to reference source at f3b06c705e6c85f5314019d5d3baab0fec5b580c. It is not outcome-blind. No full-denominator scan has been performed in this task.

## Typed outcomes and strict precedence

“Supported proxy outcome” means both input file hashes and commit provenance exist, the frozen script completed successfully, and its literal result and invocation are retained. Semantic judgments outside that script cannot supply an outcome.

1. Any supported NO_MISMATCH: Not Verified for the universal proxy claim only, even if other members are incomplete.
2. Otherwise any PREDICATE_INAPPLICABLE or EVIDENCE_INSUFFICIENT: Not Demonstrated for the proxy claim, even if an external blocker also exists.
3. Otherwise any EXTERNAL_EXECUTION_BLOCKER: Deferred.
4. Otherwise all 45 supported MISMATCH: eligible for Verified for the proxy claim only, subject to formal Gate and ratification.

EVIDENCE_INSUFFICIENT includes hash mismatch, malformed/missing expected files in successfully retrieved source, ambiguous evidence provenance, script/parser failure, unexpected behavioral diagnostics, failed recreation, and incomplete axiom output. PREDICATE_INAPPLICABLE is solely the frozen source script's recognized classification. EXTERNAL_EXECUTION_BLOCKER is limited to logged DNS/TLS/connection failure, HTTP 401/403/429/5xx, unavailable pinned distribution asset (HTTP 404), disk exhaustion, permission denial by the host, or expiry of a pre-frozen time/resource limit. Record the actual status; do not invent HTTP codes. Other failures default to EVIDENCE_INSUFFICIENT, not Deferred. A raw-source 404 requires tree/path evidence: a proven absent prescribed source path is EVIDENCE_INSUFFICIENT, not an unavailable-distribution exception.

No post-run change of class or precedence is permitted. Structural diagnosis failure is not successful control rejection. If rc1 ACCEPTs, the expected-control subclaim is Not Verified. If rc1 rejects at rfl, parser/API checks, an unexpected line, or in a form the frozen matcher cannot recognize, that subclaim is Not Demonstrated. A listed external blocker gives Deferred only where the higher-precedence failure classes are absent. An expected rejection on a candidate vulnerable version is Not Verified for that version's exact-PoC acceptance subclaim. Missing axiom evidence on exit 0 is Not Demonstrated, not proof that the vulnerability is absent. Original broader claims retain the fidelity limits in CLAIM_OF_RECORD.md.

## Behavioral criteria and recreation

Use Linux x86_64, 64-bit with frozen userland, distribution hashes, invocation, cwd, input path, limits and environment. These remaining environment pins are not supplied by this draft. scripts/behavior_matcher.py defines the structural criteria without a Lean run. Require UTF-8 text and noncolored diagnostics. ACCEPT is the conjunction: exit=0 AND no diagnostic error (`error:` absent from both streams) AND one parsed `flt` axiom-list record in stdout containing an element outside {propext, Classical.choice, Quot.sound} with `native_decide` in its name. Also exclude sorryAx. No exact generated suffix is assumed.

EXPECTED_NATIVE_REJECTION requires nonzero exit and exactly one parsed error, at the unique native_decide source line in the unchanged PoC. Its diagnostic block must contain native_decide and the word false. Any additional or unrecognized error prevents this classification. The narrow matcher may produce Not Demonstrated on genuine but differently formatted rejection; it may not be relaxed after outputs are seen. It establishes the registered diagnostic path, not general correctness of the patched version.

Before each version's first run preserve a clean, pinned working environment. Save stdout.bin, stderr.bin and exit-code.txt at fixed paths. Rename the result directory to first-run; remove only enumerated generated artifacts in the isolated run workspace (never source inputs or user files). Recreate the same output paths in a fresh process with the identical input path, invocation and environment. Compare each corresponding output and exit-code file byte for byte; do not normalize, select, or discard outputs. Runtime timestamps are stored separately as metadata and are not compared as deterministic content. Preserve rename/cleanup/command logs and comparison results. Any byte difference gives EVIDENCE_INSUFFICIENT for affected subclaims, unless it is independently logged as a listed external blocker before obtaining an output. Recreation demonstrates repeatability of the pinned pipeline, not truth or independent replication.

## Freeze boundary

This draft may be reviewed as concrete bytes. It is not a runnable preregistration. Before freeze: confirm Executor; complete object-type/commit resolution and toolchain/userland/invocation/resource pins; finish participant disclosure; have the Operator resolve governance provenance and conflict acceptability; and obtain Claude's formal review of the identified files/commit. The exact cleanup list and harness must be frozen too. Gate result and Ivan ratification are separate records. No Lean invocation is authorized by this document.
