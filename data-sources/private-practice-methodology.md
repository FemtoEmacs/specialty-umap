# Private-practice feature methodology

The generated feature file is `../data/private-practice.sexp`. The original
handwritten seed is preserved as `private-practice-original.sexp`.

## Source and definition

Values come from Exhibit 2 of Carol K. Kane's [AMA *Physician Practice
Characteristics in 2024* report](https://www.ama-assn.org/system/files/2024-prp-pp-characteristics.pdf).
The nationally representative Physician Practice Benchmark Survey sampled
5,000 eligible physicians in late August–September 2024, had a 43% response
rate, applied survey weights, and reports more than 100 respondents per plotted
specialty category.

The feature is the percentage of physicians whose main practice was wholly
owned by one or more physicians in that practice. It is not the solo-practice
percentage, the percentage of physicians personally holding equity, or the
percentage working outside hospitals.

## Exact plotted categories

| AMA category | Percent |
|---|---:|
| Cardiology | 30.7 |
| General surgery | 31.7 |
| Emergency medicine | 33.2 |
| Pediatrics | 38.1 |
| Internal medicine | 38.9 |
| Internal medicine subspecialties | 39.2 |
| Family medicine | 42.2 |
| All physicians | 42.2 |
| Other | 43.6 |
| Psychiatry | 45.2 |
| Obstetrics/gynecology | 46.3 |
| Anesthesiology | 46.4 |
| Radiology | 46.9 |
| Other surgical subspecialties | 51.2 |
| Orthopedic surgery | 54.0 |
| Ophthalmology | 70.4 |

The chart resolves the `unclear` entries in the original seed: pediatrics is
38.1%, internal medicine 38.9%, internal-medicine subspecialties 39.2%, family
medicine 42.2%, “other” 43.6%, and psychiatry 45.2%.

## Crosswalk and confidence

- `:high` means the ACGME point directly matches a plotted AMA category.
- `:medium` means a subspecialty inherits an explicitly plotted parent or group
  category, such as electrophysiology from cardiology or vascular surgery from
  other surgical subspecialties.
- `:low` means the report does not publish a usable placement. The point is
  assigned to AMA “Other” or, for internal medicine/pediatrics, the overall
  rate. This is an explicit estimate rather than a measured specialty value.

Each record stores the numeric value, confidence, basis, and source category.
Following the project decision, `:umap-use t` is present on all 143 records and
confidence does not alter feature weight. The confidence labels remain
available for later sensitivity and ablation analyses.

Medical oncology and combined hematology/medical oncology are separate records.
Both inherit the AMA's 39.2% internal-medicine-subspecialties category at medium
confidence because Exhibit 2 does not publish oncology-only or combined
hematology/oncology estimates. The shared value is a donor, not a merged point.

## Important limitation

Many subspecialties share a donor value because the AMA publication exposes
only 15 plotted categories. Those ties represent the source's resolution; they
must not be described as direct subspecialty estimates. Private-practice shares
also change over time, so the survey year must travel with every derived map.
