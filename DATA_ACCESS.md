# Public package and separate evidence bytes

This proposed public tree contains claims, rules, executable instrument code, synthetic fixtures, validation logs, governance summaries and hash inventories. Original source snapshots and verbatim supplied review/correspondence files are externalized. They are indexed by original relative path, byte size and SHA-256 in data_manifest.json. MANIFEST.json covers only files present in this public tree; data_manifest.json separately covers required external evidence.

The full raw-evidence ZIP is retained locally for the Operator and Gate, not committed or publicly uploaded by this task. Its filename, byte size and SHA-256 appear in data_manifest.json. For a review requiring source bytes, verify that ZIP's outer hash and its RAW_EVIDENCE_MANIFEST.json, then use the original relative paths under an isolated evidence directory. Do not restore raw files into the public checkout or commit them.

For example, after separately obtaining and extracting the evidence ZIP outside the public checkout, PoC extraction can be checked with the existing script by explicitly passing the external issue JSON and a scratch output path. Predicate-scanning or Lean-execution authorization is not implied. Synthetic validation needs no external source bytes and still runs directly from the public package.

Historical rule/profile references to sources/ and original review filenames are evidence identifiers resolved through data_manifest.json, not promises that those files remain present in public HEAD. Saved source URLs and hashes in the profile/claim documents remain provenance. Raw-source license review must be resolved before any later publication of those bytes; this change makes no blanket license grant.

The Operator selected a public version without raw data and explicitly prohibited rewriting history for now. Consequently earlier public commits still contain the original bytes, and main remains unchanged until the PR is merged. Removing files from a proposed tree is not historical erasure or access revocation. The PR is not merged by the Creator.
