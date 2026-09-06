# Medical Specialty UMAP

This project compares medical specialties with a reproducible Common Lisp
UMAP pipeline. It reuses the domain-independent UMAP, DBSCAN, V-measure,
AWRS-SMC, and training machinery from `stock-umap`; stock data, manifests,
models, and stock-specific programs are intentionally excluded.

## Project boundary

- `src/`, `umap/`, `smc/`, `awrs-smc/`, and `smc-trainer/` contain reusable
  analytical infrastructure.
- `specialty-specific/` contains medical-specialty preparation, validation,
  feature construction, and tests.
- `data-sources/` preserves source notes and provenance.
- `data/` contains derived, machine-readable specialty data.
- `output/` contains generated maps and score reports.
- `TOUR.md` is the executable guide; `specialty.el` runs its shell blocks.

## Current status

The point universe and first feature are defined in
`data/specialty-training-paths.sexpr`: 143 ACGME specialty/subspecialty
categories with minimum accredited postgraduate training, representative
completed-pathway years for display, and auditable paths. This distinction
keeps exceptional early-entry rules from understating the duration users
normally associate with a practicing subspecialist.

`data/specialty-compensation-tasks.sexpr` adds the compensation/productivity
family. It keeps annual wRVUs, compensation dollars per wRVU, representative
CPT task, task work RVU, CMS time components, and derived task wRVU/hour as
separate fields. Broad-category substitutions are explicit imputations, not
silent specialty measurements. The final UMAP manifest remains to be defined.

`data/specialty-scientific-activity.sexpr` adds a research-intensity family
based on 2011–2020 NIH awards per active physician and inflation-adjusted NIH
funding per active physician. It maps all 143 points to 19 published department
categories while preserving every imputation and the source table's raw totals.

`data/private-practice.sexp` adds the 2024 percentage of physicians in
physician-owned private practices. All 143 records are enabled for UMAP and
carry high, medium, or low confidence plus the AMA category used.

`data/salaries.sexp` adds Marit average annual total compensation. It preserves
41 source categories, maps all 143 points with confidence, and keeps medical
oncology distinct from combined hematology/medical oncology.

`data/specialty-workforce-burden.sexp` adds physician supply per 1,000 relevant
patients. It retains both operands, identifies broad inherited proxies, and keeps
medical oncology separate from hematology/medical oncology. It is a comparative
workforce-to-burden density rather than a formal shortage determination.

`data/specialty-nrmp-competitiveness.sexp` adds candidates per offered training
position from the 2026 NRMP Main Residency Match and Specialties Matching Service.
All operands and differing candidate definitions are retained for audit.

`examples/specialty-points-raw.csv` and `examples/specialty-points-umap.csv`
join the eight feature families into interpretable raw values and an equally
weighted, transformed point matrix ready for the first UMAP.

`specialty-problem.sexpr` declares the deterministic 143-point map. Run
`sbcl --script specialty-specific/build-specialty-umap.lisp` to create its
coordinate CSV, audit S-expression, and interactive page in `output/`.

`data/specialty-sex-distribution.sexp` adds an eighth coordinate: the female
percentage among active residents with reported sex in ACGME Table C.21 for
academic year 2024-2025. The rebuilt map detects DBSCAN clusters in the final
two-dimensional UMAP coordinates and assigns descriptive names from the two
largest absolute cluster-level feature means.

## Start

Read `TOUR.md`, or open it in Emacs:

```elisp
(load-file "/Users/eduardo/specialty-umap/specialty.el")
(specialty-tour-open)
```
# Specialty UMAP

## Candidate interest profiles

Open `output/specialty-candidate.html` to explore existing clusters using five
preference ranges. The trained Common Lisp model preserves the current atlas;
the collapsible questionnaire suggests up to three clusters and optionally shows
approximate profile markers. The measured held-out cluster agreement is low,
so suggestions combine feature compatibility with separately reported projection
agreement. See `specialty-specific/CANDIDATE-MAP.md` for reproduction, evaluation,
questionnaire assumptions, and model limitations.
