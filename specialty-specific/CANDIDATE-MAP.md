# Nine-feature candidate model

Open `output/specialty-candidate.html`. All nine dimensions are required, with
whole-number ranges. A broad range expresses flexibility; it is not an omitted
feature. The form stays outside the map in a collapsible panel. The system returns
one cluster, or reports an ambiguous/unsupported profile. Coordinate markers are
optional and approximate. The original atlas, cluster identities, and colors are
preserved.

## Inputs and questionnaire mapping

| Input | Question scale | Model representation |
|---|---|---|
| Residency/fellowship duration | Minimum accredited years | Training-duration z score |
| Procedural profile | Integer 0–10 | Divide by 10; map to procedure-intensity z score |
| Scientific activity | Integer 0–100 percentile | Composite grant/funding scientific-activity z score |
| Private practice | Integer percentage 0–100 | Map percentage to private-practice z score |
| Competitiveness | Integer 0–100 percentile | Candidates-per-position z score |
| Clinical intensity | Integer 0–100 percentile | Clinical-work-intensity z score |
| Salary | Integer thousands of US dollars | Compensation z score |
| Physician availability | Integer 0–100 percentile | Physicians-per-patient-burden z score |
| Female representation | Integer percentage 0–100 | Specialty workforce-composition z score |

The final field describes a desired specialty environment. It does not request or
infer the candidate's sex or gender. Ranges outside observed numeric data clamp
to the nearest supported endpoint. Thus 0% private practice is accepted and handled
internally. Percentile mappings use the empirical atlas distribution. Other
questions use piecewise interpolation between observed raw values and their
transformed feature values. Training years now refer to minimum accredited years,
matching the training coordinate; the original map tooltip may also report a longer
representative completed pathway. All of these answers describe desired specialty
characteristics rather than personal measurements. Their mapping to career
satisfaction is not validated.

## What was trained

`smc-trainer/rbf.lisp` implements a Gaussian radial-basis network in native Common
Lisp, with learned linear output weights. One head predicts two normalized atlas
coordinates; the other predicts one score for each existing cluster. The fit solves
a regularized kernel system using partial-pivot elimination. The resulting finite
network evaluates a saved forward function; insertion does not run UMAP, DBSCAN,
optimization, or a training loop.

The existing Transformer was also trained with all nine features for 200 epochs.
The RBF model was chosen for the cluster-label objective and simpler fitting on
this small dataset. It is not a claim that RBF is generally superior to Transformers.
It minimizes regularized supervision loss, not the native UMAP objective.

The corpus uses all nine transformed features from the current embedding CSV,
with explicit schema order. It preserves both coordinate targets and cluster
labels. Identical five-input profiles remain grouped, also preventing leakage
between identical nine-input records in this dataset. Input and target scaling
are fitted only on each training partition. The reference atlas and original
z-score data predate these splits: evaluation is transductive recovery of an
existing atlas, not a wholly unseen-population embedding experiment.

## Results

Same historical 26-specialty holdout:

| Predictor | Cluster-label matches | Cluster recovered from predicted coordinates |
|---|---:|---:|
| Original five-input Transformer | not trained for labels | 6/26 (23%) |
| Five-input nearest neighbor | 14/26 (54%) | not applicable |
| Nine-input nearest neighbor | 23/26 (88%) | not applicable |
| Nine-input Transformer | not trained for labels | 19/26 (73%) |
| Nine-input RBF | 24/26 (92%) | 18/26 (69%) |

The RBF coordinate RMSE is 0.616 atlas units versus 2.511 for a mean-coordinate
baseline and 0.712 for the nine-input Transformer. Cluster-label accuracy and
coordinate-cluster recovery are different metrics and must not be conflated.

Five-fold grouped validation, each of 143 specialties predicted once without its
group in training:

- RBF cluster-label accuracy: **127/143 (88.8%)**.
- Nine-input nearest neighbor: **126/143 (88.1%)**.
- RBF coordinate-cluster recovery: **101/143 (70.6%)**.
- Diagnostic using only five known atlas features and integrating four unknown
  features over nearby training contexts: **92/143 (64.3%)**. This route is not
  available in the final questionnaire; it motivated requiring all nine features.

Each fold tunes width and ridge inside its own training partition, using an inner
86/31-style grouped split (sizes vary by fold). The grid is width 0.3, 0.5, 0.8,
1.2, 2, 3 and ridge 0.001, 0.01, 0.1. Selection maximizes inner cluster agreement,
with 0.01 times coordinate RMSE as a tie preference. This small development dataset
has been examined repeatedly; these are validation estimates, not an independent
prospective test or calibrated career-success probabilities. The difference of one
case from nearest neighbor does not establish a statistically meaningful advantage.

After evaluation, the deployed network is refitted on all 143 records with width 2
and ridge 0.1, selected within the historical training partition. Its reported
validation metrics refer to out-of-fold models, not its training fit.

## Actual AWRS-SMC experiment

`specialty-specific/search-nine-atlas.lisp` calls `awrs-smc:run-awrs-smc` with 24
particles, 12 steps, SMC seed 20260908, and terminal potential exp(12 × quality).
It searches nine positive feature weights (0.5, 1, 2), neighbors (10, 15, 20), and
minimum distance (0.05, 0.1, 0.3). All nine features are retained. Each recipe runs
Common Lisp UMAP for 250 epochs at two seeds, 20260905 and 20260917. Only the 117
historical training records enter this search; the 26 holdout records are excluded.

Quality = 0.6 × original-feature neighbor recall at five + 0.3 × two-seed DBSCAN
V-measure + 0.1 × non-noise coverage. Recipes with fewer than two clusters receive
zero quality. Stability is a two-seed diagnostic, not a guarantee of robust clusters.
The reference recipe is evaluated in addition to the 24 sampled alternatives.
The complete constraints, weights, ESS, resampling and proposal telemetry are saved
in `output/candidate-nine-awrs.sexp`; this legal proposal space requires no rejection.

No sampled alternative exceeded the reference recipe: all weights 1, neighbors 15,
minimum distance 0.1. Reference quality was 0.7068, neighbor recall 0.6154, two-seed
cluster stability 0.8046, and coverage 0.9615. Therefore no new atlas replaced the
current map. This is a finite search result, not proof of a global optimum.

## How a candidate is inserted

The browser transforms all nine answer ranges into model inputs and evaluates 128
deterministic Halton samples. The trained cluster head supplies each sample's label;
the coordinate head supplies its position. A sample must lie within the empirical
support radius (1.5 × the 95th percentile of leave-one-out nearest-neighbor distance,
with a 0.5 floor) of a specialty satisfying the training-year range. Noise labels
and clusters without any duration-compatible member are excluded.

One cluster is suggested only if it receives at least 55% of supported sample votes.
Otherwise the interface asks for narrower preferences. The 55% threshold and support
radius are heuristics, not calibrated uncertainty measures. The shown agreement is
range-sampling consistency, not the cross-validation accuracy or career satisfaction.
The optional coordinate marker is the median of supporting predictions; it can lie
outside the suggested cluster because the two output heads have different errors.

## Reproduction

From the project root, with SBCL and no third-party Lisp libraries:

```sh
sbcl --script specialty-specific/run-nine-pipeline.lisp
sbcl --script vendor/test-cases/run-tests.lisp tests/nine-model-tests.lisp
node tests/candidate-nine-tests.cjs
```

To rebuild only the HTML from existing trained/validation artifacts:

```sh
sbcl --script specialty-specific/build-candidate-page.lisp
```

No Python scripts or runtime dependencies are used. Node is only needed for the
JavaScript regression suite. The browser uses the existing D3 CDN dependency;
questionnaire answers remain local and are neither transmitted nor stored.
The older five-feature scripts/model are retained as historical baselines.

## Proposed input adjustments

When the submitted ranges do not produce a cluster, the page searches for a
supported narrowing and displays an original/proposed table with the resulting
cluster. Inputs remain unchanged until **Apply proposed ranges** is clicked;
**Restore original ranges** undoes it. Applying also displays the approximate marker.

The deterministic bounded search tries one-field interval cuts first, favoring
fewer changed fields and then less proportional narrowing. If none succeeds, it
tries up to 24 observed profile anchors clipped to the original ranges, restoring
original intervals where possible. Proposals must pass the existing cluster
majority rule and have at least 25% sampled support. No limits are widened, no
unsupported cluster is fabricated, and the search does not guarantee a globally
minimal adjustment. A proposal is a model-based what-if, not evidence that the
candidate should change their preferences. The system reports when no tested
narrowing yields a supported result.

### Salary is a minimum, not a preferred interval

The salary question now has one visible input: minimum acceptable annual salary,
in thousands of US dollars. A value of 260 means 260k or more, with no upper limit.
The internal compatibility range extends to the highest eligible salary observed
in the atlas. Supporting records must meet the entered minimum. A minimum above
all observed salaries produces an unsupported result rather than being clamped
down. Proposed adjustments never raise or otherwise change the salary minimum.
This supersedes the salary-range description above.
