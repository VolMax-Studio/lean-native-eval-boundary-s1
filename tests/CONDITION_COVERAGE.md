# Declared mutation witnesses — N-3

Derived index of literal validation/mutation-stdout.log; exceptions never count as kills.

| Mutant | Result | First witness | Expected | Mutant result |
| --- | --- | --- | --- | --- |
| M01_drop_sorry_guard | KILLED | B07_sorry_with_valid_native | EVIDENCE_INSUFFICIENT | ACCEPT |
| M02_drop_no_error | KILLED | B02_error_despite_zero | EVIDENCE_INSUFFICIENT | ACCEPT |
| M03_drop_accept_zero_exit | KILLED | B08_native_axiom_nonzero_exit | EVIDENCE_INSUFFICIENT | ACCEPT |
| M04_drop_native_axiom_name | KILLED | B09_other_nonstandard_axiom | EVIDENCE_INSUFFICIENT | ACCEPT |
| M05_drop_filename | KILLED | B10_wrong_filename | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M06_drop_false | KILLED | B11_native_without_false | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M07_drop_reject_nonzero_exit | KILLED | B12_rejection_zero_exit | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M08_drop_logical_signature_count | KILLED | S03_changed_extern_key | PREDICATE_INAPPLICABLE | MISMATCH |
| M09_accept_any_logical_body | KILLED | S04_changed_logical_body | PREDICATE_INAPPLICABLE | MISMATCH |
| M10_drop_unique_axiom_record | KILLED | B13_duplicate_axiom_records | EVIDENCE_INSUFFICIENT | ACCEPT |
| M11_drop_unique_native_location | KILLED | B15_two_native_locations | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M12_drop_unique_error | KILLED | B06_additional_error | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M13_drop_unparsed_error_guard | KILLED | B16_unparsed_extra_named_error | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M14_drop_error_location | KILLED | B05_native_false_wrong_line | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M15_drop_diagnostic_native_name | KILLED | B14_false_without_native_name | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M16_ignore_stdout_errors | KILLED | N1_block_accept_plain_stdout | EVIDENCE_INSUFFICIENT | ACCEPT |
| M17_ignore_stderr_errors | KILLED | B02_error_despite_zero | EVIDENCE_INSUFFICIENT | ACCEPT |
| M18_drop_native_definition_count | KILLED | S06_duplicate_native_definition | PREDICATE_INAPPLICABLE | MISMATCH |
| M19_prefix_becomes_contains | KILLED | S08_native_prefix_is_not_contains | NO_MISMATCH | MISMATCH |
| M20_drop_named_header | KILLED | B19_warning_does_not_supply_false | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M21_drop_end_range_header | KILLED | N1_reject_range_stdout | EXPECTED_NATIVE_REJECTION | EVIDENCE_INSUFFICIENT |
| M22_drop_named_error_marker | KILLED | B16_unparsed_extra_named_error | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| M23_ignore_severity | KILLED | B18_warning_then_expected_error | EXPECTED_NATIVE_REJECTION | EVIDENCE_INSUFFICIENT |
| M24_false_substring_only | KILLED | B17_false_word_boundary | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| U1_drop_axiom_boundary | KILLED | N3_U1_axiom_cannot_supply_false | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| U6_drop_Pos_Raw_normalization | KILLED | N3_U6_raw_spelling_in_body | MISMATCH | PREDICATE_INAPPLICABLE |
| U8_drop_C_comment_stripping | KILLED | N3_U8_comment_in_native_guard | MISMATCH | NO_MISMATCH |
| I01_drop_whitespace_normalization | KILLED | S01_signature_pair | MISMATCH | PREDICATE_INAPPLICABLE |
| I02_drop_declaration_stop | KILLED | S01_signature_pair | MISMATCH | PREDICATE_INAPPLICABLE |
| I03_stop_at_where | KILLED | S01_signature_pair | MISMATCH | PREDICATE_INAPPLICABLE |
| I04_accept_other_theorem_axioms | KILLED | I04_other_theorem_axioms | EVIDENCE_INSUFFICIENT | ACCEPT |
| I05_drop_axiom_name_strip | KILLED | B07_sorry_with_valid_native | EVIDENCE_INSUFFICIENT | ACCEPT |
| I06_drop_source_line_strip | KILLED | B04_native_false_correct_line | EXPECTED_NATIVE_REJECTION | EVIDENCE_INSUFFICIENT |
| I07_merge_streams_before_parse | KILLED | B20_cross_stream_not_one_diagnostic | EVIDENCE_INSUFFICIENT | EXPECTED_NATIVE_REJECTION |
| I08_drop_path_basename | KILLED | I05_absolute_PoC_path | EXPECTED_NATIVE_REJECTION | EVIDENCE_INSUFFICIENT |
| I09_zero_based_line | KILLED | B04_native_false_correct_line | EXPECTED_NATIVE_REJECTION | EVIDENCE_INSUFFICIENT |
| I10_drop_block_comment_alternative | KILLED | N3_U8_comment_in_native_guard | MISMATCH | NO_MISMATCH |
| I11_drop_line_comment_alternative | KILLED | N3_U8_comment_in_native_guard | MISMATCH | NO_MISMATCH |
