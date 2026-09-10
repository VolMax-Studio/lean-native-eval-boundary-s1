# Synthetic validation evidence supplement to draft 2

Run from the extracted package root:

```sh
sh tests/command.sh
```

Requires Python 3 standard library and a POSIX shell. The runner loads nine explicit input/expected-output fixtures from synthetic_cases.json and the two existing predicate modules. It exits nonzero on any mismatch or exception. It does not invoke Lean, access the network, read real source snapshots, or modify the recorded logs. These synthetic strings are parser fixtures, not Lean programs asserted to compile.

The three source cases check the registered signature pair, its native-side absence, and changed extern key. The six behavioral cases check the acceptance conjunction, error despite exit zero, replacement of native evidence by sorryAx, expected diagnostic location, wrong location, and an additional error. The sorryAx case combines two conditions and does not separately establish every acceptance guard. These nine cases are limited examples, not exhaustive validation or a proof of matcher correctness.

The fixture content preserves the nine cases previously run inline in this task, now materialized as independent literal inputs rather than importing the expected logical signature from the implementation. This packaging and the recorded execution are new. They do not retroactively turn the old unbundled run into archived evidence.

validation/stdout.log and stderr.log are literal bytes from the new command execution; exit-code.txt records its process exit code. validation/run.json records UTC start/end, interpreter identity, command, input hashes and output hashes. MANIFEST.json includes fixtures, runner, command and validation artifacts. A fresh replay should produce byte-identical stdout/stderr and the same exit code; wall-clock metadata is not expected to repeat.

Existing source_proxy.py, behavior_matcher.py and scientific criteria are unchanged. The evidence is a Creator self-check, not a formal Gate result, independent replication or evidence of Lean behavior.
