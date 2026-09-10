# T-A/T-B — append-only failure record

Entries record corrections acknowledged in Operator-supplied correspondence. Underlying historical repository inspections have not been independently replayed here. No verdict-bearing Lean execution has occurred in this task.

## F-001 — relational mismatch overstated from one-sided inspection

The supplied correspondence attributed source-level mismatch to three tags although both sides had not been inspected for every tag. It also treated a shared file hash and reported version string as if they established commit identity.

Correction: retract those inferences. Require both logical and native evidence at full resolved commit SHAs for each member. File-byte identity alone does not establish commit identity.

Can this instance still carry a verdict? Yes, conditionally: the correction precedes verdict-bearing execution, and the missing relational evidence must be established under the frozen protocol. This eligibility statement does not supply that evidence or replace Gate review.

## F-002 — reproducibility asserted without local execution

The supplied discussion described the finding as reproducible without a recorded local PoC run. A published report is evidence of what its author reported, not independent local reproduction.

Correction: retain the claim as reported until the exact pinned PoC has been executed and its literal outputs, exit codes, environment, and repeatability results preserved.

Can this instance still carry a verdict? Yes, conditionally: the correction precedes verdict-bearing execution. No reproduction verdict is assigned by this entry.

## F-003 — acceptance conjunction weakened in draft 1

OBSERVED in local draft-1 commit 5e48b587c24e685db25524b0102114187c03e69b: absence of diagnostic error was recast as a supplementary check although the preceding decision required it conjunctively. Draft 2 restores exit=0 AND no diagnostic error AND required axiom evidence. The structural matcher is recorded before any Lean invocation.

Can this instance still carry a verdict? Yes, conditionally, after proper freeze and Gate review. This correction is not itself acceptance of the matcher by the Gate.

## F-004 — proxy outcome conflated with source claim

OBSERVED in local draft 1: the universal source predicate lacked a claim-of-record mapping and semantic-fidelity boundary. Draft 2 identifies the source-structure proposition as investigator-defined, maps it as UNDERDETERMINED relative to behavioral “affects,” and limits both Verified and Not Verified to the proxy. No source-proxy counterexample is promoted to a behavioral counterexample without an independently justified equivalent predicate.

Can this instance still carry a verdict? Yes, conditionally, only within the registered mapping and after freeze. The original universal behavioral claim is not established by this design.
