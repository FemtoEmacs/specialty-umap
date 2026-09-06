# Salary feature methodology

The generated feature file is `../data/salaries.sexp`; the supplied 41-line
input is preserved verbatim as `salaries-original.txt`.

## Source and measure

The values are from [Marit Health's US physician salary page](https://www.marithealth.com/o/-/physician/salary),
retrieved 2026-09-05 and verified against its live “Browse specialties” list.
Marit labels the site-wide quantity “average total compensation.” The feature
therefore represents nominal annual US dollars for full-time physicians and can
include base salary, bonuses, and other income. It is not base salary, median
salary, hourly pay, or dollars per wRVU.

Marit states that it removes outliers and applies de-biasing adjustments when
calculating averages. The supplied extract does not contain specialty sample
sizes, percentiles, uncertainty intervals, or the date of every component
salary. Those limitations remain explicit in the generated data.

## Point mapping

All 41 source categories are retained. Five are not points in the current ACGME
universe: Bariatric Medicine, Oral Maxillofacial Surgery, Podiatry, Urgent Care,
and Wound Care. Standalone Hematology is also retained but not assigned because
the point universe currently contains combined Hematology/Medical Oncology and
Medical Oncology—not hematology alone.

Every one of the 143 points has a salary, confidence, mapping basis, source
donor, and `:umap-use t`:

- `:high`: direct category or spelling/name crosswalk.
- `:medium`: inherited from a clear parent specialty.
- `:low`: a multidisciplinary or otherwise ambiguous nearest-category estimate.

Per project policy, all confidence levels enter UMAP without confidence
weighting. Salary should be log10-transformed and then z-scored because its
distribution is positive and right-skewed.

## Oncology separation

Marit provides three separate source values:

| Source category | Average total compensation |
|---|---:|
| Hematology | $574,000 |
| Hematology Oncology | $587,000 |
| Oncology | $638,000 |

The UMAP point `:hematology-and-medical-oncology` uses $587,000, while
`:medical-oncology` uses $638,000. They have different donor identifiers and
the validator rejects any future collapse of the two. The $574,000 hematology
value is preserved but unused until a hematology-only point is introduced.
