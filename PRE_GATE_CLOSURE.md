# Creator self-check — gate-repair-n4

phase: pre-gate; execution_state: HALT; scientific verdict: null. The last formal Gate reviewed c8f10c960a87c12eb645366e2e64c9c98893c17d and its matching README ZIP, closed N-3/F-I/F-J, and recorded BLOCKED for N-4. This proposed PR does not replace that formal verdict with a passing result.

| Finding | Repair/evidence | Creator check |
| --- | --- | --- |
| N-4 A1 | no-expose fixture + require-expose mutant | Wrong classification detected |
| N-4 A2 | namespace-less name fixture + require-prefix mutant | Wrong classification detected |
| N-4 A3 | Pos.extract fixture + require-Raw-name mutant | Wrong classification detected |
| N-4 A4 | plain Pos parameter fixture + require-Raw-parameters mutant | Wrong classification detected |
| N-4 A7 | axiom record only in stderr + allow-stderr-axiom mutant | Widened acceptance detected |
| N-4 A5a/A5b | Declared equivalent only under registered formatter's mandatory output space | Not counted as non-equivalent kills |
| F-L | README integrity output changed to hash-match | Scientific vocabulary separated |
| F-M | Gate's public-clone/alternative-sweep exposure recorded | Attributed ledger entry |
| G-1 | Operator chose public version without raw data, with no history rewrite | Proposed tree externalizes originals; data_manifest.json indexes separate local ZIP |
| G-2 | Repair goes to PR, not main; Ivan merges/ratifies | No Creator merge or freeze |

Validation: 59/59 explicit fixtures pass; 43/43 declared mutants have wrong-classification witnesses. Literal outputs, commands and hashes are packaged. The three instrument scripts are unchanged; N-4 adds coverage, not a modified scientific predicate. Existing condition inventory now names each Gate-identified recognition alternative and the stdout-only AX rule separately.

The proposed public tree does not contain original raw-source payloads or verbatim supplied review .txt files. Those bytes are retained locally in the separate evidence ZIP with full path/size/SHA-256 inventory. Current main and earlier public commits are not rewritten or erased. This is a prepared public-tree correction, not retroactive withdrawal. Synthetic fixtures and validation remain public and self-contained.

Remaining before freeze: formal Gate over this exact repair object; Operator merge/ratification; Executor/disclosure/authority requirements; complete tag/toolchain/userland/harness/cleanup/resource pins; availability of external evidence. No Lean invocation or full-denominator scientific source scan occurred. No merge or freeze is performed here.
