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
