# Derived specialty data

Generated, machine-readable specialty profiles belong here. Source notes stay
in `../data-sources/`. Record origin, retrieval date, units, population, time
period, and missing-value semantics for every derived dataset.

- `specialty-training-paths.sexpr` defines the 143-point universe, the accredited
  minimum-duration feature used by UMAP, and audited representative completed
  pathways used for human-readable year labels.
- `specialty-compensation-tasks.sexpr` maps those same IDs to article benchmark
  donors and CMS task anchors, with imputation flags and separately stored raw
  and derived quantities.
- `specialty-scientific-activity.sexpr` maps all point IDs to a 19-category NIH
  award table and declares the two normalized measures intended for UMAP.
- `private-practice.sexp` contains the 2024 physician-owned private-practice
  percentage for every point, including explicit low-confidence estimates.
- `salaries.sexp` contains Marit average total compensation for all 143 points,
  retaining the complete 41-category source table and mapping confidence.
- `specialty-workforce-burden.sexp` contains the physician headcount, relevant
  patient burden, and derived physicians per 1,000 relevant patients for all 143
  points. It is a supply-to-burden proxy rather than a formal shortage measure.
- `specialty-nrmp-competitiveness.sexp` contains 2026 candidates per offered
  residency or fellowship position, preserving NRMP counts, definitions, mappings,
  and confidence for all 143 points.
- `specialty-procedure-profile.sexp` classifies every point as procedure-
  dominant, mixed procedural/clinical, or predominantly clinical and supplies
  the ordinal ninth UMAP feature.
