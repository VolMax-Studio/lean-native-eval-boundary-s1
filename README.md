# Lean native-evaluation boundary — S1

A preregistration and evidence package for checking a reported Lean model/runtime discrepancy in string extraction under native evaluation. It connects published claims to pinned sources, explicitly limited tests, recorded prior exposure, and reviewable evidence.

**Current status: pre-gate · execution HALT · scientific verdict null · not frozen.** The latest formal Gate result is **BLOCKED (N-3)** on the previous review package. The N-3 repair is prepared for review. No Lean execution or full-denominator source scan has been performed in this task. [STATUS.md](STATUS.md) records the current state and remaining freeze requirements.

## What is being checked?

| Target | Registered scope | Interpretation limit |
| --- | --- | --- |
| T-A | Exact published PoC acceptance and expected native-decision rejection on the three-version matrix | Specific PoC, toolchain and platform; no general proof of correctness |
| T-B1 | Descriptive source-signature measurement over 45 stable tags through v4.33.1 | Syntactic proxy only; no Verified/Not Verified verdict or behavioral extrapolation |
| T-B2 | Behavioral matrix for v4.32.2, v4.33.1 and candidate fixed control v4.34.0-rc1 | Three versions do not establish “all stable versions”; behavior alone does not establish patch ancestry |

The source claims and their mapping to these tests are in [CLAIM_OF_RECORD.md](CLAIM_OF_RECORD.md). The executable rules, failure handling and recreation requirements are in [INSTANCE_RULES.md](INSTANCE_RULES.md). Scope is exhausted by T-A/T-B.

## Start a review here

The complete ZIP supplied with each review handoff is the primary convenient file artifact; GitHub access is optional. Identify that ZIP by its externally supplied SHA-256. Review its actual bytes, rather than relying on a summary. If GitHub is available, also record the exact commit SHA. A ZIP comment containing a commit SHA is an identifier, not independent proof of tree identity.

1. Read [STATUS.md](STATUS.md), [CLAIM_OF_RECORD.md](CLAIM_OF_RECORD.md) and [INSTANCE_RULES.md](INSTANCE_RULES.md).
2. Read [PRE_GATE_CLOSURE.md](PRE_GATE_CLOSURE.md) for repairs and outstanding blockers, and [FAILURES.md](FAILURES.md) for the append-only correction history.
3. Verify [MANIFEST.json](MANIFEST.json), then replay the synthetic validation described below.
4. Check [external/GOVERNANCE.md](external/GOVERNANCE.md) and [external/EXPOSURE_LEDGER.md](external/EXPOSURE_LEDGER.md) for authority, roles, review provenance and prior exposure. These are outside the claim-bearing instance.

Claude is the designated formal Gate; Ivan is final Ratifier. Creator self-checks and synthetic replay do not replace formal Gate review. A passing Gate and completed prerequisites must precede a **separate preregistration freeze commit**.

## Verify package bytes

Run from the extracted ZIP or repository root using Python 3:

```sh
python3 - <<'PY'
import hashlib, json
from pathlib import Path
manifest = json.loads(Path('MANIFEST.json').read_text(encoding='utf-8'))
for item in manifest['files']:
    data = Path(item['path']).read_bytes()
    if len(data) != item['bytes'] or hashlib.sha256(data).hexdigest() != item['sha256']:
        raise SystemExit('MISMATCH: ' + item['path'])
print('Verified', len(manifest['files']), 'manifest entries')
PY
```

The manifest excludes itself to avoid recursive hashing. The ZIP hash or Git commit identifies the manifest itself. Preserve the reviewed package and its identifier when comparing revisions.

## Replay instrument checks — no Lean required

These commands require Python 3's standard library and a POSIX shell. They use synthetic fixtures and do not invoke Lean or access the network:

```sh
sh tests/command.sh
sh tests/mutation-command.sh
```

The recorded N-3 validation is **54/54 fixtures passed and 38/38 declared mutants detected**. Commands must exit zero and reproduce the corresponding stdout/stderr and exit-code files in [validation/](validation/). See [tests/README.md](tests/README.md), [condition coverage](tests/CONDITION_COVERAGE.md) and the [instrument inventory](tests/INSTRUMENT_INVENTORY.md). Exceptions do not count as mutation kills. These finite checks are instrument evidence, not scientific outcomes or exhaustive correctness proofs.

## Package map

| Location | Purpose |
| --- | --- |
| `scripts/` | PoC extraction, source-signature proxy and behavioral-output classifier |
| `tests/`, `validation/` | Literal fixtures, declared mutations, commands, outputs and run provenance |
| `sources/` | Pinned source snapshots and retrieval records |
| `TAG_MANIFEST.json` | Stable-tag denominator; unresolved object/commit metadata remains explicitly pending |
| `DIAGNOSTIC_PROFILE.md`, `.json` | Static diagnostic/axiom-source evidence and registered CLI text options |
| `RESOURCE_PLAN.md` | Resource planning and remaining execution pins |
| `external/` | Governance, exposure, supplied Gate reports and distribution record |

The original local Git history is preserved in this repository. Raw third-party source content is evidence, not an additional adjudicated claim or a blanket license grant. See [distribution status](external/DISTRIBUTION.md). **This README authorizes no Lean run, freeze or scientific verdict.**
