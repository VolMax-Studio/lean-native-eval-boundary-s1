# Final Adjudication — P10 Instance `lean-native-eval-boundary-s1`

Status: CLOSED — ADJUDICATED POST-RUN  
Authoritative Frozen Commit: `f11a44a31cf014e73212b73234645ee489bd53e4`  
Authoritative Frozen Tree SHA: `4df5ed0907a9fd505be9f43ac9c7d6c8fd307aa3`  
Immutable Git Tag: `prereg-frozen-s1-f11a44a`  
Operator Ratification Date: 2026-09-12  

---

## 1. Executive Summary & Verdict

| Dimension | Adjudicated Outcome | Basis & Precedence Rule |
| :--- | :---: | :--- |
| **Instance Verdict** | **`Deferred`** | Rule `INSTANCE_RULES.md:67`: `EXTERNAL_EXECUTION_BLOCKER` leads to `Deferred`. |
| **Behavioral Matrix (T-A)** | **`Deferred`** | All 3 runs aborted at startup under pre-frozen `prlimit --as=4294967296` (`failed to create thread`). No behavioral measurement was executed. |
| **Source Scan (T-B1, descriptive)** | **13 MISMATCH / 32 PREDICATE_INAPPLICABLE / 0 NO_MISMATCH** | 45 denominator tags evaluated and 100% byte-identically recreated (`aggregate_status: COMPLETE`). |
| **Universal Source Claim** | **`Not Demonstrated`** | Syntactic predicate inapplicable to 32 earliest tags; no behavioral counterexample established. |

---

## 2. Review and Ratification Provenance

1. **Pre-Run Formal Gate Review:**
   - Evaluated exact candidate commit `f11a44a31cf014e73212b73234645ee489bd53e4` (Tree `4df5ed0907a9fd505be9f43ac9c7d6c8fd307aa3`).
   - Verdict: **`SURVIVES-REVIEW`** (mapped in canonical P10 vocabulary as `GATE_PASS`). Blockers B-1 through B-13 closed; non-blocking recommendation F-25 accepted without modifying frozen commit.
2. **Operator Ratification Declaration (2026-09-12):**
   - Explicit verbatim declaration by Operator / final Ratifier ratifying preregistration freeze on exact commit `f11a44a` and tree `4df5ed09`.
   - Authority to execute granted strictly to confirmed Executor (`Ananke`).
3. **Executed Evidence Package:**
   - Package: `lean-native-eval-boundary-s1-executed-evidence-f11a44a.zip`
   - Archive SHA-256: `cabaf7760edb24020ae054c3b6ef47cb4c9d08977121b045d5d18da6a47fb15d`
   - Measured Length: **1,529,682 bytes** (provenance note: initial reporting stated 1,529,824 bytes due to unmeasured pre-zip estimate; exact byte measurement 1,529,682 B is authoritative).
   - Total Entries: 318 entries (260 tracked in `evidence/manifest.json`).
4. **Post-Run Formal Gate Review:**
   - Verdict: **`SURVIVES-REVIEW`**. Evidence package verified as faithful, deterministic, byte-identical recreation of the executed run.

---

## 3. Detailed Adjudication by Track

### Track A: Behavioral Evaluation (T-A)
- **Execution Environment:** Linux 7.0.0-31-generic x86_64, glibc 2.39, user `volmax-studio` (1000:1000).
- **Execution Execution State:** All runs executed strictly against `f11a44a3` (`git_commit.txt` matches across all 3 toolchains; `test_stub_mode: false`).
- **Observed Behavior:**
  - `v4.32.2`: Exit 134/134, stdout 0 B, stderr `libc++abi: terminating due to uncaught exception of type lean::exception: failed to create thread`
  - `v4.33.1`: Exit 1/1, stdout 0 B, stderr `failed to create thread`
  - `v4.34.0-rc1`: Exit 1/1, stdout 0 B, stderr `failed to create thread: Resource temporarily unavailable`
- **Taxonomic Resolution:**
  - The literal output of `scripts/behavior_matcher.py` is `EVIDENCE_INSUFFICIENT` because `harness/run_behavioral.sh:167` only mapped exit code 124 to EEB.
  - However, under authoritative rule `INSTANCE_RULES.md:65`, failure due to expiry or exhaustion of a pre-frozen time/resource limit (`prlimit --as=4294967296`) is strictly an `EXTERNAL_EXECUTION_BLOCKER`.
  - Under `INSTANCE_RULES.md:67`, when an external blocker is the sole failure class, the adjudicated outcome is **`Deferred`**.
  - **Critical Invariant:** No scientific statement (Verified, Not Verified, or Not Demonstrated) may be asserted regarding the runtime behavior of the vulnerability or control.

### Track B1: Descriptive Denominator Source Scan (T-B1)
- **Denominator Members:** 45 resolved Git tag commits.
- **Aggregate Measurement Status:** **`COMPLETE`** (`INSTANCE_RULES.md:45`).
- **Detailed Counts:**
  - `MISMATCH`: **13** members (`v4.26.0` through `v4.33.1`).
  - `PREDICATE_INAPPLICABLE`: **32** members (`v4.0.0` through `v4.25.2`).
  - `NO_MISMATCH`: **0** members.
  - `EVIDENCE_INSUFFICIENT`: **0** members.
  - `EXTERNAL_EXECUTION_BLOCKER`: **0** members.
- **Recreation:** 45/45 evaluations byte-identically recreated (`recreation_match: True`).
- **Precise Semantics of Inapplicability:**
  - For inspected earlier denominator members (e.g. `v4.25.2`), the declaration `def Pos.Raw.extract` and `@\[extern "lean_string_utf8_extract"\]` exist, but use an earlier logical body spelling (`(go₁ s.data 0 b e).asString` rather than `ofList (go₁ s.toList 0 b e)`).
  - The classification `PREDICATE_INAPPLICABLE` for the 32 members reflects the narrow syntactic boundary of the registered proxy requiring exact logical-body match, **not** a demonstrated absence of the underlying extract implementation or extern binding across earlier Lean versions.
  - The broader universal source claim ("all stable versions up to 4.33.1") is descriptive **`Not Demonstrated`**.

---

## 4. Review Scope and Limitations

1. **Evidence Packaging:** The post-run formal Gate reviewed the executed artifacts from the standalone ZIP archive `cabaf776...`, not by observing real-time runtime execution.
2. **Preflight Library Record:** Preflight checks in `run_behavioral.sh` verified `libleanshared.so` against `toolchain_pins.json` prior to execution (which would have aborted on mismatch), but `hashes.json` recorded only `lean_bin_sha256`. Pinned library verification was verified structurally via harness code inspection and exit status, but was not captured as an explicit field in the individual run evidence json.
3. **Repository Tree Invariance:** The frozen object `f11a44a31cf014e73212b73234645ee489bd53e4` remains immutable. This closure document and associated status updates exist purely in the post-run administrative layer.

---

## 5. Next Instance Note (`s2`)

Any subsequent evaluation of behavioral execution under modified resource parameters cannot be conducted as a continuation of `s1`. It must be initiated as a distinct instance (e.g. `lean-native-eval-boundary-s2`):
- **Virtual Memory Architecture:** Lean 4 multi-threading initializes thread worker pools proportional to host CPU core count. Under standard Linux glibc thread stack allocation, a 4096 MB virtual address limit (`--as`) triggers `EAGAIN` during thread creation before PoC elaboration begins.
- **Pre-Registration Requirement:** The resource limit for `s2` must be determined mechanically from runtime architectural requirements (e.g. resident memory / cgroup bounds or thread concurrency bounds `-j 1`) prior to freeze, accompanied by an offline preflight test demonstrating that the limits permit successful thread pool initialization.
