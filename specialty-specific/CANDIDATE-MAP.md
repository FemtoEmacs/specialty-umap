# Candidate profiles in the fixed specialty atlas

Open `output/specialty-candidate.html` in a browser. Expand **Explore clusters for
your interests**, enter acceptable ranges, and choose **Suggest clusters**.
The original 143 points, cluster identities, and color ordering are preserved.
The questionnaire is outside the plot and collapses. Suggestions highlight up
to three existing clusters. Optional diamond markers show approximate learned
coordinates; a marker may lie outside the suggested cluster. Clear suggestions
removes highlights and markers. No questionnaire answers are transmitted or saved.
The page still downloads D3 and umap-js from the same CDN as the original page.

## Reproduce (SBCL, no Python or third-party Lisp libraries)

From the project root:

```sh
sbcl --script specialty-specific/train-candidate-map.lisp
sbcl --script smc-trainer/validate-corpus.lisp smc-trainer/corpus/candidate-fixed-atlas.sexp
sbcl --script specialty-specific/build-candidate-page.lisp
sbcl --script vendor/test-cases/run-tests.lisp tests/candidate-map-tests.lisp
node tests/candidate-engine-tests.cjs
```

The separate candidate page leaves `output/specialty-umap.html` intact. Rebuild
this page after changing the tooltip template. If the input data or atlas have
changed, the builder refuses a stale model: retrain first. Do not use the generic
`predict.lisp` CLI with this artifact: this version includes output normalization
and uses the `:candidate-fixed-atlas` format. Browser inference mirrors the Lisp
Transformer and is checked against a Lisp prediction for every observed profile.

## Corpus and training

Inputs, in order:

1. Representative completed residency/fellowship years.
2. Procedure intensity, from 0 (clinical) through 0.5 (mixed) to 1 (procedural).
3. `log(1 + NIH grants per active physician per year)` as research proxy.
4. Percentage in physician-owned private practice.
5. Candidates per training position as competitiveness proxy.

Scientific activity and competitiveness answers are empirical atlas percentiles,
converted into the corresponding numerical feature values before standardizing.
These are relative preferences, not personal grant counts or admission odds.
An individual's desired private-practice involvement is approximated using a
specialty-level ownership percentage. These questionnaire-to-feature mappings
are explicit assumptions and have not been validated against career outcomes.

Each observed specialty is paired with its existing CSV coordinates, without
calling UMAP or DBSCAN. No synthetic coordinates or new clusters are invented.
AWRS-SMC is not required to select a new atlas: this task fixes that atlas.
The 143 rows contain 126 distinct five-input groups. Every fifth group goes into
validation, keeping identical inputs together: 117 training and 26 validation
rows. Input and target means/scales are fitted only on training rows. The existing
8-dimensional feature-token Transformer trains for a fixed 100 epochs with Adam,
learning rate 0.002. The saved model uses only the training partition; validation
rows are not refitted. The atlas itself predates the split, so this evaluates
mapping within the known atlas, not a wholly unseen-population UMAP experiment.

`output/candidate-evaluation.sexp` reports coordinate RMSE against a training-mean
baseline, nearest-training-point cluster agreement, and training-neighbor recall
at five. The current five-input model does not reliably identify the nine-input
atlas clusters. The UI displays the measured agreement and retains approximate
markers as an opt-in feature. Do not interpret regression coordinates as a
validated assignment to a career or cluster.

## Multiple suggestions

The browser evaluates 128 deterministic Halton samples over the requested ranges.
Each sample runs through the saved Transformer (no optimization or UMAP fit).
A five-feature distance check rejects samples outside the atlas's empirical
support: the cutoff is 1.5 times the 95th percentile of leave-one-out nearest
neighbor distances, with a floor of 0.5 standardized distance units. This is a
heuristic support check, not a calibrated confidence interval.

A supported sample can support more than one existing cluster: include clusters
with a member within the support cutoff and 0.35 standardized distance units of
the closest member. Noise is not suggested as a cluster. Rank primarily by sample
coverage, using projection agreement as a tie preference; return up to three.
Coverage overlaps across clusters and is not a probability. Markers are coordinate
medians of each suggestion's supported samples; they are never snapped to a
specialty or a cluster center. Explanations summarize all five characteristics of
the existing cluster. This approach exposes ambiguity from the four omitted map
features instead of pretending that five interests uniquely determine a cluster.

Training duration is enforced as a hard range on the member records supporting
each suggestion. Other dimensions use the proximity rule above. Cluster summaries
in the panel describe members inside that training range, while highlighting the
whole cluster does not imply every member satisfies the range.
