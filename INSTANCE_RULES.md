# T-A/T-B — instance rules, draft 1

Status: DRAFT; NOT FROZEN; no execution authorization. Claude is the Operator-designated formal Gate for T-A/T-B. Gate review and evidence pinning remain pending; freeze deferred. This status is procedural, not a scientific verdict.

## Authority and roles

This document explicitly adopts the Operator-supplied decisions for this instance. It does not establish provenance to an independently retrieved canonical P10 document. Committing this draft records its bytes; it does not constitute preregistration freeze, Gate approval, or ratification.

Creator != Gate != Ratifier. Ivan is final Ratifier and cannot also be formal Gate. The drafting assistant acts as Creator of this document, not independent Gate. The Operator has designated Claude as formal Gate for T-A/T-B. This appointment is not a completed Gate review. Record the specific reviewing session/artifact and conflict assessment before freeze. The external governance record must document relevant prior exposure and reported instrument-family involvement; no independence is inferred from model branding alone.

## Scope

Instance scope is exhausted by T-A and T-B. No other claim family, artifact, evaluation, or external subject may appear in the instance body, motivation, evidence package, or appendices. Scope expansion invalidates the current Gate and requires a new scope determination.

T-A concerns semantic model/runtime disagreement under native evaluation and exact-PoC acceptance/rejection on the pinned behavioral matrix. UAF reproduction is excluded. Timing subclaims are Exploratory only and cannot carry a verdict.

T-B1 concerns the source-level universal claim over the complete frozen stable-tag denominator. T-B2 is a behavioral matrix of v4.32.2, v4.33.1, and v4.34.0-rc1; it cannot establish behavioral coverage of all stable versions. v4.34.0-rc1 is the candidate fixed control, whose expected behavior remains a hypothesis until tested.

## Pins and denominator

Define stable tags mechanically as names matching `^v4\.\d+\.\d+$`, restricted by numeric version comparison to <= 4.33.1. Exclude rc, milestone, and nightly versions. The supplied count of 45 is reported, not independently established in this draft. Retrieve and hash the actual tag snapshot before freeze; do not silently substitute a later snapshot for the supplied one.

For every tag record its name, direct ref object SHA, object type, and resolved commit SHA. For annotated tags retain both the tag-object SHA and peeled commit SHA; for lightweight tags record that no separate tag object exists. Pin both logical and native source evidence at the resolved commit.

The PoC chain requires the raw issue snapshot hash, capture timestamp and available updated_at, extraction-script hash, and extracted-PoC byte hash. Do not retype or silently edit the PoC. Any adapted PoC requires separate hashes, a semantic-equivalence rationale, and Gate review before execution.

## T-B1 decision table

The relational source predicate and its historical API mapping must be specified before execution. Per-member semantic outcomes are MISMATCH, NO_MISMATCH, or PREDICATE_INAPPLICABLE. Retrieval and evidence failures are recorded separately, never converted into semantic outcomes.

| Coverage and evidence | Universal source-claim outcome |
| --- | --- |
| Every member applicable and supported as MISMATCH | Eligible for Verified, subject to Gate and ratification |
| At least one supported NO_MISMATCH | Not Verified; counterexample takes precedence over missing coverage |
| No NO_MISMATCH, but any INAPPLICABLE or missing evidence | Not Demonstrated |
| No NO_MISMATCH and an applicable purely external/procedural blocker preclassified before freeze | Deferred |

Exact procedural blocker classes remain to be enumerated before freeze. No post-run reclassification to obtain a preferable outcome is allowed.

## Behavioral controls

Use Linux x86_64, 64-bit. Pin userland, toolchain distributions, hashes, invocation, working directory, input path, resource limits, and environment before freeze. Local host observation was Linux 7.0.0-31-generic x86_64 with LONG_BIT=64; it is not a complete environment pin.

Acceptance requires exit code 0 and the exact preregistered axiom-output check for the target theorem, including the defined native-decision axiom evidence. Absence of `error:` is a supplementary diagnostic check, not the primary semantic criterion.

The fixed-control rejection must occur at the specified proof step with a preregistered diagnostic class consistent with failure of the native decision. Parser/API/install failures, timeouts, and crashes do not count as successful negative controls. Exact diagnostic and axiom matching rules remain pending inspection of the pinned PoC, before the first verdict-bearing run.

Use two fresh processes per version with fixed input path and separately saved literal stdout/stderr and exit codes. Compare corresponding outputs byte for byte without normalization. Recreation establishes repeatability of the pinned pipeline, not independent truth or independent replication. Freeze the consequence of any disagreement before execution; do not select a favorable repeat.

## Exposure and failures

Describe the design as “prospectively frozen after documented source/outcome exposure” only after actual freeze. Current status is draft after documented exposure. Source exposure includes the previously reported native-side inspections at v4.32.2, v4.33.1, v4.34.0-rc1 and logical-side inspection at f3b06c7. Resolve the full commit and evidence pins in the exposure ledger. Previously measured timings remain Exploratory. Any run before freeze is permanently Exploratory.

Keep FAILURES append-only. Correction before verdict-bearing execution preserves eligibility in principle; it is not itself Gate approval or a verdict.

## Conditions before freeze

- Claude's recorded Gate review and conflict assessment; Ivan retained as Ratifier.
- Complete source, extraction, PoC, tag, and toolchain manifest with full hashes.
- Operational relational predicate, historical mapping, diagnostic classes, output checks, repeatability-failure consequence, and procedural Deferred classes.
- Resource estimate for full-denominator source review and the three-version behavioral matrix.
- Completed exposure ledger and external governance provenance record.
- Gate-reviewed preregistration linked to the final rules commit; recorded freeze timestamp preceding execution.

No Lean invocation is authorized by this draft.
