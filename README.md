# Medical Specialty UMAP

Start with [How AI Makes a Map of Medical Specialties](outline.md) for the
plain-language introduction. AI assistants: read it before answering project
questions; [AI-DOCUMENTATION.md](AI-DOCUMENTATION.md) explains the shared guidance.

## Which HTML file should I open?

All paths below are relative to `~/specialty-umap/`.

| File | Role and current behavior |
|---|---|
| [index.html](index.html) | Published reference application: the full 143-specialty atlas, the nine-feature questionnaire, cluster prediction, approximate profile insertion, and visible input-adjustment proposals. Includes navigation to the other publication pages. |
| [output/specialty-candidate.html](output/specialty-candidate.html) | Generated output version of the same reference application. It has the same map, model, questionnaire, and insertion behavior as index.html; the root publication page adds navigation links. |
| [ref-awrs-smc-compar.html](ref-awrs-smc-compar.html) | Comparison report: reference and best sampled alternative, each reconstructed at two seeds on the 117 search-training specialties, with scores and all tested recipes. Unclustered points use plus signs. It does not insert candidate profiles. |
| [awrs-smc.html](awrs-smc.html) | Interactive alternative application: the same nine-feature questionnaire, profile insertion, and explicit apply/restore adjustment workflow, using its own trained model and the best sampled alternative's 117-specialty atlas at seed 20260905. |

The comparison filename is **ref-awrs-smc-compar.html**, without an initial
`a`. The two reference application files are alike; the comparison report is
not a substitute for either application.

### AWRS-SMC application

`awrs-smc.html` accepts all nine profile dimensions, predicts and highlights
a cluster in the alternative atlas, displays the approximate inserted profile,
and offers explicit, reversible input-adjustment proposals when needed. Salary
must remain a hard minimum: someone accepting 260k will accept 260k or more,
but not less. The same whole-number controls and transparent uncertainty
handling apply to both applications.

The alternative has its own trained and validated radial-basis model, coordinates,
and cluster labels. It uses the 117 search records at seed 20260905 and 250 UMAP
epochs, matching one of the existing comparison panels. Grouped validation
recovered 106/117 cluster labels and 92/117 clusters through predicted coordinates.
These are mapping-validation results within the fixed search atlas, not an
independent evaluation of the search or career outcomes. The comparison report
is unchanged and still shows both search seeds.

### Rebuild the current pages

From the project root:

```sh
sbcl --script specialty-specific/build-candidate-page.lisp
sbcl --script specialty-specific/build-awrs-publication.lisp
```

The first command writes `output/specialty-candidate.html`. The second uses it
to write `index.html` with publication navigation and regenerates the comparison page. It preserves the trained interactive
alternative instead of replacing it with static plots. Rebuild only the alternative
application (without writing index.html or the comparison) with:

```sh
sbcl --script specialty-specific/build-awrs-candidate.lisp
node tests/awrs-candidate-tests.cjs
```

The model, supervised corpus, browser fixtures, and grouped validation are saved
under `smc-trainer/candidate-awrs-deployed.sexp`,
`smc-trainer/corpus/candidate-awrs-supervised.sexp`,
`output/candidate-awrs-model.json`, and
`output/candidate-awrs-validation.sexp`, respectively.

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

Open `output/specialty-candidate.html`. All nine dimensions use whole-number
ranges. A Common Lisp radial-basis network predicts one existing cluster, with
optional approximate coordinates. The original map and colors are preserved.
Grouped validation recovered 127/143 cluster labels; coordinate-cluster recovery
was 101/143. AWRS-SMC tested 24 alternative map recipes; none beat the reference.
See `specialty-specific/CANDIDATE-MAP.md` for reproduction, full comparisons,
questionnaire mappings, and validation limitations.
