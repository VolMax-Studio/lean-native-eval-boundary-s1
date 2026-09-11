# Synthetic and mutation validation — N-4 repair

Run from the extracted package root:

```sh
sh tests/command.sh
sh tests/mutation-command.sh
```

Python 3 standard library and a POSIX shell are sufficient. Both commands exit nonzero on failure. They do not invoke Lean, access the network, or read real source snapshots. These fixture strings are parser inputs, not asserted compilable Lean programs.

The 59 explicit fixtures include the original nine plus independent negative cases for acceptance exit status, sorryAx alongside valid native evidence, a non-native nonstandard axiom, duplicate axiom records, rejection filename/line/exit/keywords, duplicate native locations, extra errors and malformed error records. Named labels and optional end positions are tested in both stdout and stderr, for expected rejection and prevention of acceptance. Source cases cover changed extern key, changed logical body, duplicate/missing definitions and prefix versus mere containment.

mutations.json specifies 43 uniquely located single-change mutants. run_mutations.py first checks the unmodified baseline, then compiles each altered Python module in memory and runs applicable fixtures. A mutant is KILLED only by an explicit changed classification against a fixture's expected outcome. Exceptions are listed separately and never count as a kill. The log preserves all witnesses and each mutated source SHA-256. A compile error or non-unique mutation site fails the harness rather than improving the score.

The first nine mutants cover the Gate's nine reported mutations, including the central logical-body equality. Remaining mutants cover additional independent guards and diagnostic grammar. This is a declared mutation set, not an exhaustive proof. The `not in STD` subcondition is redundant with native_decide substring matching for the three fixed STD names; deleting that redundant subcondition alone is not counted as a meaningful killable mutant. No claim is made that every possible parser bug or equivalent mutant is covered.

validation/stdout.log, stderr.log and exit-code.txt preserve the new fixture run. validation/mutation-stdout.log, mutation-stderr.log and mutation-exit-code.txt preserve the new mutation run. validation/run.json records commands, UTC intervals, interpreter identity and input/output hashes. Fresh replay must reproduce both commands' literal stdout/stderr and exit codes; time metadata is separate. The earlier nine-case record remains in the preserved prior commit/archive and is not overwritten historically.

This is Creator self-check evidence. The formal Gate's recorded finding applies to the prior reviewed ZIP; only the designated Gate may issue the next formal Gate result over the repaired bytes. No scientific run, behavioral evidence or independence is inferred from these tests.

N-3 adds dedicated U1/U6/U8 fixtures and two inventory fixtures for wrong-theorem axiom records and absolute input paths. The code-derived inventory and conservative/equivalent exclusions are in INSTRUMENT_INVENTORY.md/json. Additional declared transformation mutants reuse existing fixtures where possible.

N-4 adds exactly five fixtures: four supported source-header alternatives and axiom evidence only in stderr. The matching A1–A4/A7 mutants must each have a wrong-classification witness. A5a/A5b diagnostic-label spacing variants are equivalent within the registered formatter grammar, which always emits a space after the label. They are not counted as non-equivalent mutants.
