#!/usr/bin/env sbcl --script

;;; Expand the AMA's 2024 practice-ownership categories to the 143-point
;;; specialty universe. Low-confidence estimates remain enabled for UMAP.

(defparameter *root* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *training-file* (merge-pathnames "../data/specialty-training-paths.sexpr" *root*))
(defparameter *output-file* (merge-pathnames "../data/private-practice.sexp" *root*))

(defun read-one (path)
  (with-open-file (stream path :direction :input) (read stream)))

(defun contains-p (needle keyword)
  (search needle (string-downcase (symbol-name keyword))))

(defparameter *ama-categories*
  '((:id :cardiology :label "Cardiology" :private-practice-percent 30.7)
    (:id :general-surgery :label "General surgery" :private-practice-percent 31.7)
    (:id :emergency-medicine :label "Emergency medicine" :private-practice-percent 33.2)
    (:id :pediatrics :label "Pediatrics" :private-practice-percent 38.1)
    (:id :internal-medicine :label "Internal medicine" :private-practice-percent 38.9)
    (:id :internal-medicine-subspecialties :label "Internal medicine subspecialties" :private-practice-percent 39.2)
    (:id :family-medicine :label "Family medicine" :private-practice-percent 42.2)
    (:id :all-physicians :label "All physicians" :private-practice-percent 42.2)
    (:id :other :label "Other" :private-practice-percent 43.6)
    (:id :psychiatry :label "Psychiatry" :private-practice-percent 45.2)
    (:id :obstetrics-gynecology :label "Obstetrics/gynecology" :private-practice-percent 46.3)
    (:id :anesthesiology :label "Anesthesiology" :private-practice-percent 46.4)
    (:id :radiology :label "Radiology" :private-practice-percent 46.9)
    (:id :surgical-subspecialties :label "Other surgical subspecialties" :private-practice-percent 51.2)
    (:id :orthopaedic-surgery :label "Orthopedic surgery" :private-practice-percent 54.0)
    (:id :ophthalmology :label "Ophthalmology" :private-practice-percent 70.4)))

(defun category-for (id)
  (cond
    ((or (eq id :anesthesiology) (contains-p "anesthesiology" id)) :anesthesiology)
    ((or (eq id :ophthalmology) (contains-p "ophthalmic" id)) :ophthalmology)
    ((or (eq id :orthopaedic-surgery) (contains-p "orthopaedic" id)
         (contains-p "hand-surgery" id)) :orthopaedic-surgery)
    ((or (eq id :diagnostic-radiology) (contains-p "interventional-radiology" id)
         (contains-p "abdominal-radiology" id) (contains-p "musculoskeletal-radiology" id)
         (contains-p "neuroradiology" id) (contains-p "nuclear-radiology" id)
         (contains-p "pediatric-radiology" id)) :radiology)
    ((or (eq id :obstetrics-and-gynecology) (contains-p "gynec" id)
         (contains-p "obstetric" id) (contains-p "maternal-fetal" id)
         (contains-p "family-planning" id) (contains-p "reproductive" id)) :obstetrics-gynecology)
    ((or (eq id :psychiatry) (contains-p "psychiatr" id)) :psychiatry)
    ((eq id :cardiology) :cardiology)
    ((or (contains-p "cardiology" id) (contains-p "cardiac-electrophysiology" id)
         (contains-p "adult-congenital-heart" id)) :cardiology)
    ((eq id :general-surgery) :general-surgery)
    ((or (eq id :neurological-surgery) (eq id :colon-and-rectal-surgery)
         (eq id :otolaryngology-head-and-neck-surgery) (eq id :urology)
         (eq id :plastic-surgery) (eq id :plastic-surgery-integrated)
         (contains-p "surgery" id) (contains-p "surgical" id)
         (contains-p "urolog" id) (contains-p "otolaryng" id)
         (contains-p "neurotology" id) (contains-p "craniofacial" id))
     :surgical-subspecialties)
    ((eq id :emergency-medicine) :emergency-medicine)
    ((or (contains-p "emergency-medical-services" id)
         (contains-p "medical-toxicology" id)
         (contains-p "undersea-and-hyperbaric" id)) :emergency-medicine)
    ((eq id :pediatrics) :pediatrics)
    ((or (contains-p "pediatric" id) (contains-p "adolescent" id)
         (contains-p "neonatal" id) (contains-p "child-abuse" id)
         (contains-p "developmental-behavioral" id)) :pediatrics)
    ((eq id :internal-medicine) :internal-medicine)
    ((eq id :family-medicine) :family-medicine)
    ((eq id :internal-medicine-pediatrics) :all-physicians)
    ((or (eq id :allergy-and-immunology) (eq id :geriatric-medicine)
         (eq id :hospice-and-palliative-medicine) (eq id :sleep-medicine)
         (contains-p "heart-failure" id) (contains-p "critical-care" id)
         (contains-p "endocrinology" id) (contains-p "gastroenterology" id)
         (contains-p "hematology" id) (contains-p "infectious" id)
         (contains-p "medical-oncology" id) (contains-p "nephrology" id)
         (contains-p "pulmonary" id) (contains-p "rheumatology" id)
         (contains-p "hepatology" id)) :internal-medicine-subspecialties)
    (t :other)))

(defun direct-category-p (id category)
  (case category
    (:obstetrics-gynecology (eq id :obstetrics-and-gynecology))
    (:radiology (eq id :diagnostic-radiology))
    (otherwise (eq id category))))

(defun estimate-status (id category)
  (cond
    ((direct-category-p id category) (values :observed-category :high))
    ((eq category :other) (values :estimated-from-other-category :low))
    ((eq category :all-physicians) (values :estimated-from-overall-rate :low))
    ((and (eq id :pediatric-emergency-medicine)
          (member category '(:pediatrics :emergency-medicine)))
     (values :ambiguous-multidisciplinary-crosswalk :low))
    (t (values :group-category-crosswalk :medium))))

(defun category-row (id)
  (or (find id *ama-categories* :key (lambda (row) (getf row :id)))
      (error "Missing AMA category ~S" id)))

(let* ((training (read-one *training-file*))
       (points (getf training :specialties))
       (records
         (mapcar
          (lambda (point)
            (let* ((id (getf point :id))
                   (category (category-for id))
                   (source (category-row category)))
              (multiple-value-bind (basis confidence) (estimate-status id category)
                (list :id id
                      :name (getf point :name)
                      :private-practice-percent (getf source :private-practice-percent)
                      :confidence confidence
                      :basis basis
                      :source-category category
                      :umap-use t))))
          points))
       (document
         (list
          :format :specialty-private-practice-feature
          :version 2
          :country :united-states
          :survey-year 2024
          :point-key :id
          :feature
          '(:id :private-practice-percent
            :label "Physicians in practices wholly owned by physicians"
            :unit :percent
            :range (0.0 100.0)
            :umap-use :all-records-including-low-confidence
            :recommended-transform :z-score
            :confidence-weighting :none)
          :source
          '(:publisher "American Medical Association"
            :author "Carol K. Kane"
            :title "Physician Practice Characteristics in 2024: Private Practices Account for Less Than Half of Physicians in Most Specialties"
            :url "https://www.ama-assn.org/system/files/2024-prp-pp-characteristics.pdf"
            :exhibit 2
            :sample-size 5000
            :specialty-minimum-n 100
            :survey-period "late August through late September 2024"
            :response-rate-percent 43
            :retrieved "2026-09-05")
          :definition-notes
          '("Private practice means a practice wholly owned by one or more physicians in the practice."
            "It does not mean solo practice, practice ownership by the individual respondent, or merely a non-hospital work site."
            "Survey estimates are weighted to represent eligible US patient-care physicians; federal employees and physicians providing under 20 patient-care hours per week are excluded."
            "High confidence denotes an ACGME point directly matching a plotted AMA category."
            "Medium confidence denotes a subspecialty assigned to an explicitly plotted AMA grouped or parent category."
            "Low confidence denotes a best-available guess using the AMA overall or Other category where membership is not published."
            "Per user instruction, every record including low-confidence estimates is enabled for UMAP without confidence weighting.")
          :source-categories *ama-categories*
          :specialties records)))
  (with-open-file (stream *output-file* :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (let ((*print-pretty* t) (*print-right-margin* 112) (*print-case* :downcase))
      (prin1 document stream) (terpri stream)))
  (format t "Wrote ~D private-practice records to ~A~%"
          (length records) (namestring *output-file*)))
