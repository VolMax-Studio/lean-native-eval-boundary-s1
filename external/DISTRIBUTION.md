# Distribution decision — public tree without raw data; history unchanged

Latest Operator instruction: “Pripremi public verziju bez raw podataka; ne prepisuj istoriju još”. This supersedes the prior public raw-transfer designation for newly proposed content.

Merged PR #1 externalized all original sources/ artifacts and original supplied review/correspondence .txt files. The proposed public tree retains instrument code, synthetic fixtures, literal synthetic validation logs, generated governance summaries and SHA-256 inventories. data_manifest.json indexes the removed bytes, which are preserved in a separate local evidence ZIP for the Operator/Gate. That ZIP is not pushed by this task.

No history rewrite is authorized or performed. Earlier commits remain publicly accessible with their original bytes; the evidence-externalization PR is now merged, so main no longer includes the original raw payloads in its current tree. G-1 is therefore addressed as a merged public-tree change, not complete historical withdrawal. Further visibility/history action requires a separate Operator decision.

Lean source headers and license references remain in the separate raw-evidence archive. A full source-license clearance is not asserted, and no blanket license is granted for blog/issue/review content. No original third-party raw source payload is added to the proposed public tree. See DATA_ACCESS.md for the distinction between public-file integrity and external evidence provenance.

Current repository observation for this refactor: PR #1 is merged, main base c08c9504746dca3b68ba9476815212df59e7525d. Its current tree has no sources/ payloads; historical commits are unchanged. The new neutral-path evidence ZIP preserves all original payload hashes.
