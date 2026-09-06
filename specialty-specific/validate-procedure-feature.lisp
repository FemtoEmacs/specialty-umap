;;;; Validate the procedural-practice feature against the specialty universe.

(defun procedure-validation-read (path)
  (with-open-file (stream path)
    (let ((*read-eval* nil) (form (read stream nil :eof)))
      (when (eq form :eof) (error "Empty file: ~A" path))
      form)))

(let* ((here (make-pathname :name nil :type nil :defaults *load-truename*))
       (root (merge-pathnames "../" here))
       (training (procedure-validation-read
                  (merge-pathnames "data/specialty-training-paths.sexpr" root)))
       (feature (procedure-validation-read
                 (merge-pathnames "data/specialty-procedure-profile.sexp" root)))
       (specialties (getf training :specialties))
       (records (getf feature :records))
       (ids (make-hash-table :test #'eq)))
  (unless (= 143 (length specialties) (length records))
    (error "Procedure feature must cover all 143 specialties."))
  (dolist (record records)
    (let ((id (getf record :id))
          (profile (getf record :procedure-profile))
          (intensity (getf record :procedure-intensity)))
      (when (gethash id ids) (error "Duplicate procedure record ~S." id))
      (setf (gethash id ids) t)
      (unless (member profile '(:predominantly-clinical
                                :mixed-procedural-clinical
                                :procedure-dominant))
        (error "Invalid profile for ~S." id))
      (unless (= intensity (ecase profile
                             (:predominantly-clinical 0.0d0)
                             (:mixed-procedural-clinical 0.5d0)
                             (:procedure-dominant 1.0d0)))
        (error "Profile and intensity disagree for ~S." id))))
  (dolist (specialty specialties)
    (unless (gethash (getf specialty :id) ids)
      (error "Missing procedure record for ~S." (getf specialty :id))))
  (format t "PASS procedure feature: 143 records; ~D dominant, ~D mixed, ~D predominantly clinical.~%"
          (count :procedure-dominant records
                 :key (lambda (r) (getf r :procedure-profile)))
          (count :mixed-procedural-clinical records
                 :key (lambda (r) (getf r :procedure-profile)))
          (count :predominantly-clinical records
                 :key (lambda (r) (getf r :procedure-profile)))))
