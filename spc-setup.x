#!/usr/bin/env -S sbcl --script
;;;; Complete specialty pipeline. Requires only SBCL and a browser to view HTML.
;;;; Overrides: SPC_EPOCHS (100), SPC_LR (0.002d0), SPC_FORCE_BASE_MAP (0), SBCL.
(let* ((root (make-pathname :name nil :type nil :defaults *load-truename*))
       (*default-pathname-defaults* root)
       (sbcl (or (sb-ext:posix-getenv "SBCL") (namestring sb-ext:*runtime-pathname*)))
       (epochs (or (sb-ext:posix-getenv "SPC_EPOCHS") "100"))
       (rate (or (sb-ext:posix-getenv "SPC_LR") "0.002d0"))
       (result "output/specialty-awrs-smc-result.sexp")
       (corpus "smc-trainer/corpus/specialty-awrs-corpus.sexp")
       (model "smc-trainer/cl-specialty-awrs-model.sexp")
       (html "output/cl-specialty-awrs-preferences.html"))
  (labels ((run-stage (description script &rest arguments)
             (format t "~%==> ~A~%" description)
             (finish-output)
             (let* ((process (sb-ext:run-program
                              sbcl (append (list "--script" script) arguments)
                              :search t :directory root
                              :input t :output t :error t :wait t))
                    (code (sb-ext:process-exit-code process)))
               (unless (eql code 0)
                 (error "Stage ~A failed with exit code ~S." description code)))))
    (when (or (equal (sb-ext:posix-getenv "SPC_FORCE_BASE_MAP") "1")
              (not (probe-file (merge-pathnames "output/specialty-umap-embedding.csv" root)))
              (not (probe-file (merge-pathnames "output/specialty-umap.html" root))))
      (run-stage "[1/5] Base map" "specialty-specific/build-specialty-umap.lisp"))
    (run-stage "[2/5] AWRS-SMC search" "awrs-smc/search-umap.lisp"
               "specialty-specific/specialty-awrs-smc-search.sexp" result)
    (run-stage "[3/5] Build corpus" "smc-trainer/build-corpus.lisp" result corpus)
    (run-stage "Validate corpus" "smc-trainer/validate-corpus.lisp" corpus)
    (run-stage "[4/5] Train Transformer" "smc-trainer/train.lisp" corpus model epochs rate)
    (run-stage "[5/5] Generate formatted HTML"
               "specialty-specific/build-preferences-page.lisp" corpus model html)
    (format t "~%Done. Open: ~A~%" (merge-pathnames html root))))
