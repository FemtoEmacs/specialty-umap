# Sex distribution methodology

The feature is the percentage of active residents who were reported as female
within each specialty or subspecialty in academic year 2024-2025. It comes from
Table C.21 of the ACGME *Data Resource Book, Academic Year 2024-2025*:

https://www.acgme.org/globalassets/pfassets/publicationsbooks/2024-2025_acgme_databook_document.pdf

The denominator excludes residents whose sex was not reported:

`100 * female / (female + male)`

This measures the current training pipeline, not the sex distribution of all
practicing physicians. The source uses a binary female/male classification and
also reports missing sex; the derived data do not reinterpret those categories.

Rows appearing under more than one parent discipline are combined by adding
their female, male, and unreported counts before calculating the percentage.
These are marked `:count-weighted-aggregate`. Critical care retains distinct
anesthesiology and internal-medicine source rows.

Confidence is based on the number with reported sex: high for at least 100,
medium for 25-99, and low for fewer than 25. All records remain enabled for the
UMAP, following the project convention for low-confidence values.
