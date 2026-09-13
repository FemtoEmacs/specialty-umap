# Fine-tuning AWRS-SMC and the specialty Transformer

This note records the placement fix for the current specialty-umap checkout. It was informed by `~/csand/umapsp/finetuning-awrs-smc.md`, but the two repositories have separate copies of the AWRS-SMC and Transformer code and different atlases. Changes here were made and tested against this repository's nine-feature, 143-specialty atlas. The sarcoma project was not changed.

## The visible failure

On the Transformer preferences page, selecting “Primary, emergency and preventive care” moved the sliders to that cluster's representative specialty, Occupational and Environmental Medicine, but the red predicted star could land outside its blue-circled atlas position or even outside its cluster. The blue circle shows the representative specialty's saved atlas coordinates; the star shows what the trained Transformer predicts from an input vector. Their separation exposed a prediction problem, rather than a drawing problem.

The existing build had two ways to produce that separation:

1. `smc-trainer/build-corpus.lisp` selected validation groups by sorting record identifiers alphabetically. Since each specialty is its own group, the last 28 of 143 identifiers were always excluded from training. This was a persistent training omission, not a rotating or randomized validation sample.
2. Clicking a cluster filled raw-value sliders and called `update()` with no argument. That reconstructed standardized model inputs by interpolating from the displayed raw values. The cluster summary already contained its representative specialty's exact saved `z_values`; using the reconstructed values could ask the model to place a different profile. Slider rounding and shared raw values make that inverse mapping unreliable.

## Changes to the build

- `specialty-specific/specialty-awrs-smc-search.sexp` now sets `:no-validation-split t`. `smc-trainer/build-corpus.lisp` honors that setting, so the deployed corpus trains on all 143 records. This is appropriate for reproducing positions on the fixed atlas, but it removes the pipeline's held-out validation measurement. Generalization must be evaluated separately.
- `spc-setup.x` now defaults to 500 training epochs and learning rate `0.0007d0`, following the convergence settings documented in the reference. `SPC_EPOCHS` and `SPC_LR` still override them.
- `smc-trainer/train.lisp` reports an empty validation split as `n/a` and stores `nil` validation error metrics instead of dividing by zero or implying a zero error.
- `smc-trainer/build-corpus.lisp` and `src/common-lisp-umap.lisp` treat scales below `1.0d-6` as effectively constant, preventing floating-point noise from becoming a standardized feature.
- `specialty-specific/preferences-template.html` passes `clusterInfo.z_values` directly to `update()` when a cluster is clicked. Manual slider movement still uses the raw-to-model interpolation. The template also retains the descriptive cluster labels, blue representative-position circle, and the site's GoatCounter when the page is regenerated.

`./spc-setup.x` runs the AWRS-SMC search, builds and validates the corpus, trains the Transformer, and writes `output/cl-specialty-awrs-preferences.html`. The output was copied to `index.html` in this checkout for testing. The generator is the source of the page behavior; editing `index.html` alone would be overwritten by that workflow.

## Verification

The full `./spc-setup.x` pipeline completed in an isolated copy of this checkout. Its corpus stage reported **143 training records and 0 validation records**. At epoch 500, training coordinate RMSE was **0.174315**; that is training fit, not held-out performance. The generated page's JavaScript passed `node --check`.

`sbcl --script tests/specialty-cluster-placement.lisp` predicts each record from its saved input, finds the nearest atlas point, and checks the affected representative. Occupational and Environmental Medicine has true cluster 2 and its prediction's nearest atlas point is also in cluster 2, with a coordinate gap of **0.0696**. Across the full corpus, **141/143** predicted positions have a nearest atlas point in the same cluster as the source record; mean coordinate gap is **0.2125**. Two records still miss this nearest-cluster criterion, so the model should not be described as exact. `sbcl --script tests/preferences-conversion-tests.lisp` passed 1,287 raw-to-model checks.

The existing general trainer suite was attempted via `vendor/test-cases/run-tests.lisp`: five tests passed, and one could not run because its fixture `smc-trainer/weights/pilot-coordinate-baseline.sexp` is absent from this checkout. That fixture failure is separate from the placement check above.

## Rebuild and review

From the repository root:

```sh
./spc-setup.x
sbcl --script tests/specialty-cluster-placement.lisp
sbcl --script tests/preferences-conversion-tests.lisp
```

Review `output/cl-specialty-awrs-preferences.html` in a browser. To use that generated page as the homepage, copy it to `index.html` after review. The current changes have not been committed or pushed.

The descriptive cluster names in the page are currently keyed to cluster numbers for this fixed atlas. If a future AWRS-SMC run materially changes cluster membership or numbering, review those names again. The 141/143 result measures how well the trained model reproduces the atlas it trained on; it does not measure preference validity, career satisfaction, or performance on new specialties.

Revised 2026-09-13.
