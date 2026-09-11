# Specialty migration — 2026-09-11

Published implementation: array-based two-head, two-layer Transformer with legacy model support; corrected AWRS with SplitMix64; explicitly multinomial specialty search; SBCL-only spc-setup.x; formatted templates and Common Lisp JSON output; viewport-aware tooltips; consistent minimum-training-years sliders; existing visitor counter in index.html.

The supplied model records 100 epochs, 115 training and 28 validation records. Coordinate RMSE: training 0.4354358273, validation 1.3299225051. The generated preferences page was rebuilt from those weights after the slider fix.

Validation: AWRS 11/11 tests (40035 assertions); existing candidate map 6/6 (690 assertions); slider conversion 1287 checks across 143 records. The Transformer architecture, legacy roundtrip and overfit tests pass; the fitted-artifact test still references an absent historical pilot-coordinate-baseline.sexp fixture. This known test-fixture gap is not hidden as a passing suite.

Independent review checked 276 parameter gradients by finite differences and JavaScript/Lisp predictions on 143 records (maximum absolute discrepancy 4.44e-16). These checks establish numerical consistency, not independent clinical validation.

Temporary backups and deleted historical output files from local cleanup are excluded from the implementation commit. The new index.html was published separately before the source migration.
