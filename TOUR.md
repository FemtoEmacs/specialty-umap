# Medical Specialty UMAP tour

This tour develops a reproducible UMAP for comparing medical specialties.
The shared Common Lisp implementation is present; the medical data model is
intentionally not inferred from the former stock application.

In Emacs, load `specialty.el`, place point inside a shell block, and type
`C-c e` to execute it.

## Build the eight-feature map

```sh
sbcl --script specialty-specific/build-specialty-umap.lisp
sbcl --script specialty-specific/validate-specialty-umap.lisp
sbcl --script specialty-specific/validate-specialty-clusters.lisp
```

Open `output/specialty-umap.html` for the interactive map. It defaults to the
persisted Common Lisp coordinates and offers an explicitly labeled browser
recomputation for comparison.

## 1. Review the source material

```sh
find data-sources -maxdepth 1 -type f -print | sort
```

For every proposed variable, record its medical meaning and unit; observation
unit; population, geography, and period; source and retrieval date; missing
and suppression semantics; and the meaning of higher and lower values.

## 2. Verify the shared engine

```sh
sbcl --script tests/run-all.lisp
```

These tests cover reusable UMAP, clustering, preparation, and scoring code.
They do not validate the medical interpretation of a feature.

## 3. Define the specialty comparison

The first point universe and feature are in
`data/specialty-training-paths.sexpr`. Validate the S-expression with:

```sh
sbcl --script specialty-specific/validate-training-paths.lisp \
  data/specialty-training-paths.sexpr
```

Each point is an ACGME specialty or subspecialty program category. The first
continuous feature is `:minimum-total-gme-years`; full paths and alternative
program lengths remain attached for audit and later feature engineering. The
map presents `:representative-total-gme-years` in its legend and tooltip. That
display value uses an ordinary completed clinical pathway—for example, six
years for medical oncology—rather than an exceptional minimum-entry route.

Document in `specialty-specific/`:

1. What precisely is one point on the map?
2. Which quantitative properties define similarity?
3. Which descriptive fields must not influence UMAP?
4. Are features comparable after accounting for volume, population, setting,
   and coding differences?
5. What would make a neighborhood useful or misleading?

Do not use specialty names as embedding features. Keep any known groupings
used for scoring or interpretation external to cluster discovery.

## 4. Build and validate derived data

Build and check the compensation/task feature family:

```sh
sbcl --script specialty-specific/build-compensation-features.lisp
sbcl --script specialty-specific/validate-compensation-features.lisp
```

The generated `data/specialty-compensation-tasks.sexpr` has exactly one mapping
for every training-path point. The Marit/LinkedIn chart supplies broad
specialty medians for annual wRVUs and compensation dollars per wRVU. Official
CMS 2025 files supply CPT work RVUs and physician time. These measurements are
not multiplied together or treated as interchangeable.

For a specialty absent from the chart, `:benchmark-match :nearest-available`
and `:benchmark-imputed-p t` identify the donor category. The same convention
applies to task anchors. Replace these mappings when a defensible direct source
becomes available.

Two task-rate features are retained: work RVU per intra-service hour and work
RVU per total CMS physician-work hour. Neither estimates a specialty's actual
annual hourly productivity because one anchor CPT does not represent its full
case mix.

Build and validate the scientific-activity family:

```sh
sbcl --script specialty-specific/build-scientific-features.lisp
sbcl --script specialty-specific/validate-scientific-features.lisp
```

This generates `data/specialty-scientific-activity.sexpr`. Its UMAP inputs are
NIH grants per active physician per year and inflation-adjusted NIH funding per
active physician per year. Use the recommended log10 and z-score transforms.
Totals, ranks, funding shares, and workforce counts are retained for audit but
must not enter the embedding as additional features.

The clinical-trial papers in the source metadata classify investigators or
disease areas over incompatible periods and incomplete specialty sets. They are
scientifically informative, but are not filled with artificial zeroes or merged
into this common matrix. See `data-sources/scientific-activity-methodology.md`.

Build and validate private-practice participation:

```sh
sbcl --script specialty-specific/build-private-practice-features.lisp
sbcl --script specialty-specific/validate-private-practice-features.lisp
```

The result, `data/private-practice.sexp`, uses the AMA definition: a practice
wholly owned by physicians. This is distinct from solo practice and from the
respondent personally owning the practice. Per project policy, all values enter
the UMAP, including `:confidence :low`; confidence weighting is disabled. Keep
confidence in output tooltips and run a later sensitivity analysis excluding
low-confidence rows to show how much the estimates affect neighborhoods.

Build and validate salary:

```sh
sbcl --script specialty-specific/build-salary-features.lisp
sbcl --script specialty-specific/validate-salary-features.lisp
```

`data/salaries.sexp` stores Marit average annual total compensation in nominal
US dollars. Apply log10 followed by z-score scaling. All records enter UMAP,
including low-confidence inherited values. Do not combine this column with the
separate compensation-per-wRVU measure: they answer different questions.

Build and validate workforce relative to patient burden:

```sh
sbcl --script specialty-specific/build-shortage-features.lisp
sbcl --script specialty-specific/validate-shortage-features.lisp
```

`data/specialty-workforce-burden.sexp` retains the physician numerator, relevant
patient denominator, benchmark, mapping method, confidence, and derived physicians
per 1,000 relevant patients. Narrow specialties without compatible national data
inherit the closest broad proxy at low confidence. See
`data-sources/workforce-burden-methodology.md` for interpretation and limitations.

Build and validate training competitiveness:

```sh
sbcl --script specialty-specific/build-nrmp-competitiveness.lisp
sbcl --script specialty-specific/validate-nrmp-competitiveness.lisp
```

`data/specialty-nrmp-competitiveness.sexp` stores candidates, offered positions,
candidates per position, source Match, candidate definition, mapping, and confidence.
Apply log2 followed by z-score scaling. Tiny-position and non-NRMP specialties require
the sensitivity checks described in `data-sources/nrmp-competitiveness-methodology.md`.

```text
documented sources
  -> specialty-specific extraction and normalization
  -> data/specialty-profiles.csv
  -> specialty-problem.sexpr
  -> UMAP and DBSCAN
  -> output/specialty-umap.html and score report
```

The final profile extraction and manifest follow after schema agreement. They
must reject duplicate IDs, non-finite measurements, impossible ranges, and
undocumented missing values.

Create and validate the multidimensional CSV points:

```sh
sbcl --script specialty-specific/build-specialty-point-csv.lisp
sbcl --script specialty-specific/validate-specialty-point-csv.lisp
```

The raw CSV preserves interpretable source values. The UMAP CSV has eight equally
weighted standardized coordinates. Its scientific-activity coordinate is the mean
of the separately log-standardized NIH grant-frequency and funding-intensity values,
standardized once more after combination.

## 5. Build the first map

Once the profile CSV and manifest exist:

```sh
sbcl --script build-umap.lisp specialty-problem.sexpr \
  output/specialty-umap.html
sbcl --script score-umap.lisp specialty-problem.sexpr
```

Treat the first map as exploratory. Check neighborhoods and clusters across
seeds, neighborhood sizes, feature choices, and normalization policies.

## 6. Search and audit

After a defensible baseline, AWRS-SMC may search feature-family weights and
UMAP/DBSCAN settings. Preserve proposals, rejection reasons, particle weights,
effective sample size, seeds, and the selected configuration.

Distinguish DBSCAN noise, invalid input, boundary observations reserved for
evaluation, and medically unusual but valid specialties. A valid specialty
must not be discarded merely because it weakens visual separation.

## 7. Interpret responsibly

A two-dimensional neighborhood is not evidence of clinical equivalence,
quality, causality, or substitutability. Publish provenance, scaling,
missingness, stability checks, and noise assignments with every map.

## Candidate interests in the current atlas

The candidate page preserves the map and its colors. Expand **Explore clusters
for your interests**, enter ranges for the five preferences, and choose
**Suggest clusters**. Suggestions highlight existing clusters. Approximate learned
placements are optional. See `specialty-specific/CANDIDATE-MAP.md` for details.

```sh
sbcl --script specialty-specific/train-candidate-map.lisp
sbcl --script specialty-specific/build-candidate-page.lisp
open output/specialty-candidate.html
```

The model's measured cluster agreement is shown in the panel. Five preferences
do not reliably reproduce all clusters of the nine-feature reference map;
cluster suggestions use feature compatibility and expose projection agreement.
