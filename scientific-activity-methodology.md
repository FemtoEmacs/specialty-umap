# Scientific-activity feature methodology

Retrieved and reviewed 2026-09-05. The machine-readable result is
`../data/specialty-scientific-activity.sexpr`.

## Operational definition used for the first UMAP

“Scientific content” can mean investigator participation, number or quality of
trials, publications and citations, grant frequency, funding, or protected
research time. These quantities describe different systems and cannot be added
without a defensible model.

The first common feature family therefore uses two measures from Table 1 of
[Shah et al., *BMJ Open* 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9809243/):

1. NIH grants per active physician per year, 2011–2020.
2. Inflation-adjusted NIH funding per active physician per year, in thousands
   of 2011 US dollars.

Both use the same 19 NIH department categories, study period, grant universe,
and active-physician denominator. The S-expression recommends log10 followed by
z-score scaling. It retains rank, totals, percentages, and physician counts for
audit, but excludes them from UMAP because they are redundant, compositional,
or confounded by specialty size.

The 19 rows were transcribed from the open-access full-text XML and checked
against the published totals: 184,382 awards and $83,342.9 million. Individually
rounded specialty funding rows sum to $83,342.7 million, a documented $0.2
million rounding difference.

## Specialty crosswalk

Every one of the 143 ACGME points has a named `:nih-benchmark-id`, `:match`, and
`:imputed-p`. Direct broad specialties use the matching study row. A subspecialty
uses the nearest department category represented by the study. Diagnostic
radiology and radiation oncology are marked as components of the paper's
combined “radiation-diagnostic/oncology” category, because the paper does not
permit that value to be split.

These imputations intentionally produce tied values within broad families.
That is preferable to inventing false subspecialty precision. The UMAP should
include an ablation run without this feature family and a sensitivity run that
downweights all imputed rows.

Combined hematology/medical oncology and medical oncology alone remain two
distinct points. The NIH source exposes neither as a separate department row;
both currently inherit internal medicine with `:imputed-p t`. Equal values here
mean unavailable source resolution, not a merged specialty identity.

## Why the supplied trial sources are context, not matrix columns

- [Glass and Akirtava (2017)](https://www.appliedclinicaltrialsonline.com/view/what-actual-number-active-us-clinical-trial-investigators)
  found 39,855 unique US principal and sub-principal investigators in
  industry-sponsored trials during 2015–2016, but publishes only a chart of the
  ten most frequently reported specialties and supplies no consistent
  specialty-workforce denominator.
- [Califf et al., *JAMA* 2012](https://jamanetwork.com/journals/jama/fullarticle/1150093)
  analyzed 40,970 interventional trials registered from October 2007 through
  September 2010. Its highlighted groups—oncology (8,992), cardiovascular
  (3,437), and mental health (3,695)—are therapeutic areas, not mutually
  exclusive physician specialties.
- [Zwierzyna et al., *BMJ* 2018](https://pmc.ncbi.nlm.nih.gov/articles/PMC5989153/)
  mapped drug and biologic trials into seven MeSH-derived disease areas and
  studied design and dissemination. It excludes many procedural, diagnostic,
  and non-drug forms of scholarship, making it unsuitable as a universal
  specialty-volume feature.

Using zeros for uncovered specialties would mean “measured and absent,” which
is false. Mean imputation would erase meaningful uncertainty. These measures
are consequently preserved in source metadata but disabled for this UMAP.

## Complementary literature reviewed

- [Keswani et al. on US surgeon-scientists](https://pmc.ncbi.nlm.nih.gov/articles/PMC9376791/)
  provides surgical specialty and subspecialty detail for active NIH-funded PIs
  in June 2010 and June 2020. It is a promising refinement, but its snapshot of
  funded surgeons and total grant cost is not directly commensurate with the
  decade-average annual, all-active-physician denominator used above.
- [Westafer et al. on K awards across internal-medicine specialties](https://pmc.ncbi.nlm.nih.gov/articles/PMC10853154/)
  resolves internal-medicine subspecialties for K08/K23 awards during 2015–2022,
  but only measures early-career grants and normalizes the 2019 analysis to
  early-career academic faculty.
- [Karsy et al. on journal networks and scholarship](https://pubmed.ncbi.nlm.nih.gov/30144595/)
  compares journal-level bibliometrics across 25 specialties and shows that
  rankings change after accounting for physician population. Journal impact
  metrics are not physician-level output and citation practices differ by field,
  so they are not merged with grant intensity.
- [Bergmark et al. on orthopaedic NIH funding](https://pmc.ncbi.nlm.nih.gov/articles/PMC10263207/)
  offers orthopaedic subspecialty grant and publication detail, useful for a
  later within-orthopaedics model rather than the current common matrix.

## Limits

NIH classified awards by the department on the grant application, not verified
board certification of the PI. The data contain awarded grants only, so they do
not measure application success. Non-physician scientists can lead grants in
clinical departments, and active-physician count is only a denominator—not a
measure of disease burden or research opportunity. Accordingly the feature
should be named “NIH award intensity,” not “scientific quality.”
