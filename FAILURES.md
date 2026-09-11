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

## F-005 — synthetic validation evidence omitted from draft-2 archive

OBSERVED: commit f254bdb8623704500fb7a23f8631784446b91e21 and its original review archive asserted nine passing synthetic checks, but did not contain a replayable harness, explicit fixtures, or literal validation outputs. The inline tool execution existed in the task history; that did not make it independently replayable from the delivered package.

Correction: preserve the old archive and qualify its historical assertion as a Creator report. Add nine literal fixtures, a runner, a command, and literal logs/provenance from a new execution in a separate evidence-supplement commit and archive. Hash all added evidence in MANIFEST.json. Do not backdate the new run or change the scientific predicates to fit outputs.

Can this instance still carry a verdict? Yes, conditionally after the remaining freeze and Gate requirements. These tests are limited Creator self-check evidence, not scientific outcomes or a formal Gate result.

## F-006 — named diagnostic error could pass acceptance (N-1)

OBSERVED in the reviewed implementation: the literal error-colon detector and positioned-error regex omitted named labels and end-position ranges. This allowed a named diagnostic alongside valid axiom output and exit 0 to be classified ACCEPT. The formal Gate supplied falsifying synthetic cases; the defect does not depend on a Lean reproduction.

Correction: derive the grammar from formatter/CLI source at all three pinned matrix commits, recognize plain/named error labels and optional end ranges, and block acceptance on unparsed error markers in either stream. Explicit text-profile options and format fixtures are recorded before any Lean run. Can this instance still carry a verdict? Yes, conditionally after re-review, freeze and remaining requirements; the prior matcher is not authorized for execution.

## F-007 — nine positive/negative examples did not falsify independent guards (N-2)

The formal Gate reported seven survivors among nine declared guard-removal mutants, despite nine passing fixtures. The original nine cases were literal and replayable but insufficient for the claimed assurance role. Correction: add independent counterfixtures for the missing guards and package declared single-change mutations, exact mutation definitions, witness outcomes and literal logs. Exceptions never count as kills. Passing a finite declared mutant set is not exhaustive correctness or formal Gate acceptance. Can this instance still carry a verdict? Yes, conditionally after the revised instrument is gated before execution.

## F-008 — Gate mislabeled full issue-body hash as PoC hash (F-A)

Claude acknowledged that b089432223ed0dc23b52200ab080d429381d2766f61f33383386fceeecceb0f0 was the full body hash, not the fenced PoC hash. OBSERVED by the Creator: the saved JSON body's UTF-8 encoding yields exactly that value. The PoC extraction hash remains ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b. The old value is retained only as a body identifier, never a PoC pin. Can this instance still carry a verdict? Yes, conditionally; this correction precedes scientific execution and does not require changing PoC bytes.

## F-009 — formal text review misattributed and reclassified (F-B)

supplied-review-1.txt attributed Claude's draft-1 review to Astra and used that attribution to call it pre-gate. The package's provenance record carried that reclassification. The Operator now explicitly confirms Claude's authorship and formal Gate status over the pasted text. Correct the active record while retaining both supplied reviews unchanged. This does not extend the historical review to the local commit or unseen FAILURES file. Can this instance still carry a verdict? Yes, conditionally after review of the actual execution package; historical review scopes remain bounded.

## F-010 — untested outcome-relevant transformations (N-3)

Claude reported that removing axiom-record diagnostic truncation (U1), Pos.Raw/Pos normalization (U6), or C comment stripping (U8) survived the prior declared suite. U6/U8 also changed the output on the already exposed reference. Comment stripping existed in code but had not been explicitly registered in INSTANCE_RULES.

Correction: add one explicit fixture for each U1/U6/U8, declare their mutants, register the exact comment-removal transformation and preserve a code-derived inventory and finite stopping criterion. Add boundary/whitespace transformation mutants for the inventory using existing fixtures. Do not relabel the reference as outcome-blind or count exceptions as mutation kills. Can this instance still carry a verdict? Yes, conditionally after Gate review and freeze; T-B1 remains descriptive and no Lean execution has occurred.

## F-011 — recreated validity not explicit in contrary-result precedence (F-J)

The earlier phrase “valid direct contrary result” did not explicitly resolve rc1 ACCEPT followed by byte-different recreation. Correction: validity requires successful identical recreation, verified evidence pins/provenance, and absence of applicable failure classes. A differing recreation leads to EVIDENCE_INSUFFICIENT / Not Demonstrated, not a contrary-result Not Verified. This is defined before execution. Can this instance still carry a verdict? Yes, conditionally after the remaining Gate/freeze requirements.

## F-012 — recognition alternatives and axiom stream lacked counterfixtures (N-4)

Claude's formal review of c8f10c960a87c12eb645366e2e64c9c98893c17d found survivors for removing no-expose, namespace-less name, Pos-prefixed name and plain-Pos parameter alternatives, and for accepting axiom evidence from stderr. The instrument was correct on supplied probes, but its suite did not establish those registered alternatives and stream restriction.

Correction: add five explicit fixtures and five corresponding declared mutants, plus inventory rows per alternative. Declare label-spacing A5a/A5b equivalent only within the registered formatter grammar. Predicate scripts remain unchanged. Can this instance still carry a verdict? Yes, conditionally after Gate review and remaining freeze requirements; T-B1 remains descriptive and no Lean invocation occurred.

## F-013 — integrity output reused scientific verdict vocabulary (F-L)

README's manifest-check command printed Verified for byte integrity. Replace that output label with hash-match, keeping integrity checks distinct from scientific verdicts. No scientific result changes.

## F-014 — review scope could be extended to future execution pins (F-N)

Claude identified that the prior remaining-work wording allowed a repair-package Gate to be read as covering toolchain hashes, harness, cleanup list, resource limits and object resolutions created later. No such review had occurred. Correction: explicitly require the complete candidate freeze commit to receive its own exact-SHA formal Gate and separate Operator ratification before freeze is effective or execution is authorized; earlier reviews do not cover later artifacts. Subsequent changes require renewed formal review. STATUS and PRE_GATE_CLOSURE point to this single operative rule. Can this instance still carry a verdict? Yes, conditionally after the required future review and remaining prerequisites; no trust or execution authorization is transferred by this repair.

## F-015 — PR #3 merged before Gate verdict without freeze ratification

PR #3 (head `c1398ede5d044d8b457faa50a429a34c6790ef57`) was merged into `main` by the Operator as merge commit `f8495385750d9931d86d63d64fe282713f36fe28` prior to the conclusion of the formal Gate review. Per instance rules and explicit Operator confirmation, this merge was an administrative repository branch synchronization and DOES NOT constitute ratification of the preregistration freeze. The repository preregistration status remains unratified (`prereg_frozen: false`), execution state remains HALT, and `LEAN_RUNS=0`. All repairs proceed via a new candidate pull request against current `main`.

## F-016 — Lean v4.33.1 archive hash pinned from truncated download stream (B-2)

The toolchain distribution archive hash for Lean v4.33.1 (`lean-4.33.1-linux.tar.zst`, 570,405,234 bytes) was recorded in `EXECUTION_SPEC.md` and `harness/pin_provenance.json` as `2f8c10644606d7cb99c51267e2e0acd2bf90eac9619efbfa37330cfd9eb78bbf`. This hash resulted from an interrupted streaming pipeline (`curl -sL ... | sha256sum`) without `pipefail`. The verified full-archive SHA-256 digest from the official release asset is `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235`. Correction: update `EXECUTION_SPEC.md` and `harness/pin_provenance.json` to the verified full asset digest. Can this instance still carry a verdict? Yes, this correction precedes any execution run.

## F-017 — merge commit SHA correction and append-only discipline restoration (F-11)

In entry F-015 at commit 7b28531, the PR #3 merge commit was erroneously recorded as `f8495385750d9931d86d63d64fe282713f36fe28`. The actual canonical merge commit on `main` is `f8495385e077990261bb8e478d9168921ee90613`. In an interim commit (`3fb68b9`), F-015 was directly modified in violation of append-only discipline.

Correction: Restore F-015 verbatim to its original form from commit 7b28531 and append this explicit correction. Furthermore, record the verbatim declaration issued by the Operator on 2026-09-11:

> “Kao Operator, 2026-09-11 potvrđujem da merge PR #3 nije bio ratifikacija niti freeze; `prereg_frozen` ostaje false. Potvrđujem Ananke kao Executora isključivo nakon ratifikovanog freeze-a i potvrđujem lokalni versioned `INSTANCE_RULES.md` kao operativni authority ove instance.
>
> Za behavioral execution ne zahtevam kernel network-namespace izolaciju. Behavioral harness ne sme obavljati mrežne operacije tokom behavioral run-a. Toolchain acquisition je zasebna pinned pre-execution faza.
>
> Pre freeze-a dozvoljavam isključivo:
>
> 1. shell syntax validation;
> 2. stub/mock harness validation bez Lean-a;
> 3. replay već registrovanih synthetic fixtures i declared mutation suite-a (`tests/command.sh`, `tests/mutation-command.sh`) isključivo kao instrument-validation evidence;
> 4. repository custody i Git-object metadata potrebne za proveru kandidata, bez novih denominator path/source merenja;
> 5. toolchain release metadata, download, byte-count, SHA-256 verification, extraction i hashovanje pripadajućeg `bin/lean`, bez izvršavanja Lean binarnog fajla;
> 6. host-environment metadata potrebne za pinned execution environment;
> 7. manifest i review-archive generation/verification.
>
> Pre freeze-a zabranjujem nova denominator source ili path-existence merenja, pokretanje Lean-a nad bilo kojim test artefaktom, kao i menjanje naučnih kriterijuma, fixture-a ili mutant suite-a na osnovu novih scientific outcomes. Existing synthetic/mutation replay ne predstavlja scientific execution.”

Can this instance still carry a verdict? Yes; the correction precedes any execution run and freeze identity remains bound to the exact candidate commit reviewed by the formal Gate.

## F-018 — pattern of unmeasured / prefix-filled hashes in reports and manifest (B-10, F-17)

During the candidate review rounds, a recurring defect pattern occurred where SHA-256 hashes in reports and manifests were reconstructed from prefixes or recorded without fresh direct execution output measurement:
1. In candidate `c6b4041` report: private evidence archive hash was reported with a typographical prefix mismatch.
2. In candidate `3717506` report: the candidate commit SHA was reported as `37175069fbb7…` instead of actual remote commit `3717506c2e01…`.
3. In `MANIFEST.json` of candidate `7052042` and `f66ab40`: `previous_review_zip_sha256` was recorded as `9c13d51b3f9ff705116aa423fc99201f81d11bb746d5c64c7827e85c2b03d526`, which was unmeasured and differed from the actual archive digest of commit `7b28531` (`2bbd2463c1a8f8277001a7b702b819973c1a9351f40a90f06bbced6f885aa1ca`).

Correction:
Establish strict operational discipline that every hash, commit SHA, and byte length recorded in manifests, specifications, and reports must be copy-pasted verbatim from direct terminal measurement command outputs (`sha256sum`, `stat -c%s`, `git rev-parse`). For candidate v3, `previous_review_commit` is recorded strictly as `f66ab4054382d29f0f2bd9d3d2547e99c460c16d` and `previous_review_zip_sha256` is recorded strictly as `5326eefab481f53226c669b8b5d8f817cce6a2deeb4abc3180d095a958b5929d` (measured directly from `git archive --format=zip -9 f66ab4054382d29f0f2bd9d3d2547e99c460c16d`). Can this instance still carry a verdict? Yes, this correction precedes any scientific execution and reinforces reproducibility.

## F-019 — non-reproducibility of git archive ZIP digests and transition to tree SHA pinning (B-12)

During formal Gate review of candidate `c8b45d9`, the Gate observed that standard `git archive --format=zip` incorporates creation/file timestamps (`mtime`), causing archive SHA-256 digests to vary across environments and runs even when byte content and compressed lengths are identical (e.g. `c8b45d9` produced `93172` bytes in both environments, but distinct archive SHA-256 digests: `225bc86f…` vs `5331db55…`). Furthermore, entry F-018 cited an archive hash for `7b28531` (`2bbd2463…`) that differed from the Gate's fresh measurement (`40259648…`).

Correction:
A standard ZIP digest is not a reproducible git object identifier. In `MANIFEST.json`, `previous_review_zip_sha256` is replaced with `previous_review_tree_sha`, pinning the exact deterministic Git tree object SHA:
- Commit `c8b45d9c7fb751a105aa8d0af3fe0aa7d68b8860` tree SHA: `e5d5d09b7392db88097ff1f9ec8ef4bba97fcecc`.
- Commit `f66ab4054382d29f0f2bd9d3d2547e99c460c16d` tree SHA: `fa06d37fcacd43457e5505c75313ac2413dfcd2c`.
- Commit `7b2853184a01bc38605806b2185806b5892f39ba` tree SHA: `7936f50c97c5db59dfc5c59ab8c7ed1b41ccc8f4`.

Can this instance still carry a verdict? Yes; tree object SHAs are fully deterministic, intrinsic Git invariants that guarantee byte-for-byte tree identity across all environments.




