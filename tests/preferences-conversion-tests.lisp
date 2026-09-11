;;;; Standalone Common Lisp regression check; no external dependencies.
(defparameter *preferences-run-main* nil)
(load (merge-pathnames "../specialty-specific/build-preferences-page.lisp"
                       *load-truename*))
(let* ((source (parametric-open-corpus-source
                (merge-pathnames "smc-trainer/corpus/specialty-awrs-corpus.sexp"
                                 *preferences-root*)))
       (records (preferences-source-records source))
       (schema (getf (parametric-source-metadata source) :feature-schema))
       (checks 0))
  (multiple-value-bind (header rows)
      (read-csv-table (merge-pathnames "examples/specialty-points-raw.csv"
                                      *preferences-root*))
    (let ((features (preferences-feature-info records schema header rows)))
      (dolist (record records)
        (loop for raw in (raw-feature-vector (getf record :id) schema header rows)
              for expected in (getf record :input)
              for feature in features
              for pair = (assoc raw (getf feature :points) :test #'=)
              do (assert pair)
                 (assert (< (abs (- (second pair) expected)) 1.0d-8))
                 (incf checks)))))
  (assert (handler-case
              (progn (preferences-unique-pairs '((1d0 . 2d0) (1d0 . 3d0)) "test") nil)
            (error () t)))
  (format t "PASS: ~D raw-to-model checks across ~D records; conflicting pairs rejected.~%"
          checks (length records)))
