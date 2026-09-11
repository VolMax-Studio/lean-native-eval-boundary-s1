# Creator self-check — role-based governance refactor

phase: pre-gate; execution_state: HALT; scientific verdict: null. The last formal Gate reviewed PR #1 head ae4ae63d630bfc1aaf47381c286fcc5243d3ee1d with public ZIP 8ed9d0e685f343a8d03bfc522958b39a3787132e2ae9929aa15465c1cbc6d051 and private ZIP dd626b822347766a53a86ecbab8e5140d9dbdbe0d84047a968a43358717b74ab. It closes N-1 through N-4 and records FIXES-PENDING for F-N. This role-based documentation refactor does not change that formal result or authorize freeze.

| Finding | Repair/evidence | Creator check |
| --- | --- | --- |
| F-N | Complete candidate freeze commit requires its own exact-SHA formal Gate and separate Operator ratification | Rule added; formal re-review pending |
| N-4 A1 | no-expose fixture + require-expose mutant | Wrong classification detected |
| N-4 A2 | namespace-less name fixture + require-prefix mutant | Wrong classification detected |
| N-4 A3 | Pos.extract fixture + require-Raw-name mutant | Wrong classification detected |
| N-4 A4 | plain Pos parameter fixture + require-Raw-parameters mutant | Wrong classification detected |
| N-4 A7 | axiom record only in stderr + allow-stderr-axiom mutant | Widened acceptance detected |
| N-4 A5a/A5b | Declared equivalent only under registered formatter's mandatory output space | Not counted as non-equivalent kills |
| F-L | README integrity output changed to hash-match | Scientific vocabulary separated |
| F-M | Gate's public-clone/alternative-sweep exposure recorded | Attributed ledger entry |
| G-1 | Operator chose public version without raw data, with no history rewrite | Proposed tree externalizes originals; data_manifest.json indexes separate local ZIP |
| G-2 | Repair goes to PR, not main; Operator merges; final Ratifier ratifies | No Creator merge or freeze |

Validation: 59/59 explicit fixtures pass; 43/43 declared mutants have wrong-classification witnesses. Literal outputs, commands and hashes are packaged. The three instrument scripts are unchanged; N-4 adds coverage, not a modified scientific predicate. Existing condition inventory now names each Gate-identified recognition alternative and the stdout-only AX rule separately.

The proposed public tree does not contain original raw-source payloads or verbatim supplied review .txt files. Those bytes are retained locally in the separate evidence ZIP with full path/size/SHA-256 inventory. The evidence-externalization PR is now merged; current main has the public tree without original raw payloads, while earlier public commits retain them. History is not rewritten. This is a prepared public-tree correction, not retroactive withdrawal. Synthetic fixtures and validation remain public and self-contained.

Remaining preparation includes Executor/disclosure/authority requirements, complete tag/toolchain/userland/harness/cleanup/resource pins and external evidence availability. The mandatory separate formal review of the complete candidate freeze commit is governed by [INSTANCE_RULES.md — Freeze boundary](INSTANCE_RULES.md#freeze-boundary); the current repair review does not cover that future object. No Lean invocation or full-denominator scientific source scan occurred. No merge or freeze is performed here.

Only documentation and the public manifest change in this F-N revision. The recorded 59/59 fixture and 43/43 mutation results belong to the unchanged instrument/test artifacts; no new test or Lean run is claimed.

Role-based refactor: operative documents name roles only; concrete holders, source-author attribution and conflicts are centralized in external/GOVERNANCE.md. Neutral evidence-path aliases preserve historical lookup without changing payload bytes. FAILURES.md, instrument code, fixtures and literal validation records remain byte-identical to the merged base. This revision claims no new scientific result or validation run.

## Freeze candidate preparation self-check

- **Denominator resolution (T-B1):** All 45 denominator tags are resolved to commit objects in `TAG_MANIFEST.json`; `object_type="commit"`, verified against snapshot `sources/lsremote_tags.txt` (SHA-256 `565d84d4...`) and live Git wire protocol ref advertisement.
- **Behavioral toolchains pinned (T-A):** Pinned Lean v4.32.2, v4.33.1, and v4.34.0-rc1 Linux x86_64 distribution asset URLs, byte sizes, and stream-verified SHA-256 digests in `EXECUTION_SPEC.md`.
- **Environment & harness pinned:** Target OS, architecture, libc/userland requirements, shell, required environment variables, literal invocation command, binary stream capture, deterministic byte-for-byte recreation sequence, and cleanup allowlist pinned in `EXECUTION_SPEC.md`.
- **Resource limits pinned:** Process timeout (60s), sequential concurrency (1), memory cap (4096 MB RSS), and workspace disk cap (2048 MB) pinned in `RESOURCE_PLAN.md` and `EXECUTION_SPEC.md`.
- **Participant governance:** Explicit Operator confirmation of Ananke as Executor recorded in `external/GOVERNANCE.md`; Sol recorded as advisory participant without normative/Gate authority; `CLAIM_OF_RECORD.md` restored Marc Ilunga / Trail of Bits source attribution per Gate B-1 finding.
- **Branch protection & process boundary:** Queried GitHub API for `main`; recorded `BRANCH_PROTECTION_UNAVAILABLE` due to lack of administrative PAT in environment; established procedural constraint `NO_DIRECT_PUSH_TO_MAIN`.
- **Absolute pre-freeze prohibitions:** `LEAN_RUNS=0`; no T-B1 denominator source scan; no invocation of target Lean versions on test artifact; no observation of scientific outcomes.
