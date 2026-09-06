;;;; Reproduce search, comparisons, training, validation, and the candidate page.
(defparameter *nine-pipeline-root*
 (merge-pathnames "../" (make-pathname :name nil :type nil :defaults *load-truename*)))
(dolist (script '("evaluate-nine-map.lisp" "search-nine-atlas.lisp" "train-nine-rbf.lisp"
                  "validate-nine-model.lisp" "build-candidate-page.lisp"))
 (format t "~%Running ~A~%" script)
 (let ((process (sb-ext:run-program "sbcl"
                 (list "--script" (namestring (merge-pathnames (concatenate 'string "specialty-specific/" script) *nine-pipeline-root*)))
                 :search t :output *standard-output* :error *error-output* :wait t)))
  (unless (zerop (sb-ext:process-exit-code process)) (error "Pipeline failed at ~A" script))))
