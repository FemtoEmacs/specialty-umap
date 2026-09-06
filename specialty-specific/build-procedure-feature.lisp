;;;; Build an auditable procedural-practice feature for every specialty point.

(defparameter *procedure-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *procedure-root* (merge-pathnames "../" *procedure-directory*))

(defun procedure-read-one (relative)
  (with-open-file (stream (merge-pathnames relative *procedure-root*))
    (let ((*read-eval* nil) (form (read stream nil :eof)))
      (when (eq form :eof) (error "Empty file: ~A" relative))
      (unless (eq (read stream nil :eof) :eof)
        (error "More than one form: ~A" relative))
      form)))

(defparameter *procedure-dominant-specialties*
  '(:anesthesiology :colon-and-rectal-surgery :neurological-surgery
    :obstetrics-and-gynecology :ophthalmology :orthopaedic-surgery
    :otolaryngology-head-and-neck-surgery :plastic-surgery
    :plastic-surgery-integrated :interventional-radiology-independent
    :interventional-radiology-integrated :general-surgery
    :vascular-surgery-integrated :thoracic-surgery-independent
    :thoracic-surgery-integrated :urology
    :adult-cardiothoracic-anesthesiology
    :anesthesiology-critical-care-medicine :obstetric-anesthesiology
    :pain-medicine :pediatric-anesthesiology
    :pediatric-cardiac-anesthesiology
    :regional-anesthesiology-and-acute-pain-medicine
    :micrographic-surgery-and-dermatologic-oncology
    :cardiac-electrophysiology :interventional-cardiology
    :gastroenterology :interventional-pulmonology
    :complex-family-planning :gynecologic-oncology
    :reproductive-endocrinology-and-infertility
    :urogynecology-and-reconstructive-pelvic-surgery
    :ophthalmic-plastic-and-reconstructive-surgery
    :adult-reconstructive-orthopaedics :foot-and-ankle-orthopaedics
    :hand-surgery :musculoskeletal-oncology :orthopaedic-sports-medicine
    :orthopaedic-surgery-of-the-spine :orthopaedic-trauma
    :pediatric-orthopaedics :neurotology :pediatric-otolaryngology
    :craniofacial-surgery :complex-general-surgical-oncology
    :pediatric-surgery :vascular-surgery-independent
    :congenital-cardiac-surgery :pediatric-urology))

(defparameter *mixed-procedural-specialties*
  '(:dermatology :emergency-medicine
    :osteopathic-neuromusculoskeletal-medicine
    :physical-medicine-and-rehabilitation :radiation-oncology
    :diagnostic-radiology :emergency-medical-services
    :pediatric-emergency-medicine :sports-medicine
    :cardiology :adult-congenital-heart-disease
    :advanced-heart-failure-and-transplant-cardiology
    :internal-medicine-critical-care-medicine :pulmonary-disease
    :pulmonary-disease-and-critical-care-medicine
    :maternal-fetal-medicine :neurocritical-care
    :neuromuscular-medicine :pediatric-cardiology
    :pediatric-critical-care-medicine :pediatric-gastroenterology
    :neonatal-perinatal-medicine :brain-injury-medicine
    :spinal-cord-injury-medicine :pediatric-rehabilitation-medicine
    :surgical-critical-care))

(defun procedure-classification (id)
  (cond ((member id *procedure-dominant-specialties*)
         (values :procedure-dominant 1.0d0 :high
                 "Operative or invasive intervention is central to ordinary practice."))
        ((member id *mixed-procedural-specialties*)
         (values :mixed-procedural-clinical 0.5d0 :medium
                 "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures."))
        (t
         (values :predominantly-clinical 0.0d0 :medium
                 "Invasive or operative procedures are not central to ordinary practice."))))

(defun build-procedure-feature ()
  (let* ((training (procedure-read-one "data/specialty-training-paths.sexpr"))
         (specialties (getf training :specialties))
         (output (merge-pathnames "data/specialty-procedure-profile.sexp"
                                  *procedure-root*))
         (list-output (merge-pathnames "output/procedural-specialties.md"
                                       *procedure-root*)))
    (unless (= 143 (length specialties))
      (error "Expected 143 specialties, found ~D." (length specialties)))
    (let ((records
            (mapcar
             (lambda (specialty)
               (multiple-value-bind (profile intensity confidence rationale)
                   (procedure-classification (getf specialty :id))
                 (list :id (getf specialty :id) :name (getf specialty :name)
                       :procedure-profile profile
                       :procedure-intensity intensity
                       :confidence confidence :rationale rationale)))
             specialties)))
      (with-open-file (stream output :direction :output :if-exists :supersede
                                    :if-does-not-exist :create)
        (let ((*print-pretty* t) (*print-length* nil) (*print-level* nil))
          (write
           (list :format :specialty-procedure-profile :version 1
                 :country :united-states :as-of "2026-09-05"
                 :unit :ordinal-procedural-practice-intensity
                 :operational-definition
                 "Extent to which physician-performed operative or invasive procedures are central to ordinary practice; routine examination, image interpretation, laboratory interpretation, and medication administration alone do not qualify."
                 :scale '((:predominantly-clinical 0.0d0)
                          (:mixed-procedural-clinical 0.5d0)
                          (:procedure-dominant 1.0d0))
                 :method :explicit-specialty-review
                 :notes
                 '("This is a practice-content feature, not a billing-volume estimate."
                   "Individual physicians can have a different practice mix from their specialty category."
                   "Mixed and disputed classifications are intentionally retained rather than forced into a binary label.")
                 :records records)
           :stream stream)
          (terpri stream)))
      (ensure-directories-exist list-output)
      (with-open-file (stream list-output :direction :output :if-exists :supersede
                                         :if-does-not-exist :create)
        (format stream "# Specialties with procedures~%~%")
        (format stream "Operational definition: physician-performed operative or invasive procedures are central or common in ordinary practice. Routine examination, image/laboratory interpretation, and medication administration alone are excluded.~%~%")
        (dolist (section '((:procedure-dominant "Procedure-dominant")
                           (:mixed-procedural-clinical "Mixed procedural and clinical")))
          (format stream "## ~A~%~%" (second section))
          (dolist (record records)
            (when (eq (getf record :procedure-profile) (first section))
              (format stream "- ~A~%" (getf record :name))))
          (terpri stream)))
      (format t "Wrote ~D procedure-profile records: ~D dominant, ~D mixed, ~D predominantly clinical.~%"
              (length records)
              (count :procedure-dominant records :key (lambda (r) (getf r :procedure-profile)))
              (count :mixed-procedural-clinical records :key (lambda (r) (getf r :procedure-profile)))
              (count :predominantly-clinical records :key (lambda (r) (getf r :procedure-profile)))))))

(build-procedure-feature)
