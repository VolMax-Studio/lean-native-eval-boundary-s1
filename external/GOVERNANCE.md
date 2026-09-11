# Governance and conflict disclosure register

Current repository base for this freeze-candidate: ae40c018081ccb0a85617549251074fd3e0d89d5 (PR #2 merged). Historical sections below describe their own earlier states; the latest recorded formal Gate result remains FIXES-PENDING (F-N), independent of merge state.

## Current role assignments

The scientific and normative layer uses Creator, Gate, Executor, Operator and final Ratifier only. This register maps those roles to current holders and preserves appointment/COI provenance. Assignment changes are governance changes, not changes to scientific claims, executable predicates or frozen review objects.

| Role | Current holder | Appointment / status |
| --- | --- | --- |
| Creator | Sol (research lead / Creator-side participant); drafting history: Astra / Codex (draft 1/2) | Authors the package and performs disclosed self-checks; not the formal Gate. Does not assign independence to self. |
| Gate | Claude | Designated formal Gate for T-A/T-B. Does not grant self-independence; Operator determines conflict acceptability. |
| Executor | Ananke (Ops custodian + confirmed Executor) | Confirmed by explicit Operator appointment. Execution authority is active only after freeze; grants no Gate or verdict authority. Operational continuity across model/session runtime is maintained without private account identifiers. |
| Operator | Ivan | Scope, assignments, conflict acceptability and workflow decisions; performs PR merge. |
| final Ratifier | Ivan | Final ratification, distinct from Creator and Gate. |

Repository coordination account: VolMax-Studio. The repository coordinate is retained in manifests and URLs as an address, not an assignment of scientific authority.

## Source attribution and discovery disclosure

R-A author/account: MarcIlunga, issue #14684 in leanprover/lean4. R-B author/publisher: Marc Ilunga / Trail of Bits. Their issue/blog links and byte hashes remain in CLAIM_OF_RECORD.md; source identity is not replaced or anonymized by role-based research governance.

The source reports GPT-5.6 involvement in discovery. This is claimant-reported provenance, not an independent observation of the discovery process. No exact Claude version (including 3.7) is inferred from the role name. The prior attribution of a formal Claude review to Astra was erroneous; the correction and original evidence are retained below and in immutable FAILURES.md.

# Historical governance decisions — outside the claim-bearing instance

This record carries scope rationale, authority provenance and role disclosures. It is not a scientific appendix and supplies no scientific verdict.

The Operator excluded T-C: the Anthropic FLT artifact and every claim about its validity, dependencies, or exposure to the disclosed bug. The instance body must not name or evaluate that artifact. Immutable source bytes can contain such references without making them adjudicated claims.

The Operator designated Claude as Gate and has explicitly confirmed: “Potvrđujem Claudeov formalni Gate nad tekstom”. Ivan remains final Ratifier. In earlier correspondence Ananke appeared as proposed Executor; explicit confirmation as Executor for the eventual frozen execution is now granted by Operator decision. Do not infer that any external task has received instructions or executed work.

Conflict acceptability is an Operator decision, not a Gate self-certification. The supplied correspondence states acceptance of Claude as Gate for T-A/T-B with the strict scope boundary. Claude must disclose exposure; model-family identity alone does not establish independence. The issue and blog report GPT-5.6 involvement in discovery, which is recorded as a claimant self-report, not independently verified discovery provenance.

Authority is reported as “VolMax Observatory — Operating Rules (P10, v2026-08)”. The original document has not been retrieved, and its location and SHA-256 remain an unresolved provenance note. By explicit Operator declaration issued 2026-09-11:

> “Kao Operator, 2026-09-11 potvrđujem da merge PR #3 nije bio ratifikacija niti freeze; `prereg_frozen` ostaje false. Potvrđujem Ananke kao Executora isključivo nakon ratifikovanog freeze-a i potvrđujem lokalni versioned `INSTANCE_RULES.md` kao operativni authority ove instance. Za behavioral execution ne zahtevam kernel network-namespace izolaciju; harness ne sme obavljati mrežne operacije tokom behavioral run-a, dok je toolchain acquisition zasebna pinned pre-execution faza. Pre freeze-a dozvoljavam samo syntax/stub validaciju, repository custody metadata, toolchain release/download/hash/extraction metadata, host-environment metadata i manifest/archive packaging; zabranjujem nova denominator source ili path-existence merenja.”

The locally versioned INSTANCE_RULES is operative and adopted as governing authority for this instance; locating or SHA-pinning the historical canonical document is not a freeze prerequisite or blocker. No canonical file SHA is invented.

## Verification attempts

- Local command: `rg -n -i --glob '*.md' --glob '!**/node_modules/**' 'VolMax Observatory|Operating Rules|P10, v2026-08' /home/volmax-studio/Documents/Codex`. Exit 1, no matches. This only bounds that Markdown search, not existence elsewhere.
- Connected tool: `mcp__codex_apps__github_search`, query `"VolMax Observatory" "Operating Rules"`, topn=5, no repository filter. Tool completed, isError=false, results=[]. No HTTP status exposed. Search is not proof of absence from inaccessible or unindexed repositories. Precise unresolved fact: location and bytes/SHA of the named canonical document.

## Review provenance — corrected by explicit Operator confirmation

gate-round-01.txt was issued by Claude and is his formal draft-1 Gate over pasted INSTANCE_RULES text. The Operator explicitly confirmed that status in this task. It did not review local commit 5e48b587c24e685db25524b0102114187c03e69b or FAILURES.md. Do not transfer its text-only scope to commit bytes. supplied-review-1.txt misattributed that reviewer to Astra and proposed an incorrect pre-gate reclassification; it is retained unchanged as historical correspondence, not operative provenance.

The latest formal Gate is external/gate-581b0a4c70aac1cf4f74ca284af003034ca4b80d.txt, targeting ZIP SHA-256 d52989959cbbfe28f7e84efe378f53659b6a10d21002fc4be0672ec60c672b9a (97022 bytes, 36 ZIP entries). It records BLOCKED for N-1/N-2. Its replay claims are Gate-reported observations; the current assistant independently checked the local ZIP size/hash and issue-body hash but does not turn that into independent reproduction of every Gate action.

Use one formal Gate vocabulary: BLOCKED / FIXES-PENDING / SURVIVES-REVIEW, as specified in the supplied correction. Scientific outcome vocabulary is separate. The Creator's repair checklist is a self-check, never a formal Gate result. Gate history across recent revisions:
- Review over `d9e97a9`: `SURVIVES-REVIEW`.
- Merge of PR #3 into `main` (`f849538`): administrative sync, not freeze ratification (`FAILURES.md#f-015`, `f-017`).
- Formal Gate review over candidate `c1398ed`: `BLOCKED` (citing B-1..B-4 and F-1..F-9).
- Formal Gate review over candidate `7b28531`: `BLOCKED` (citing B-5, B-6, B-7 and F-10..F-15).

The ZIP comment identifies a local commit but is not by itself proof of Git-tree identity to the Gate. Local archive/tree verification may be recorded as an OBSERVED custody check with its scope, without claiming that the Gate could inspect the local repository. No remote publication, upload or message to Claude has been performed by this task.

## Additional Operator decisions in this repair

T-B1 is explicitly designated “Deskriptivno merenje T-B1”. Report per-member syntactic outcomes and coverage, with no Verified/Not Verified scientific verdict. This change is an Operator-authorized scope-of-interpretation decision, not an outcome-driven modification.

Executor confirmation is established by the explicit Operator declaration above, with authority effective exclusively post-freeze. Authority status: The original canonical authority document (“VolMax Observatory — Operating Rules (P10, v2026-08)”) location and SHA-256 remain UNRESOLVED; this instance explicitly operates under locally versioned, Operator-adopted authority.

## Repository transition and latest Gate

The formal Gate reviews over candidates `c1398ed` and `7b28531` recorded `BLOCKED`. They do not authorize freeze or execution. The current repair prepares a subsequent freeze-candidate PR against updated `main` (`f849538`). No history rewrite or direct push to `main` is permitted.

STATUS.md records pre-gate, HALT and null scientific verdict. The active canonical-style vocabulary remains BLOCKED / FIXES-PENDING / SURVIVES-REVIEW, with SURVIVES-REVIEW as the passing result. Any prereg freeze must be a later separate commit after passing review and Operator ratification.

## N-4 review and current Operator distribution decision

Claude's formal review targets c8f10c960a87c12eb645366e2e64c9c98893c17d and ZIP 6c45e960ad1c290dba294f9fccbfb4c7555ec4814e0c3b2f1ab41db6e5f5098e. It closes N-3/F-I/F-J and records BLOCKED for N-4. Original review text is now external evidence indexed by data_manifest.json rather than public-tree prose.

All further changes, including freeze, proceed by PR; Ivan performs merge/ratification. The current task prepares and opens the repair PR, never merges it or directly updates main. The Operator selected a public version without raw data and no history rewrite. Raw-source snapshots and original supplied text artifacts are externalized to a local evidence ZIP. This does not remove bytes from earlier public commits or from current main before merge.

Branch-protection status: OBSERVED_DISABLED (`protected: false`) measured via GitHub API `/repos/VolMax-Studio/lean-native-eval-boundary-s1/branches/main`. Automated configuration via API is unavailable due to absence of administrative credentials in execution environment. Procedural constraint `NO_DIRECT_PUSH_TO_MAIN` is established by the Operator; all changes proceed strictly through pull requests.

## Formal Gate on PR #1 head ae4ae63 — FIXES-PENDING (F-N)

The supplied Claude result reviews ae4ae63d630bfc1aaf47381c286fcc5243d3ee1d and the matching public/private ZIPs. It reports N-4 closed, all technical blockers N-1 through N-4 closed, F-L and G-2 closed, and G-1 partially resolved according to the Operator's no-history-rewrite decision. Its formal result is FIXES-PENDING (F-N), not authorization to freeze or execute.

F-N requires the final candidate freeze commit with all execution pins to receive its own exact-SHA formal Gate; the operative rule is INSTANCE_RULES.md#freeze-boundary. This repair only makes that boundary explicit. It does not invent a review of missing pins, perform an Operator merge, or produce a freeze commit. The Gate's note concerning attribution of source-derived snippets remains an Operator consideration; this documentation-only change makes no new license claim.

## Evidence path aliases

Canonical evidence names identify the reviewed object or review round, not the reviewer identity. The following aliases preserve resolution of paths appearing in immutable FAILURES.md, earlier manifests, commits and original review text. File payload byte sizes and SHA-256 values are unchanged. Old ZIPs remain preserved. Only the new container paths and its RAW_EVIDENCE_MANIFEST differ.

| Historical path | Canonical evidence path |
| --- | --- |
| `external/claude-gate-validation-supplement.txt` | `external/gate-581b0a4c70aac1cf4f74ca284af003034ca4b80d.txt` |
| `external/claude-gate-n1-n2-repair.txt` | `external/gate-e599d55343ab0b1168cb9edc61a4355f928499b0.txt` |
| `external/claude-gate-n3-readme.txt` | `external/gate-c8f10c960a87c12eb645366e2e64c9c98893c17d.txt` |
| `external/supplied-review-2.txt` | `external/gate-round-01.txt` |

The round-01 artifact reviewed pasted draft-1 text, so its name does not assert a reviewed commit SHA. Other names identify the commit-associated package as specified by the review text; they do not enlarge the review's original scope. FAILURES.md, raw review/source payloads and Git history are not rewritten.
