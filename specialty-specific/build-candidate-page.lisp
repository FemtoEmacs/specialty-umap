;;;; Embed the trained model and a compact questionnaire in the preserved atlas.
(defparameter *candidate-run-main* nil)
(load (merge-pathnames "train-candidate-map.lisp" (make-pathname :name nil :type nil :defaults *load-truename*)))
(defun candidate-build-page ()
  (let* ((artifact (read-form-file (candidate-path "smc-trainer/candidate-fixed-atlas-model.sexp")))
         (current (candidate-observations)))
    (unless (equal current (mapcar (lambda (r) (subseq r 0 10)) (getf artifact :observations)))
      (error "The atlas or feature data changed. Retrain before building the candidate page."))
    (build-umap-html (candidate-path "specialty-problem.sexpr") (candidate-path "output/specialty-candidate.html"))
    (let* ((page (file-text (candidate-path "output/specialty-candidate.html")))
           (css "#candidate-panel{margin:14px 0;padding:12px;border:1px solid #ccc;border-radius:6px}#candidate-panel summary{cursor:pointer;font-weight:600}.candidate-fields{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:10px}.candidate-fields fieldset{border:1px solid #ddd;min-width:0}.candidate-fields input{width:65px;margin:5px}.candidate-fields small{display:block;color:#555}#candidate-form button{margin:10px 10px 0 0}#candidate-quality{font-size:12px;color:#555}")
           (code (concatenate 'string (file-text (candidate-path "src/candidate-engine.js"))
                              (format nil "~%const candidateArtifact=~A;~%" (with-output-to-string (s) (write-json artifact s)))
                              (file-text (candidate-path "src/candidate-ui.js")))))
      (setf page (replace-marker page "</style>" (concatenate 'string css "</style>"))
            page (replace-marker page "      <svg role=\"img\"></svg>" (concatenate 'string (file-text (candidate-path "src/candidate-panel.html")) "<svg role=\"img\"></svg>"))
            page (replace-marker page "      select.addEventListener(\"change\", draw);" (concatenate 'string code "      select.addEventListener(\"change\", draw);"))
            page (replace-marker page "        root.querySelector(\".ramp\").style.background" "        drawCandidateOverlay(x, y);
        root.querySelector(\".ramp\").style.background")
            page (replace-marker page "      layoutSelect.add(new Option(\"Recompute with umap-js\", \"umap-js\"));" "      // Candidate predictions use only the preserved atlas.
      layoutSelect.disabled = true;"))
      (with-open-file (s (candidate-path "output/specialty-candidate.html") :direction :output :if-exists :supersede)
        (write-string page s))
      ;; JSON fixtures also let the browser forward pass be checked against Lisp.
      (let* ((model (form-parametric-model (getf artifact :model)))
             (fixtures (loop for row in (getf artifact :observations) collect
                         (list :input (getf row :input) :expected
                           (candidate-denormalize (parametric-predict model (candidate-normalize (getf row :input) (getf artifact :preprocessing))) (getf artifact :target-preprocessing))))))
        (with-open-file (s (candidate-path "output/candidate-model.json") :direction :output :if-exists :supersede)
          (write-json (list :artifact artifact :fixtures fixtures) s))))))
(candidate-build-page)
