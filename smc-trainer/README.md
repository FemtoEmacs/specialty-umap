# General feature-token Transformer trainer

**For the current specialty questionnaire:** read
[the nine-feature candidate guide](../specialty-specific/CANDIDATE-MAP.md).
The deployed reference and alternative applications use radial-basis models.
The Transformer descriptions below include historical experiments and inherited
stock examples; the stock paths and 36-feature model do not describe this checkout.

This is the domain-independent Common Lisp Transformer used to learn
two-dimensional atlas coordinates. Stock adapters and demonstrations live in
`../stk-specific/`.

## Native array implementation

`transformer.lisp` implements every numerical vector and matrix as a native
Common Lisp array. Feature embeddings, per-head Q/K/V/O matrices, feed-forward
weights, tokens, attention values, pooled states, and output coordinates are
indexed with `aref`; dot products and matrix-vector products are explicit
Common Lisp loops. BLAS and LAPACK are not used, and nothing here depends on
Quicklisp or ASDF. Model files remain nested S-expression lists only as a
portable serialization format and are converted to arrays when loaded.

The architecture is a multi-head, multi-layer pre-norm Transformer encoder:

- Each scalar input feature becomes a `d-model`-dimensional token: a learned
  per-feature identity embedding plus a linear projection of the scalar
  value. Because a feature always occupies the same slot, this identity
  embedding also serves the role a positional encoding would serve in a
  sequence model.
- Every encoder layer applies multi-head scaled dot-product self-attention
  (query/key/value projected per head, heads concatenated and mixed through
  a shared output projection) and a two-layer `tanh` feed-forward sublayer,
  each wrapped in a residual connection around a learnable-gain RMSNorm
  applied to the sublayer's input (`x + sublayer(norm(x))`). A final RMSNorm
  follows the last layer.
- The normalized tokens are mean-pooled into one vector and linearly
  projected to the two output coordinates.
- `num-heads` and `num-layers` are configurable per model
  (`initialize-parametric-model`'s `:num-heads`/`:num-layers`, defaulting to
  `*trainer-num-heads*`/`*trainer-num-layers*`, currently 2 and 2); `d-model`
  must be evenly divisible by `num-heads`.

**Backward compatibility.** Models saved before this architecture change
(`:parametric-feature-transformer` `:version 1`) used a single attention head,
a single encoder block, and gain-less post-norm RMSNorm
(`norm(x + sublayer(x))`). That original computation is preserved unchanged
under the `:legacy-single-head` model kind, so any already-trained `:version
1` artifact keeps loading and predicting exactly the coordinates it always
did, without retraining. Freshly initialized models always use the new
`:multi-head-stack` kind and are saved as `:version 2`. `parametric-predict`,
`transformer-forward`/`parametric-forward`, `parametric-model-form`, and
`form-parametric-model` all dispatch on this automatically; every other
caller (`train.lisp`, `predict.lisp`, the specialty adapters below) is
unaffected.

The trained model is a parametric functor `F_theta: R^n -> R^2`: it carries
an unseen feature vector into the fixed atlas without recomputing UMAP or
moving existing points. The word “functor” describes the learned
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

## Interactive preference-insertion demo

`specialty-specific/build-preferences-page.lisp` builds a page where a person
moves sliders in real-world units (years of training, dollars, percent, ...)
and sees, live in the browser, where the trained Transformer places that
point in the atlas. It lives in `specialty-specific/`, not `smc-trainer/demo/`,
because its raw-feature map is specific to this corpus; `smc-trainer/demo/` is
reserved for demonstrations shared byte-for-byte with the `stkumap` checkout.

```sh
sbcl --script specialty-specific/build-preferences-page.lisp \
  smc-trainer/corpus/specialty-awrs-corpus.sexp \
  smc-trainer/cl-specialty-awrs-model.sexp \
  output/cl-specialty-awrs-preferences.html
```

This corpus's features were already z-scored by an upstream pipeline before
this trainer ever saw them (every corpus feature name ends in `-Z`), so
recovering real-world units needs an empirical raw-value lookup table built
by joining the corpus against `examples/specialty-points-raw.csv`, rather
than a simple inversion formula -- see the commentary at the top of the
builder. The `stk-specific/stock-build-preferences-page.lisp` counterpart in
the `stkumap`/`stock-umap` checkout has it easier: that corpus standardizes
its raw CSV columns directly, so its raw<->z conversion is an exact affine
map from the corpus's own stored mean/scale.

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

Retraining with this command now produces a `:version 2` multi-head,
multi-layer model rather than the single-head, single-layer model the
existing `smc-trainer/specialty-awrs-model.sexp` and
`smc-trainer/candidate-nine-transformer.sexp` files were trained under.
Those existing files are untouched by this change and keep loading and
predicting exactly as before; only a fresh `train.lisp` run (or the
`specialty-specific/run-nine-pipeline.lisp`/`evaluate-nine-map.lisp` scripts
that call it) picks up the new architecture and would need to be re-run
deliberately to update the published comparison numbers in
[CANDIDATE-MAP.md](../specialty-specific/CANDIDATE-MAP.md).
