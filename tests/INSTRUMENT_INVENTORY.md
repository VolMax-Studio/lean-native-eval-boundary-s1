# Code-derived condition and transformation inventory — N-3

Scope: the outcome-bearing pipeline of scripts/source_proxy.py and scripts/behavior_matcher.py. Source hashes and the mechanical AST inventory are in INSTRUMENT_INVENTORY.json. The rows below group primitive syntax and pure plumbing by the outcome they control; they do not claim that every byte-edit mutant is distinct. CONDITION_COVERAGE.md indexes actual wrong-classification witnesses for every declared non-equivalent mutant.

| Code operation / condition | Named fixture(s) | Declared mutation(s) / disposition |
| --- | --- | --- |
| Exact extern join key and recognized logical signature/header | S03_changed_extern_key; S04_changed_logical_body | M08, M09; header parse failure is INAPPLICABLE, not an inferred semantic match |
| Whitespace normalization | S01_signature_pair | I01 |
| Pos.Raw → Pos normalization | N3_U6_raw_spelling_in_body | U6 |
| Logical block boundary; keep `where`, stop at next column-zero declaration | S01_signature_pair (contains where and next declaration) | I02, I03 |
| Full normalized logical-body equality | S04_changed_logical_body | M09 |
| Exactly one matching logical body | S03_changed_extern_key; S05_duplicate_logical_signature | M08; duplicate is classified INAPPLICABLE |
| Exactly one native definition with registered function/parameters | S06_duplicate_native_definition; S07_missing_native_definition | M18; zero-match mutations may crash and are never counted as kills |
| Regex block and line comment removal from bounded native body | N3_U8_comment_in_native_guard | U8, I10, I11 |
| Native signature must be leading, not merely present | S02_absent_native_signature; S08_native_prefix_is_not_contains | M19; signature removal also distinguished by S01/S02 |
| AX record names flt and follows the registered bracketed-list format | I04_other_theorem_axioms; B21_no_axiom_record | I04; malformed/no complete match cannot satisfy acceptance |
| Split comma-delimited axiom list and strip name whitespace | B07_sorry_with_valid_native | I05 |
| Exactly one axiom record | B13_duplicate_axiom_records | M10 |
| Required nonstandard axiom with native_decide substring | B09_other_nonstandard_axiom; B22_standard_axioms_only | M04; STD exclusion alone is redundant for these fixed STD names |
| Exclude sorryAx even with valid native evidence | B07_sorry_with_valid_native | M01 |
| ACCEPT requires exit zero | B08_native_axiom_nonzero_exit | M03 |
| ACCEPT requires no error in either stream, including orphan/named errors | B02_error_despite_zero; N1_block_accept_named_stdout/stderr; N1_block_nested_name; N1_block_malformed_position | M02, M16, M17, M22 |
| Positioned severity header grammar: named labels and optional end range | N1_reject_named_stdout/stderr; N1_reject_range_stdout/stderr; N1_reject_named_range_stdout/stderr | M20, M21 |
| Diagnostic body stops at next recognized severity header | B19_warning_does_not_supply_false | M20 also exposes loss of named-warning boundary |
| Diagnostic body stops before separate axiom record | N3_U1_axiom_cannot_supply_false | U1 |
| Parse stdout and stderr separately | B20_cross_stream_not_one_diagnostic | I07 |
| Select only error severity; warning is not an extra error | B18_warning_then_expected_error | M23 |
| Trim source lines, identify exactly one native_decide line and use one-based index | B04_native_false_correct_line; B15_two_native_locations; B23_no_native_source_location | M11, I06, I09; zero-location access failures are conservative invalid mutants, not kills |
| Rejection requires nonzero exit | B12_rejection_zero_exit | M07 |
| Exactly one error; raw marker count must match parsed errors | B06_additional_error; B16_unparsed_extra_named_error | M12, M13 |
| Error at the registered source line | B05_native_false_wrong_line | M14 |
| Error file basename is PoC.lean; absolute path allowed | B10_wrong_filename; I05_absolute_PoC_path | M05, I08 |
| Diagnostic includes native_decide and whole word false | B14_false_without_native_name; B11_native_without_false; B17_false_word_boundary | M15, M06, M24 |
| Failed classification falls back to EVIDENCE_INSUFFICIENT / unrecognized source to INAPPLICABLE | B21_no_axiom_record; S03_changed_extern_key | Covered by returned class in fixtures; changing fallback would fail them |

Explicit exclusions from the kill requirement: Gate's U3 removing error-marker lookbehind only broadens conservative error detection; Gate's U5 including the header in the diagnostic body is practically equivalent for registered input grammar. The fixed STD membership condition is redundant with the native_decide substring for those three names. Guards that merely prevent None/index accesses on malformed input are parser-safety plumbing; a crash is an evidence failure, not a scientific contrary result, and is not a kill. CLI file decoding, serialization, loop bookkeeping, regex group extraction and constructing records are listed in the mechanical AST inventory but are not separate scientific decision rules.

Stopping rule: finish this finite inventory and declared mutations, preserve actual witnesses, and submit the exact commit. No unexplained outcome-changing row may be waived. Conservative/invalid/equivalent cases must remain explicit. This does not claim complete proof of program correctness. A future Gate finding must identify a concrete unclassified operation and counterfixture; it is not a request for endless arbitrary source mutations.
