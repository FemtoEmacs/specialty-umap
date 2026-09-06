# Compensation and task-wRVU provenance

Retrieved 2026-09-05. This note records how
`data/specialty-compensation-tasks.sexpr` was assembled.

## Specialty-level compensation benchmarks

The supplied [Marit Health LinkedIn article](https://www.linkedin.com/pulse/2025-wrvus-per-wrvu-benchmarks-specialty-guide-physicians-dtyac/)
reports median annual wRVUs and compensation dollars per wRVU from anonymized,
verified salary contributions current to 2025-07-01. Its figure contains only
about twenty broad categories. Values not stated in the article text were read
approximately from the chart and are marked `:extraction :chart-read`.

The article does not directly measure most ACGME subspecialties. Every absent
subspecialty therefore names one `:benchmark-id` donor and is marked
`:benchmark-match :nearest-available` plus `:benchmark-imputed-p t`. These are
transparent starting imputations, suitable for sensitivity analysis—not newly
observed compensation estimates.

## CPT work RVUs and physician time

Task work RVUs come from the official [CMS 2025 PFS Relative Value File July
release (RVU25C)](https://www.cms.gov/medicare/payment/fee-schedules/physician/pfs-relative-value-files/rvu25c),
file `PPRRVU2025_Jul.csv`, released 2025-06-05. SHA-256:
`b7937472967288d5c4dcf43ecbc5d2d792e97d768c9f5ec9b1e88a99f3d0bbe7`.

Time components come from the official [CY 2025 PFS Final Rule Physician Work
Time ZIP](https://www.cms.gov/files/zip/cy-2025-pfs-final-rule-physician-work-time.zip),
file `CMS-1807-F_Work_Time_16OCT24_508.txt`. SHA-256:
`83695668da326f10dfaf6936026529d59581e488527dd5390a6ec24d8b9fd312`.

For each representative HCPCS/CPT anchor, the S-expression stores work RVU,
pre-evaluation, positioning, scrub/dress/wait, median intra-service, immediate
post-service, and CMS total physician time separately. It derives:

```text
wRVU per intra-service hour = work RVU * 60 / median intra-service minutes
wRVU per total physician hour = work RVU * 60 / CMS total physician minutes
```

The total can exceed the five visible component fields because CMS total work
time may include other post-service/global-period work. The source's `Total_time`
is retained rather than reconstructed.

## Audit of the original examples

The original `ruv-by-specialty.md` was useful for choosing candidate anchors,
but its numbers are not treated as authoritative. The official 2025 files give,
for example:

| CPT | Original wRVU / minutes | CMS 2025 work RVU | CMS intra / total minutes |
|---|---:|---:|---:|
| 11102 | 0.55 / 8 | 0.66 | 6 / 18 |
| 74177 | 1.82 / 15 | 1.82 | 25 / 35 |
| 43239 | 1.76 / 35 | 2.39 | 17 / 50 |
| 99215 | 2.80 / 50 | 2.80 | 45 / 70 |
| 93458 | 5.45 / 60 | 5.60 | 45 / 113 |
| 27447 | 19.60 / 100 | 19.60 | 97 / 374 |
| 61510 | 26.96 / 240 | 30.83 | 200 / 635 |

## Interpretation limits

A single CPT task is an intensity anchor, not a specialty's complete case mix.
The resulting rate must not be interpreted as realized annual productivity,
take-home pay, Medicare reimbursement, or an hourly wage. Surgical global time,
concurrent work, team care, payer mix, and non-billable duties differ greatly.
Anesthesia is especially non-comparable because its PFS payment uses base and
time units rather than ordinary work RVUs; its current general-surgery donor is
explicitly imputed pending a dedicated anesthesia feature.

Medical oncology and combined hematology/medical oncology are separate points.
The supplied article publishes a hematology/oncology compensation category, so
oncology-only inherits its numerical compensation benchmark only as an explicit
`:nearest-available` imputation. It has its own `:medical-oncology` task-anchor
identity; both anchors currently use CPT 99215 because that CMS task can
represent a high-complexity established outpatient encounter in either.
