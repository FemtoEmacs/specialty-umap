;;;; Build an interactive page where a person enters their own standardized
;;;; feature preferences and sees, live in the browser, where the trained
;;;; Transformer (smc-trainer/transformer.lisp) places that point in the
;;;; AWRS-SMC atlas -- a genuine test surface for the new architecture,
;;;; distinct from smc-trainer/demo/build-demo.lisp's fixed illustrative
;;;; points.
;;;;
;;;; This lives in specialty-specific/, not smc-trainer/demo/, because
;;;; *PREFERENCES-RAW-FEATURE-MAP* below is specific to the medical-specialty
;;;; corpus; smc-trainer/demo/ is reserved for demonstrations that are
;;;; genuinely domain-independent (shared byte-for-byte with the stkumap
;;;; checkout, the way build-demo.lisp is). The stock counterpart is
;;;; stk-specific/stock-build-preferences-page.lisp.
;;;;
;;;; The page embeds the full trained model as JSON and runs a JavaScript
;;;; port of TRANSFORMER-FORWARD client-side (inference only; no autodiff is
;;;; needed in the browser). The port is written to mirror
;;;; smc-trainer/transformer.lisp function-by-function so it can be audited
;;;; side by side, and its output is meant to be cross-checked against
;;;; smc-trainer/predict.lisp on the same input as a correctness check.

(defparameter *preferences-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *preferences-root* (merge-pathnames "../" *preferences-directory*))
(defparameter *build-umap-run-main* nil)
(load (merge-pathnames "build-umap.lisp" *preferences-root*))
(defparameter *parametric-predict-run-main* nil)
(load (merge-pathnames "smc-trainer/predict.lisp" *preferences-root*))
(unless (fboundp 'parametric-open-corpus-source)
  (load (merge-pathnames "smc-trainer/shards.lisp" *preferences-root*)))

(defun preferences-json-text (value)
  (with-output-to-string (stream) (write-json-pretty value stream)))

(defun preferences-source-records (source)
  (let ((records nil))
    (parametric-map-records source (lambda (record) (push record records)))
    (nreverse records)))

(defun preferences-atlas-points (records raw-header raw-rows)
  "Like PREFERENCES-SOURCE-RECORDS's per-record summary, but also carries each
specialty's raw average compensation, looked up from the same raw CSV
PREFERENCES-FEATURE-INFO reads, via the column named by the SALARY-Z entry in
*PREFERENCES-RAW-FEATURE-MAP* below (average_total_compensation_usd,
hardcoded here rather than looked up through that table, since this function
is defined -- and can be called -- before that table's DEFPARAMETER runs),
so the browser tooltip can show salary without a second per-point CSV join."
  (let* ((id-index (csv-column-index raw-header "specialty_id"))
         (salary-index (csv-column-index raw-header "average_total_compensation_usd"))
         (salary-by-id (make-hash-table :test #'equal)))
    (dolist (row raw-rows)
      (setf (gethash (nth id-index row) salary-by-id)
            (csv-parse-double (nth salary-index row))))
    (loop for record in records collect
      (list :id (getf record :id) :group (getf record :group)
            :label (getf record :label) :cluster (getf record :cluster)
            :x (first (getf record :target)) :y (second (getf record :target))
            :salary (gethash (getf record :id) salary-by-id)))))

;;; ---- Raw-unit sliders -----------------------------------------------
;;;
;;; Lookup values are the final corpus inputs, including the selected feature
;;; transforms and normalization. Training duration uses minimum years, matching
;;; build-specialty-point-csv.lisp. Reject ambiguous raw-value mappings.

(defparameter *preferences-raw-feature-map*
  ;; corpus feature name -> (csv-column display-label unit decimals step)
  ;; STEP is NIL for "pick a smooth default step from the observed range";
  ;; a number forces the slider (and displayed value) to move in exactly
  ;; that increment -- e.g. whole years, since nobody trains for 5.3 years.
  '(("TRAINING-DURATION-Z" "minimum_total_gme_years"
     "Minimum training duration" "years" 0 1)
    ("CLINICAL-WORK-INTENSITY-Z" "task_wrvu_per_total_physician_hour"
     "Clinical work intensity" "wRVU per physician-hour" 2 nil)
    ;; SCIENTIFIC-ACTIVITY-INDEX-Z is the mean of two separately
    ;; log-standardized raw quantities (NIH grants/physician/year and NIH
    ;; funding/physician/year, see data/specialty-scientific-activity.sexpr
    ;; and specialty-specific/CANDIDATE-MAP.md), so there is no single exact
    ;; raw<->z inverse the way there is for e.g. SALARY-Z. As with every
    ;; other feature here, this does not need an exact inverse: it only
    ;; needs one representative raw column paired with this corpus's own
    ;; (raw, z) values per specialty, which PREFERENCES-FEATURE-INFO turns
    ;; into an empirical, monotonic-in-practice interpolation table just
    ;; like the rest. NIH funding (dollars) was chosen over the grants-count
    ;; column as the more intuitive slider unit; both are highly correlated
    ;; components of the same composite.
    ("SCIENTIFIC-ACTIVITY-INDEX-Z"
     "nih_funding_thousand_usd_per_active_physician_per_year"
     "Scientific activity (NIH funding)" "$k NIH funding per physician/year"
     1 nil)
    ("PRIVATE-PRACTICE-Z" "private_practice_percent"
     "Private practice" "%" 1 nil)
    ("SALARY-Z" "average_total_compensation_usd"
     "Average compensation" "$/year" 0 1000)
    ("WORKFORCE-BURDEN-Z" "physicians_per_1000_relevant_patients"
     "Workforce burden" "physicians per 1,000 patients" 2 nil)
    ("COMPETITIVENESS-Z" "candidates_per_position"
     "NRMP competitiveness" "candidates per position" 2 nil)
    ("FEMALE-REPRESENTATION-Z" "female_resident_percent"
     "Female representation" "%" 1 nil)
    ("PROCEDURE-INTENSITY-Z" "procedure_intensity"
     "Procedure intensity (0 = clinic-only, 1 = procedure-dominant)" "" 2 nil)))

(defun csv-split-line (line)
  "Split one CSV line into fields, honoring double-quoted fields. Adequate
for this project's data (no embedded commas inside quoted fields)."
  (let ((fields nil) (field-start 0) (in-quotes nil))
    (loop for i from 0 below (length line)
          for ch = (char line i)
          do (cond
               ((char= ch #\") (setf in-quotes (not in-quotes)))
               ((and (char= ch #\,) (not in-quotes))
                (push (subseq line field-start i) fields)
                (setf field-start (1+ i))))
          finally (push (subseq line field-start (length line)) fields))
    (nreverse (mapcar (lambda (field) (remove #\" field)) fields))))

(defun read-csv-table (path)
  "Return (values HEADER ROWS): HEADER a list of column-name strings, ROWS a
list of field-lists, one per non-blank data row."
  (with-open-file (stream path :direction :input)
    (let ((header (csv-split-line (read-line stream)))
          (rows nil))
      (loop for line = (read-line stream nil nil)
            while line
            unless (zerop (length line))
              do (push (csv-split-line line) rows))
      (values header (nreverse rows)))))

(defun csv-column-index (header name)
  (or (position name header :test #'string=)
      (error "CSV column ~S not found (have ~S)." name header)))

(defun csv-parse-double (text)
  (let ((*read-default-float-format* 'double-float))
    (coerce (read-from-string text) 'double-float)))

(defun preferences-unique-pairs (pairs name)
  "Require a single model input for each raw slider value."
  (let ((result nil))
    (dolist (pair (sort (copy-list pairs) #'< :key #'car) (nreverse result))
      (if (and result (= (caar result) (car pair)))
          (unless (< (abs (- (cdar result) (cdr pair))) 1.0d-8)
            (error "Conflicting raw-to-model values for ~A at ~A." name (car pair)))
          (push pair result)))))

(defun preferences-feature-info (records feature-schema raw-header raw-rows)
  "One entry per feature: display label/unit, the observed raw-unit
min/max/mean across all records (for slider bounds and the reset value),
and a RAW<->Z lookup table (sorted by raw value) the browser interpolates
through so a person can enter years/dollars/percent while the model still
receives the z-scored value it was trained on."
  (let ((id-index (csv-column-index raw-header "specialty_id")))
    (loop for declared in feature-schema for column from 0 collect
      (let* ((name (string (getf declared :name)))
             (entry (or (assoc name *preferences-raw-feature-map* :test #'string=)
                        (error "No raw-unit mapping declared for feature ~A." name)))
             (csv-column-name (second entry))
             (label (third entry))
             (unit (fourth entry))
             (decimals (fifth entry))
             (forced-step (sixth entry))
             (value-index (csv-column-index raw-header csv-column-name))
             (raw-by-id (make-hash-table :test #'equal)))
        (dolist (row raw-rows)
          (setf (gethash (nth id-index row) raw-by-id)
                (csv-parse-double (nth value-index row))))
        (let* ((pairs (loop for record in records
                            for id = (getf record :id)
                            for raw-value = (gethash id raw-by-id)
                            when raw-value
                              collect (cons raw-value (nth column (getf record :input)))))
               (sorted (preferences-unique-pairs pairs name)))
          (unless sorted
            (error "No raw-CSV matches (by specialty_id) for feature ~A." name))
          (let* ((raw-values (mapcar #'car sorted))
                 (raw-min (reduce #'min raw-values))
                 (raw-max (reduce #'max raw-values))
                 (raw-mean-exact (/ (reduce #'+ raw-values) (length raw-values)))
                 (raw-mean (if forced-step
                               (* forced-step (round raw-mean-exact forced-step))
                               raw-mean-exact)))
            (list :name (string-downcase name)
                  :label label
                  :unit unit
                  :decimals decimals
                  :step (or forced-step (/ (- raw-max raw-min) 200))
                  :raw-min raw-min :raw-max raw-max :raw-mean raw-mean
                  :points (mapcar (lambda (pair) (list (car pair) (cdr pair)))
                                  sorted))))))))

(defun raw-feature-vector (id feature-schema raw-header raw-rows)
  "The list of raw (real-world-unit) values for specialty ID, one per
FEATURE-SCHEMA entry in order, using the same column mapping as
PREFERENCES-FEATURE-INFO. Used to seed all the sliders at once from one
named specialty."
  (let* ((id-index (csv-column-index raw-header "specialty_id"))
         (row (find id raw-rows :key (lambda (r) (nth id-index r)) :test #'string=)))
    (unless row
      (error "No raw-CSV row for specialty ~S." id))
    (loop for declared in feature-schema
          for name = (string (getf declared :name))
          for entry = (or (assoc name *preferences-raw-feature-map* :test #'string=)
                          (error "No raw-unit mapping for ~A." name))
          for value-index = (csv-column-index raw-header (second entry))
          collect (csv-parse-double (nth value-index row)))))

(defun preferences-cluster-summaries (atlas records feature-schema raw-header raw-rows)
  "Representatives carry raw values and corpus inputs for verification.
Browser selection uses the same raw-value conversion as slider movement."
  (let ((by-cluster (make-hash-table :test #'eql))
        (record-by-id (make-hash-table :test #'equal)))
    (dolist (record records)
      (setf (gethash (getf record :id) record-by-id) record))
    (dolist (point atlas)
      (push point (gethash (getf point :cluster) by-cluster)))
    (loop for cluster being the hash-keys of by-cluster using (hash-value members)
          collect
      (let* ((count (length members))
             (cx (/ (reduce #'+ members :key (lambda (p) (getf p :x))) count))
             (cy (/ (reduce #'+ members :key (lambda (p) (getf p :y))) count))
             (nearest (first (sort (copy-list members) #'<
                                   :key (lambda (p)
                                          (+ (expt (- (getf p :x) cx) 2)
                                             (expt (- (getf p :y) cy) 2))))))
             (nearest-id (getf nearest :id))
             (nearest-record (or (gethash nearest-id record-by-id)
                                 (error "No corpus record for specialty ~S." nearest-id))))
        (list :cluster cluster
              :name nearest-id
              :x (getf nearest :x) :y (getf nearest :y)
              :raw-values (raw-feature-vector nearest-id feature-schema
                                              raw-header raw-rows)
              :z-values (getf nearest-record :input))))))

(defun preferences-model-json-plist (model)
  "Export every parameter tensor MODEL needs for inference, under explicit
names a JavaScript port can look up directly -- deliberately not the
positional :PARAMETERS list transformer.lisp uses for its own serialization,
so the browser-side port does not depend on group ordering."
  (ecase (parametric-model-kind model)
    (:multi-head-stack
     (list :kind "multi-head-stack"
           :d-model (parametric-model-d-model model)
           :d-ff (parametric-model-d-ff model)
           :num-heads (parametric-model-num-heads model)
           :num-layers (parametric-model-num-layers model)
           :feature-count (parametric-model-feature-count model)
           :feature-embeddings (trainer-values (parametric-model-feature-embeddings model))
           :scalar-weights (trainer-values (parametric-model-scalar-weights model))
           :scalar-bias (trainer-values (parametric-model-scalar-bias model))
           :layer-heads-wq (trainer-values (parametric-model-layer-heads-wq model))
           :layer-heads-wk (trainer-values (parametric-model-layer-heads-wk model))
           :layer-heads-wv (trainer-values (parametric-model-layer-heads-wv model))
           :layer-wo (trainer-values (parametric-model-layer-wo model))
           :layer-attention-gain (trainer-values (parametric-model-layer-attention-gain model))
           :layer-w1 (trainer-values (parametric-model-layer-w1 model))
           :layer-b1 (trainer-values (parametric-model-layer-b1 model))
           :layer-w2 (trainer-values (parametric-model-layer-w2 model))
           :layer-b2 (trainer-values (parametric-model-layer-b2 model))
           :layer-ffn-gain (trainer-values (parametric-model-layer-ffn-gain model))
           :final-norm-gain (trainer-values (parametric-model-final-norm-gain model))
           :output-weights (trainer-values (parametric-model-output-weights model))
           :output-bias (trainer-values (parametric-model-output-bias model))))
    (:legacy-single-head
     (list :kind "legacy-single-head"
           :d-model (parametric-model-d-model model)
           :d-ff (parametric-model-d-ff model)
           :feature-count (parametric-model-feature-count model)
           :feature-embeddings (trainer-values (parametric-model-feature-embeddings model))
           :scalar-weights (trainer-values (parametric-model-scalar-weights model))
           :scalar-bias (trainer-values (parametric-model-scalar-bias model))
           :wq (trainer-values (parametric-model-wq model))
           :wk (trainer-values (parametric-model-wk model))
           :wv (trainer-values (parametric-model-wv model))
           :wo (trainer-values (parametric-model-wo model))
           :w1 (trainer-values (parametric-model-w1 model))
           :b1 (trainer-values (parametric-model-b1 model))
           :w2 (trainer-values (parametric-model-w2 model))
           :b2 (trainer-values (parametric-model-b2 model))
           :output-weights (trainer-values (parametric-model-output-weights model))
           :output-bias (trainer-values (parametric-model-output-bias model))))))

(defun build-preferences-page (corpus-name weights-name output-name)
  (let* ((source (parametric-open-corpus-source corpus-name))
         (records (preferences-source-records source))
         (metadata (parametric-source-metadata source))
         (feature-schema (getf metadata :feature-schema))
         (artifact (predict-read-form weights-name))
         (model (form-parametric-model (getf artifact :model)))
         (raw-csv-path (merge-pathnames "examples/specialty-points-raw.csv"
                                        *preferences-root*)))
    (multiple-value-bind (raw-header raw-rows) (read-csv-table raw-csv-path)
     (let* ((atlas (preferences-atlas-points records raw-header raw-rows))
         (features (preferences-feature-info records feature-schema
                                                 raw-header raw-rows))
         (clusters (preferences-cluster-summaries atlas records feature-schema
                                                   raw-header raw-rows))
         (model-json (preferences-model-json-plist model))
         (template (file-text (merge-pathnames "preferences-template.html"
                                               *preferences-directory*)))
         (page (replace-marker
                (replace-marker
                 (replace-marker
                  (replace-marker template "__ATLAS_POINTS__"
                                 (preferences-json-text atlas))
                  "__FEATURES__" (preferences-json-text features))
                 "__CLUSTERS__" (preferences-json-text clusters))
                "__MODEL__" (preferences-json-text model-json))))
    (ensure-directories-exist output-name)
    (with-open-file (stream output-name :direction :output :if-exists :supersede
                                        :if-does-not-exist :create)
      (write-string page stream))
    (format t "Wrote ~D atlas points, ~D features, ~D clusters, model kind ~S to ~A.~%"
            (length atlas) (length features) (length clusters)
            (getf model-json :kind) output-name)))))

(defvar *preferences-run-main* t)
(when *preferences-run-main*
(let ((arguments (cdr sb-ext:*posix-argv*)))
  (unless (= (length arguments) 3)
    (error "Usage: sbcl --script specialty-specific/build-preferences-page.lisp CORPUS WEIGHTS OUTPUT.html"))
  (apply #'build-preferences-page arguments)))
