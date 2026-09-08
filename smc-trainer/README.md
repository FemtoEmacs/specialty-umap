# General feature-token Transformer trainer

**For the current specialty questionnaire:** read
[the nine-feature candidate guide](../specialty-specific/CANDIDATE-MAP.md).
The deployed reference and alternative applications use radial-basis models.
The Transformer descriptions below include historical experiments and inherited
stock examples; the stock paths and 36-feature model do not describe this checkout.

This is the unchanged, domain-independent Common Lisp Transformer used to
learn two-dimensional atlas coordinates. Stock adapters and demonstrations
live in `../stk-specific/`.

## Native array implementation

`transformer.lisp` implements every numerical vector and matrix as a native
Common Lisp array. Feature embeddings, Q/K/V/O matrices, feed-forward weights,
tokens, attention values, pooled states, and output coordinates are indexed
with `aref`; dot products and matrix-vector products are explicit Common Lisp
loops. BLAS and LAPACK are not used. Version-1 model files remain nested
S-expression lists only as a portable serialization format and are converted
to arrays when loaded.

The trained model is a parametric functor `F_theta: R^36 -> R^2`: it carries
an unseen stock-property vector into the fixed atlas without recomputing UMAP
or moving existing points. The word “functor” describes the learned
structure-carrying map in the operational learning-theory sense. No formal
claim about category-theoretic identity or composition laws is made.

Reproduce the stock model from the project root:

```sh
sbcl --script stk-specific/stock-build-smc-trainer-corpus.lisp
sbcl --script smc-trainer/validate-corpus.lisp \
  smc-trainer/corpus/stock-curated-corpus.sexp
sbcl --script smc-trainer/train.lisp \
  smc-trainer/corpus/stock-curated-corpus.sexp \
  smc-trainer/stock-curated-model.sexp 100 0.002d0
sbcl --script stk-specific/stock-evaluate-smc-trainer.lisp
sbcl --script stk-specific/stock-build-transformer-insertion-demo.lisp
```

The corpus has 280 training cases and 15 withheld boundary cases. The last
command generates `output/stock-transformer-new-points.html`; it does not
recompute UMAP.

## Medical-specialty model

The specialty adapter uses AWRS-SMC to choose a legal transformation recipe
that best reproduces the mentor clusters discovered in two-dimensional UMAP
space. It then preserves the winning coordinates as supervision for this
unchanged trainer:

```sh
sbcl --script awrs-smc/search-umap.lisp \
  specialty-specific/specialty-awrs-smc-search.sexp \
  output/specialty-awrs-smc-result.sexp
sbcl --script smc-trainer/build-corpus.lisp \
  output/specialty-awrs-smc-result.sexp \
  smc-trainer/corpus/specialty-awrs-corpus.sexp
sbcl --script smc-trainer/validate-corpus.lisp \
  smc-trainer/corpus/specialty-awrs-corpus.sexp
sbcl --script smc-trainer/train.lisp \
  smc-trainer/corpus/specialty-awrs-corpus.sexp \
  smc-trainer/specialty-awrs-model.sexp 100 0.002d0
```

The deterministic corpus contains 143 examples with eight selected features:
115 training examples and 28 specialty-held-out validation examples. The
AWRS-SMC result records the proposal, constraints, rejections, particle
weights, winning transformations, coordinates, and clustering score.
