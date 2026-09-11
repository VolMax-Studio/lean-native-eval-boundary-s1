# Claim of record and semantic mapping — draft 2

Evidence status: OBSERVED publication content; underlying scientific assertions remain reported, not independently reproduced.

## R-A: semantic discrepancy report

Author attribution: R-A publisher identity in external/GOVERNANCE.md. Repository: leanprover/lean4. Source: https://github.com/leanprover/lean4/issues/14684 . Issue updated_at: 2026-08-10T07:40:26Z (source update time, not local retrieval time). Full referenced commit: f3b06c705e6c85f5314019d5d3baab0fec5b580c.

Verbatim first Description sentence, including its original Markdown links:

> `String.Pos.Raw.extract` gives different results in its [`Lean definition`](https://github.com/leanprover/lean4/blob/f3b06c705e6c85f5314019d5d3baab0fec5b580c/src/Init/Data/String/Basic.lean#L3012-L3022) and [`C++ runtime`](https://github.com/leanprover/lean4/blob/f3b06c705e6c85f5314019d5d3baab0fec5b580c/src/runtime/object.cpp#L2373-L2394).

Source: sources/issue-14684.connector.json, SHA-256 `2b66fc0b1f9123e93e22cbf9772604ed562124c3ac44de224edfa9e582ea836f`. The saved JSON representation and extraction are defined in INSTANCE_RULES. Local issue-source content is directly returned by the connector; reproduction remains unperformed.

## R-B: version scope and incorporation report

Author/publisher attribution: R-B identities in external/GOVERNANCE.md. Published date reported on page: 2026-09-09. Source: https://blog.trailofbits.com/2026/09/09/a-proof-of-fermats-last-theorem-that-fits-the-margin/ .

> The issue affects all stable versions of Lean up to 4.33.1, and the patch is incorporated in v4.34.0-rc1.

Source: sources/blog.html, SHA-256 `f395f4710e237d2a12b44a253e36517838c71cdbdb4368a9dae1d3c8f7b1a079`; raw retrieval command and UTC interval in sources/retrieval.json. Split this compound sentence into R-B-affects (all stable versions through 4.33.1) and R-B-patch (incorporation into rc1); do not equate them.

## Mapping fixed before execution

Fidelity vocabulary: EQUIVALENT / WEAKER / STRONGER / DIFFERENT / UNDERDETERMINED. No mapping here is promoted to EQUIVALENT merely because a control passes.

| Claim as stated or registered | Operational test | Semantic fidelity | Permitted verdict wording |
| --- | --- | --- | --- |
| R-A: different logical and native results | T-A exact-PoC acceptance, required axiom output, expected control rejection | WEAKER: registered acceptance path supports a derived explanation; no direct value trace or universal trust claim | Exact PoC reproduced / not demonstrated on specified toolchain and platform; semantic attribution is DERIVED |
| R-B-affects: universal version coverage | T-B1 full-denominator syntactic relation | UNDERDETERMINED relative to behavioral affects; investigator-defined proxy | Descriptive member outcomes and counts only; no scientific verdict |
| Investigator-defined T-B1 measurement question: which denominator members have the registered signature pair | Frozen source_proxy.py on both pinned files for every member | EQUIVALENT to the explicitly registered syntactic measurement question only | Descriptive signature-pair presence/absence/inapplicability and coverage; no Verified/Not Verified |
| R-B-affects, narrowed version sample | T-B2 per-version behavior at v4.32.2 and v4.33.1; rc1 control | WEAKER coverage; platform- and PoC-specific | Exact-PoC acceptance/rejection matrix for those versions; never all stable versions |
| R-B-patch: incorporation in rc1 | T-B2 expected rejection on rc1 | UNDERDETERMINED for incorporation; behavior alone does not identify a patch or ancestry | Expected diagnostic path observed / not demonstrated; patch incorporation remains unestablished |

A failed structural matcher is not a scientific counterexample to the broader source claim. A proxy NO_MISMATCH records absence of the registered source signature only. By Operator decision, T-B1 reports descriptively and assigns no scientific verdict, even to the investigator-defined proxy proposition. The design has no verdict-bearing test of patch ancestry or universal behavioral coverage. Gate and Ratifier must preserve this scope in final wording.
