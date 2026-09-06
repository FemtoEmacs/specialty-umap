# Workforce-to-burden density methodology

## Definition

The UMAP feature is `physicians-per-1000-relevant-patients`:

```lisp
(/ physician-count (/ relevant-patient-count 1000.0))
```

Higher values mean more physician supply relative to the selected patient burden. The
feature is a **workforce-to-burden density**, not a formal shortage estimate. It does
not account for geography, full-time-equivalent effort, productivity, care supplied by
other professions, referral rates, disease severity, utilization, or unmet demand.

## Numerators

The preferred numerator is an AAMC/AMA active-physician headcount. AAMC defines active
physicians as licensed physicians working more than 20 hours weekly and includes direct
patient care as well as teaching, research, administration, and other work. Therefore,
these counts somewhat overstate the clinical supply available to patients. The 2021
AAMC report is retained because it offers a stable specialty table and matches the
user-provided oncology arithmetic. The current AAMC dashboard is recorded as the
successor source.

## Denominators

The denominator is the estimated number of people in the United States with the main
disease burden served by a specialty. For generalist and population-facing specialties,
the relevant age-defined population is used. For procedure- and diagnostic-centered
specialties, a national annual utilization count may substitute for unique patients;
those records are explicitly labeled as proxies and assigned low confidence.

Patient scopes overlap. Values must not be summed across specialties.

## Narrow specialties

Compatible national workforce and patient counts do not exist for every one of the 143
ACGME categories. A narrow subspecialty therefore inherits the closest broad benchmark
unless a compatible direct pair is available. Such mappings are marked
`:mapping :broad-proxy-inherited` and `:confidence :low`. They remain enabled because
the project policy is to use all estimates in UMAP.

## Oncology and endocrinology checks

- Hematology and medical oncology need: `(11,937 + 4,778) /
  ((18,000,000 + 2,000,000) / 1,000) = 0.83575`. Both physician groups
  serve the same cancer patient pool, so this point uses their combined workforce.
- Medical oncology alone: `4,778 / ((18,000,000 + 2,000,000) / 1,000)
  = 0.2389`.
- Endocrinology: `8,000 / (40,000,000 / 1,000) = 0.2`.

Hematology/medical oncology and medical oncology remain separate UMAP points. The
combined point sums both cancer-care workforces for the need calculation; the
oncology-only point retains its own workforce. Their salary values remain separate.

## UMAP preprocessing

Use all records, take `log10` of the positive density, and z-score the transformed
values. Confidence is provenance metadata and is not a numerical weight.

## Principal sources

- AAMC, U.S. Physician Workforce Data Dashboard and its methods.
- AAMC, 2022 Physician Specialty Data Report (2021 physician counts).
- CDC, National Diabetes Statistics Report and disease-specific burden pages.
- NCI Office of Cancer Survivorship, cancer survivor statistics.
- U.S. Census Bureau population estimates.
- Specialty-specific national burden organizations identified in each benchmark.

The generated S-expression retains the numerator year, denominator year, sources,
scope note, mapping method, and confidence so estimates can be replaced without
changing the feature schema.
