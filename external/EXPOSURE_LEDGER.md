# External exposure ledger — draft 2, not scientific instance prose

This ledger separates directly observed exposure in this task from participants' supplied self-reports. No claim of a complete independently authenticated cross-task history is made. Each participant must confirm their row before freeze.

## Creator, current assistant — OBSERVED task history

- Read all seven Operator-supplied attachment texts available across this task, including excluded-subject discussion, historical version/source measurements and both draft-1 reviews. This is exposure to those reports, not replay of their measurements or direct inspection of every cited artifact.
- Authored draft 1 and draft 2; read local draft-1 files and their Git state.
- Current direct source reads: full GitHub issue #14684 through github_fetch; Trail of Bits blog through web open and saved curl response; full reference Basic.lean and object.cpp through github_fetch at f3b06c705e6c85f5314019d5d3baab0fec5b580c, with selected lines printed. No full-denominator source scan.
- Current metadata measurement: saved ls-remote snapshot during 2026-09-10T16:24:18.358058+00:00 through 16:24:20.280118+00:00; computed hash and 45-member regex denominator. Hash equals the supplied historical hash. This is new exposure before freeze.
- Selected syntactic signatures after reading the reference source and selected structural diagnostic criteria without any Lean output. Nine synthetic matcher/proxy checks passed. Synthetic examples are not runtime outcomes and are not substituted as evidence for Lean behavior.
- No Lean executable invocation has occurred in this task. No direct opening of the excluded artifact in this task; references to its README/FinalCheck were read in supplied correspondence. Do not attribute direct historical reads by another task to this task.

## Supplied reviewer disclosure — REPORTED, identity/session to be confirmed

The draft-1 pasted-text review reports exposure to the full issue body; PR pages 14687, 14717 and 14806; release pages; full object.cpp at four revisions and full Basic.lean at f3b06c7 (only excerpts displayed); two tag snapshots; and the ToB blog. It also reports two identical snapshot hashes at 15:57:56Z and 16:17:07Z. These are participant self-reports and not newly verified capture times here. The reported prior full reference commit is resolved by the current issue/source to f3b06c705e6c85f5314019d5d3baab0fec5b580c; the complete historical file/hash ledger is still to be supplied or explicitly marked unavailable.

The supplied earlier discussion quoted the excluded artifact's README and FinalCheck. The participant and direct-read provenance of that historical discussion must be confirmed; reading the quoted discussion now does not independently verify its underlying claims.

## Roles requiring disclosure completion

- Claude, formal Gate: appointment confirmed by Operator; reviewer-session identity, disclosure completeness and formal reviewed-byte record pending.
- Ananke, proposed Executor: appointment confirmation and prior-exposure disclosure pending.
- Ivan, Ratifier and conflict-acceptability decision-maker: Operator appointment of Claude is recorded; any additional role/exposure statement remains to be recorded at freeze.

## Historical PoC hash discrepancy — resolved in subsequent section

Current byte extraction yields SHA-256 ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b. The supplied history reports b089432223ed0dc2… from a different HTML-regex extraction; neither its full original byte artifact nor complete extraction chain is available here. The new hash is not equated to that historical artifact. Checking removal/addition of a boundary newline and CRLF conversion did not reproduce that prefix. Do not infer why it differs or modify the PoC to force a match. The formal Gate must review the present raw JSON → pinned script → extracted bytes chain and explicitly settle which artifact is authoritative before freeze.

## Validation evidence supplement — new observed execution

The original draft-2 archive omitted the nine-case harness and literal outputs; its validation claim was therefore a Creator report within that archive. After the Operator identified this gap, the same nine synthetic cases were materialized as literal fixtures and executed through tests/command.sh. The new literal stdout/stderr, exit code and UTC execution interval are stored in validation/. This new run is not evidence of the historical run's timestamp or bytes. Both predicate scripts and scientific criteria remain unchanged; no Lean invocation or real-source predicate scan occurred. The fixtures and this limited test selection are themselves exposed and are not outcome-blind.

## Gate repair exposure and correction — this revision

Claude's supplied formal Gate reports reading the entire reviewed ZIP, blog, both prior reviews and Message.lean at v4.33.1; running the source proxy over the reference; and performing synthetic diagnostics/mutations. It reports no Lean invocation and no other denominator source member read in that review. Its source-proxy outcome was MISMATCH for reference commit f3b06c705e6c85f5314019d5d3baab0fec5b580c, which the saved tag snapshot maps to v4.32.2. Record that member as development-exposed and positive-control-exposed; do not call it a holdout. The underlying commit-object type is still pending direct measurement.

Creator exposure added in this repair: the complete supplied formal Gate text and static formatter/CLI files in sources/diagnostics/ for each of v4.32.2, v4.33.1 and v4.34.0-rc1, all fetched at their saved full commit references. A connected code search for runAndReport on the default branch supplied path discovery only; pinned versions supplied the grammar evidence. Retrieved files, URLs and UTC capture intervals are preserved. These are diagnostic-source reads, not new String.extract predicate scans or Lean runs. The new synthetic/declared-mutation suite and its outcomes are exposed in validation/.

PoC discrepancy resolution: Claude corrected his earlier label: b089432223ed0dc23b52200ab080d429381d2766f61f33383386fceeecceb0f0 hashes the full issue body, not the fenced PoC. OBSERVED here: UTF-8 encoding of the decoded body from sources/issue-14684.connector.json produces exactly that full SHA-256. The existing extracted PoC remains ed8e65ccf56fc10509b59a047101bb1c76426ae1fd8ee4d501fb29781e54049b; no PoC bytes or extraction algorithm were changed. The historical ambiguity above is closed by this evidence.

Claude reports his saved raw-source downloads match reference-Basic.lean and reference-object.cpp byte-for-byte and his independent issue-body extraction matches the connector body. Attribute those comparisons to the Gate; do not rewrite the original connector capture as if it had included that independent check at capture time. Likewise, repeated identical tag snapshots are observations at reported retrieval times, not independent replications of the scientific claim.

Operator confirmed Claude's formal draft-1 text review and selected descriptive-only T-B1. The error of treating that formal text review as a pre-gate review is corrected in external/GOVERNANCE.md; immutable supplied correspondence is retained.

## N-3 review and repair exposure

Claude's supplied review reports reading the full N-1/N-2 package, all 18 diagnostic files, Print.lean, ElabTerm.lean, Native.lean and Decide.lean at all three matrix commits; a sparse v4.33.1 clone limited to src/Lean/Elab/Tactic and src/Lean/Meta; and the source proxy over the already exposed reference with and without mutations. It reports no Lean invocation and no new T-B1 denominator member inspection. These are attributed Gate self-reports.

Creator read that supplied review and directly retrieved Print.lean, Meta/Native.lean and Elab/Tactic/Decide.lean at the three full pinned commit SHAs; sources/diagnostics/n3-retrieval.json preserves URL/capture provenance. No additional T-B1 predicate source or Lean execution was used. The three N-3 synthetic fixtures and validation inventory are developed after exposure to the Gate's counterexamples. Their recorded runs remain instrument validation, not scientific measurements.

The Operator instructed preservation and push of the existing Git history to VolMax-Studio/lean-native-eval-boundary-s1, explicitly retaining instance files, manifests, fixtures, validation and external governance. Connected repository metadata identifies the target as public; direct git ls-remote returned exit 0 with no refs before the initial push. This authorizes the requested public repository transfer and supersedes the earlier internal-review distribution restriction for this repository/history. It does not authorize messaging, Lean execution or prereg freeze.
