;;;; Check the deployed model against the atlas after ./spc-setup.x.
(defparameter *placement-root*
  (merge-pathnames "../" (make-pathname :name nil :type nil :defaults *load-truename*)))
(load (merge-pathnames "smc-trainer/transformer.lisp" *placement-root*))
(load (merge-pathnames "smc-trainer/shards.lisp" *placement-root*))

(let* ((artifact (with-open-file (stream (merge-pathnames "smc-trainer/cl-specialty-awrs-model.sexp" *placement-root*))
                   (let ((*read-eval* nil)) (read stream))))
       (model (form-parametric-model (getf artifact :model)))
       (source (parametric-open-corpus-source
                (merge-pathnames "smc-trainer/corpus/specialty-awrs-corpus.sexp" *placement-root*)))
       (records nil)
       (correct 0))
  (parametric-map-records source (lambda (record) (push record records)))
  (assert (= (length records) 143))
  (assert (every (lambda (record) (eq (getf record :split) :train)) records))
  (dolist (record records)
    (let* ((prediction (parametric-predict model (getf record :input)))
           (nearest (first
                     (sort (copy-list records) #'<
                           :key (lambda (candidate)
                                  (let ((target (getf candidate :target)))
                                    (+ (expt (- (first prediction) (first target)) 2)
                                       (expt (- (second prediction) (second target)) 2))))))))
      (when (equal (getf record :cluster) (getf nearest :cluster))
        (incf correct))
      (when (string= (getf record :id) "occupational-and-environmental-medicine")
        (assert (= (getf record :cluster) 2))
        (assert (= (getf nearest :cluster) 2)))))
  (assert (>= correct 130))
  (format t "PASS: primary/emergency/preventive representative in cluster 2; ~D/143 specialties land nearest their atlas cluster.~%" correct))
