(defparameter *candidate-run-main* nil)
(load (merge-pathnames "../specialty-specific/train-candidate-map.lisp" (make-pathname :name nil :type nil :defaults *load-truename*)))
(test-cases:deftest fixed-atlas-supervision
  (let* ((rows (candidate-observations))
         (artifact (read-form-file (candidate-path "smc-trainer/candidate-fixed-atlas-model.sexp"))))
    (test-cases:check-equal 143 (length rows))
    (test-cases:check-equal rows (mapcar (lambda (r) (subseq r 0 10)) (getf artifact :observations)))
    (dolist (r rows) (test-cases:check-equal 5 (length (getf r :input))))))
(test-cases:deftest grouped-split-no-duplicate-leakage
  (let ((rows (candidate-split (candidate-observations))))
    (dolist (a rows) (dolist (b rows)
      (when (equal (getf a :input) (getf b :input))
        (test-cases:check-equal (getf a :split) (getf b :split)))))))
(test-cases:deftest training-only-normalization
  (let* ((artifact (read-form-file (candidate-path "smc-trainer/candidate-fixed-atlas-model.sexp")))
         (rows (remove :validation (getf artifact :observations) :key (lambda (r) (getf r :split))))
         (stats (getf artifact :preprocessing)))
    (loop for j below 5 do
      (test-cases:check (< (abs (/ (loop for r in rows sum (nth j (candidate-normalize (getf r :input) stats))) (length rows))) 1d-10)))))
(test-cases:deftest normalization-roundtrip
  (let ((stats '(:means (2d0 -3d0) :scales (0.5d0 4d0))))
    (loop for i from -10 to 10 for v = (list (float i 1d0) (* i 2d0)) do
      (test-cases:check-equal v (candidate-denormalize (candidate-normalize v stats) stats)))))
(test-cases:deftest rejects-invalid-science-feature
  (test-cases:check-signals error (candidate-features '(:representative-total-gme-years -1))))
(test-cases:deftest trained-model-finite-and-beats-mean
  (let* ((a (read-form-file (candidate-path "smc-trainer/candidate-fixed-atlas-model.sexp")))
         (model (form-parametric-model (getf a :model))))
    (test-cases:check (< (getf (getf a :evaluation) :coordinate-rmse) (getf (getf a :evaluation) :mean-baseline-rmse)))
    (dolist (r (getf a :observations))
      (let ((prediction (parametric-predict model (candidate-normalize (getf r :input) (getf a :preprocessing)))))
        (test-cases:check-equal 2 (length prediction))
        (test-cases:check (every (lambda (v) (and (= v v) (< (abs v) 1d6))) prediction))))))
