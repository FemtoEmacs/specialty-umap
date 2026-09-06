# Specialty-specific code

Medical-specialty extraction, normalization, validation, feature construction,
and domain tests belong here. This layer may depend on the shared engine; the
shared engine must not depend on this layer.

Current dependency-free programs:

- `build-compensation-features.lisp` joins the 143-point universe to explicit
  broad-specialty benchmark and representative-task donors.
- `validate-compensation-features.lisp` checks point coverage, foreign keys,
  imputation flags, time ranges, and both wRVU/hour calculations.
- `build-scientific-features.lisp` preserves the published NIH award table and
  creates explicit broad-specialty donor mappings.
- `validate-scientific-features.lisp` checks 143-point coverage, donor keys,
  imputation semantics, positivity, and published aggregate totals.
- `build-private-practice-features.lisp` expands the AMA's plotted ownership
  categories to all points while retaining crosswalk confidence.
- `validate-private-practice-features.lisp` verifies percentages, confidence,
  source-category keys, exact point coverage, and UMAP inclusion.
- `build-salary-features.lisp` expands the retained Marit salary categories to
  the point universe without collapsing oncology and hematology/oncology.
- `validate-salary-features.lisp` checks coverage, donors, positive values,
  confidence, UMAP inclusion, and the oncology separation invariant.
# Workforce-to-burden feature

`build-shortage-features.lisp` generates
`../data/specialty-workforce-burden.sexp`. Run
`validate-shortage-features.lisp` to check coverage, arithmetic, ordering, and the
separate oncology records.

`build-nrmp-competitiveness.lisp` creates the candidates-per-position feature from
the 2026 NRMP Main Match and Specialties Matching Service tables;
`validate-nrmp-competitiveness.lisp` checks coverage and arithmetic.
