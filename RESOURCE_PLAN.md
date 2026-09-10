# Resource estimate — planning only, no execution authorization

DERIVED: the two captured reference-source representations total 228341 bytes. Multiplying that by 45 yields 10275345 bytes as a rough source-payload planning estimate. Historical sizes may differ. Plan 90 primary source-file reads, plus object/commit metadata resolution, one deterministic source scan and its recreation. This is not an estimate for 45 toolchains; only three are in the behavioral matrix.

Behavioral plan: six fresh Lean processes (first run and recreation for each of three versions). Download size, installed size, cold native-compilation time and final time/disk caps remain PENDING distribution metadata and environment preparation. Do not obtain timing estimates by running Lean before freeze. Freeze the actual toolchain manifest, harness and resource limits before execution. A bounded run that times out produces the predeclared blocker, never successful rejection.
