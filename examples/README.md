# Examples

`specialty-points-raw.csv` is the auditable joined table for all 143 medical
specialties. It keeps the two NIH inputs separate and otherwise contains the raw
value selected from each feature family.

`specialty-points-umap.csv` is the eight-dimensional point matrix ready for UMAP:
training duration, clinical work intensity, scientific activity, private practice,
salary, workforce burden, training competitiveness, and female representation
among active residents. Each coordinate is z-scored;
positive skew is handled with the transformation declared in the source dataset.

Regenerate both files with:

```sh
sbcl --script specialty-specific/build-specialty-point-csv.lisp
sbcl --script specialty-specific/validate-specialty-point-csv.lisp
```

The scientific coordinate gives equal weight to separately log-standardized NIH
grants per physician and NIH funding per physician, then standardizes their mean.
This prevents the scientific family from counting twice in the final distance.
