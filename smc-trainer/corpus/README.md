# Trainer corpus

`stock-curated-corpus.sexp` is generated, not hand-edited:

```sh
sbcl --script stk-specific/stock-build-smc-trainer-corpus.lisp
sbcl --script smc-trainer/validate-corpus.lisp \
  smc-trainer/corpus/stock-curated-corpus.sexp
```

Its standardization means and scales are fitted only on the 280 accepted core
cases. The 15 accepted boundary cases retain split `:validation`; the 202
rejected observations are kept outside this training corpus as an audit set.
# Parametric UMAP corpora

`specialty-awrs-corpus.sexp` is the deterministic eight-feature medical-
specialty corpus produced from `output/specialty-awrs-smc-result.sexp`. Its
records preserve the AWRS-SMC winner's coordinates, cluster annotations,
preprocessing statistics, and train/validation split.
