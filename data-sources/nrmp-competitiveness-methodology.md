# NRMP competitiveness methodology

## Feature

The scalar feature is:

```lisp
(/ candidates positions-offered)
```

A larger value means more candidates relative to available training places. It is an
intuitive measure of aggregate trainee demand, but it is not an individual's match
probability. Applicant credentials, rank-list construction, interviews, program
preferences, couples matching, and applicant type all affect individual outcomes.

## Residency definition

For the 2026 Main Residency Match, `candidates` sums applicants for whom the specialty
was their **only choice** or **first choice** across Tables 11A-11C: U.S. MD and DO
seniors, U.S. MD and DO graduates, U.S. IMGs, and non-U.S. IMGs. Total positions include
categorical, advanced, primary-care categorical, and physician positions; preliminary
positions are excluded. This avoids counting a specialty merely because an applicant
ranked it later as an alternative.

## Fellowship definition

For the 2026 appointment-year Specialties Matching Service, Table 1A supplies all
active applicants who ranked at least one program and all positions offered in each
subspecialty. NRMP notes that applicants can rank multiple specialties in combined
matches and a small number participate in more than one fellowship match, so totals
are specialty candidacies rather than globally unique people.

The two definitions are close but not identical. `:candidate-definition` and
`:match-source` are therefore retained in every record. A later sensitivity analysis
should compare maps made with residency and fellowship strata separately.

## Coverage and imputation

The reports yield 94 direct benchmarks matching this project's 143-point universe.
When a point has no direct benchmark, the builder first follows its declared training
parent. Remaining non-NRMP or unreported points receive the median of all direct
benchmark ratios. Parent inheritance and median imputation are low confidence and
remain enabled under the project's all-data policy.

The three-position NRMP `Oncology` row produces a very unstable ratio and is retained
as published rather than silently capped. The log2 transform reduces its leverage;
sensitivity analysis should also winsorize or remove tiny-denominator rows.

## UMAP preprocessing

Apply `log2` to the positive ratio and then z-score it. Keep the raw applicants,
positions, ratio, source, definition, mapping, and confidence in output tooltips.
