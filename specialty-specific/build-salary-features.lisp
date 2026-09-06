#!/usr/bin/env sbcl --script

;;; Expand Marit's physician salary categories to the 143 specialty points.
;;; The source distinguishes Oncology from Hematology Oncology; this builder
;;; preserves those as separate direct observations.

(defparameter *root* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *training-file* (merge-pathnames "../data/specialty-training-paths.sexpr" *root*))
(defparameter *output-file* (merge-pathnames "../data/salaries.sexp" *root*))

(defun read-one (path)
  (with-open-file (stream path :direction :input) (read stream)))
(defun contains-p (needle keyword)
  (search needle (string-downcase (symbol-name keyword))))

(defparameter *marit-salaries*
  '((:id :allergy-and-immunology :label "Allergy & Immunology" :average-total-compensation-usd 368000 :url-path "/o/-/allergist/salary")
    (:id :anesthesiology :label "Anesthesiology" :average-total-compensation-usd 570000 :url-path "/o/-/anesthesiologist/salary")
    (:id :bariatric-medicine :label "Bariatric Medicine" :average-total-compensation-usd 359000 :point-universe :not-present)
    (:id :cardiology :label "Cardiology" :average-total-compensation-usd 634000 :url-path "/o/-/cardiologist/salary")
    (:id :dermatology :label "Dermatology" :average-total-compensation-usd 536000 :url-path "/o/-/dermatologist/salary")
    (:id :emergency-medicine :label "Emergency Medicine" :average-total-compensation-usd 440000 :url-path "/o/-/emergency-medicine-physician/salary")
    (:id :endocrinology :label "Endocrinology" :average-total-compensation-usd 320000 :url-path "/o/-/endocrinologist/salary")
    (:id :family-medicine :label "Family Medicine" :average-total-compensation-usd 314000 :url-path "/o/-/family-medicine-physician/salary")
    (:id :gastroenterology :label "Gastroenterology" :average-total-compensation-usd 626000 :url-path "/o/-/gastroenterologist/salary")
    (:id :genetics :label "Genetics" :average-total-compensation-usd 240000 :url-path "/o/-/geneticist/salary")
    (:id :hematology :label "Hematology" :average-total-compensation-usd 574000 :point-universe :no-hematology-only-point)
    (:id :hematology-oncology :label "Hematology Oncology" :average-total-compensation-usd 587000 :url-path "/o/-/hematologist-oncologist/salary")
    (:id :hepatology :label "Hepatology" :average-total-compensation-usd 459000 :url-path "/o/-/hepatologist/salary")
    (:id :infectious-disease :label "Infectious Disease" :average-total-compensation-usd 321000 :url-path "/o/-/infectious-disease-physician/salary")
    (:id :internal-medicine :label "Internal Medicine" :average-total-compensation-usd 327000 :url-path "/o/-/internist/salary")
    (:id :nephrology :label "Nephrology" :average-total-compensation-usd 385000 :url-path "/o/-/nephrologist/salary")
    (:id :neurology :label "Neurology" :average-total-compensation-usd 370000 :url-path "/o/-/neurologist/salary")
    (:id :neuromusculoskeletal-medicine :label "Neuromusculoskeletal Medicine" :average-total-compensation-usd 242000 :url-path "/o/-/neuromusculoskeletal-physician/salary")
    (:id :neurological-surgery :label "Neurosurgery" :average-total-compensation-usd 988000 :url-path "/o/-/neurosurgeon/salary")
    (:id :nuclear-medicine :label "Nuclear Medicine" :average-total-compensation-usd 376000 :url-path "/o/-/nuclear-medicine-physician/salary")
    (:id :obstetrics-gynecology :label "Obstetrics & Gynecology" :average-total-compensation-usd 410000 :url-path "/o/-/obgyn/salary")
    (:id :medical-oncology :label "Oncology" :average-total-compensation-usd 638000 :url-path "/o/-/oncologist/salary")
    (:id :ophthalmology :label "Ophthalmology" :average-total-compensation-usd 553000 :url-path "/o/-/ophthalmologist/salary")
    (:id :oral-maxillofacial-surgery :label "Oral Maxillofacial Surgery" :average-total-compensation-usd 667000 :point-universe :not-present)
    (:id :orthopaedic-surgery :label "Orthopedic Surgery" :average-total-compensation-usd 801000 :url-path "/o/-/orthopedic-surgeon/salary")
    (:id :otolaryngology :label "Otolaryngology" :average-total-compensation-usd 613000 :url-path "/o/-/ent/salary")
    (:id :pathology :label "Pathology" :average-total-compensation-usd 409000 :url-path "/o/-/pathologist/salary")
    (:id :pediatrics :label "Pediatrics" :average-total-compensation-usd 265000 :url-path "/o/-/pediatrician/salary")
    (:id :physical-medicine-rehabilitation :label "Physical Medicine & Rehabilitation" :average-total-compensation-usd 348000 :url-path "/o/-/physiatrist/salary")
    (:id :plastic-surgery :label "Plastic Surgery" :average-total-compensation-usd 725000 :url-path "/o/-/plastic-surgeon/salary")
    (:id :podiatry :label "Podiatry" :average-total-compensation-usd 233000 :point-universe :not-present)
    (:id :preventive-medicine :label "Preventive Medicine" :average-total-compensation-usd 365000)
    (:id :psychiatry :label "Psychiatry" :average-total-compensation-usd 351000)
    (:id :pulmonology :label "Pulmonology" :average-total-compensation-usd 484000)
    (:id :radiation-oncology :label "Radiation Oncology" :average-total-compensation-usd 647000)
    (:id :diagnostic-radiology :label "Radiology" :average-total-compensation-usd 691000)
    (:id :rheumatology :label "Rheumatology" :average-total-compensation-usd 318000)
    (:id :general-surgery :label "Surgery" :average-total-compensation-usd 513000)
    (:id :urgent-care :label "Urgent Care" :average-total-compensation-usd 339000 :point-universe :not-present)
    (:id :urology :label "Urology" :average-total-compensation-usd 639000)
    (:id :wound-care :label "Wound Care" :average-total-compensation-usd 344000 :point-universe :not-present)))

(defun donor-for (id)
  (cond
    ;; Exact ACGME-to-Marit name crosswalks.
    ((eq id :hematology-and-medical-oncology) :hematology-oncology)
    ((eq id :endocrinology-diabetes-and-metabolism) :endocrinology)
    ((eq id :osteopathic-neuromusculoskeletal-medicine) :neuromusculoskeletal-medicine)
    ((eq id :obstetrics-and-gynecology) :obstetrics-gynecology)
    ((eq id :pathology-anatomic-and-clinical) :pathology)
    ((eq id :physical-medicine-and-rehabilitation) :physical-medicine-rehabilitation)
    ((eq id :otolaryngology-head-and-neck-surgery) :otolaryngology)
    ;; Exact source names.
    ((find id *marit-salaries* :key (lambda (row) (getf row :id))) id)
    ;; Parent/group inheritance.
    ((contains-p "anesthesiology" id) :anesthesiology)
    ((or (contains-p "cardiology" id) (contains-p "cardiac-electrophysiology" id)
         (contains-p "adult-congenital-heart" id)) :cardiology)
    ((contains-p "dermat" id) :dermatology)
    ((or (contains-p "emergency-medical-services" id) (contains-p "medical-toxicology" id)
         (contains-p "undersea-and-hyperbaric" id)) :emergency-medicine)
    ((contains-p "gastroenterology" id) :gastroenterology)
    ((contains-p "hepatology" id) :hepatology)
    ((contains-p "infectious" id) :infectious-disease)
    ((contains-p "nephrology" id) :nephrology)
    ((or (contains-p "pulmonary" id) (contains-p "interventional-pulmonology" id)) :pulmonology)
    ((contains-p "rheumatology" id) :rheumatology)
    ((or (contains-p "genetic" id) (contains-p "genomics" id)) :genetics)
    ((or (contains-p "clinical-neurophysiology" id) (contains-p "epilepsy" id)
         (contains-p "neurocritical" id) (contains-p "neuromuscular-medicine" id)
         (contains-p "vascular-neurology" id) (eq id :child-neurology)) :neurology)
    ((or (contains-p "gynec" id) (contains-p "obstetric" id)
         (contains-p "maternal-fetal" id) (contains-p "family-planning" id)
         (contains-p "reproductive" id)) :obstetrics-gynecology)
    ((contains-p "ophthalmic" id) :ophthalmology)
    ((or (contains-p "orthopaedic" id) (contains-p "hand-surgery" id)
         (contains-p "musculoskeletal-oncology" id) (eq id :sports-medicine)) :orthopaedic-surgery)
    ((or (contains-p "otolaryng" id) (contains-p "neurotology" id)) :otolaryngology)
    ((or (contains-p "pathology" id) (contains-p "blood-banking" id)
         (contains-p "medical-microbiology" id)) :pathology)
    ((or (contains-p "pediatric" id) (contains-p "adolescent" id)
         (contains-p "neonatal" id) (contains-p "child-abuse" id)
         (contains-p "developmental-behavioral" id)) :pediatrics)
    ((or (contains-p "rehabilitation" id) (contains-p "brain-injury" id)
         (contains-p "spinal-cord-injury" id) (eq id :pain-medicine)) :physical-medicine-rehabilitation)
    ((contains-p "psychiatr" id) :psychiatry)
    ((or (contains-p "radiology" id) (contains-p "neuroradiology" id)) :diagnostic-radiology)
    ((contains-p "urolog" id) :urology)
    ((or (eq id :plastic-surgery-integrated) (contains-p "craniofacial" id)) :plastic-surgery)
    ((or (contains-p "surgery" id) (contains-p "surgical" id)
         (eq id :colon-and-rectal-surgery)) :general-surgery)
    ((or (eq id :public-health-and-general-preventive-medicine)
         (eq id :aerospace-medicine) (eq id :occupational-and-environmental-medicine)) :preventive-medicine)
    ((or (eq id :internal-medicine-pediatrics) (eq id :geriatric-medicine)
         (eq id :hospice-and-palliative-medicine) (eq id :sleep-medicine)
         (eq id :clinical-informatics) (contains-p "critical-care" id)) :internal-medicine)
    (t :internal-medicine)))

(defun direct-crosswalk-p (id donor)
  (or (eq id donor)
      (member (list id donor)
              '((:hematology-and-medical-oncology :hematology-oncology)
                (:endocrinology-diabetes-and-metabolism :endocrinology)
                (:osteopathic-neuromusculoskeletal-medicine :neuromusculoskeletal-medicine)
                (:obstetrics-and-gynecology :obstetrics-gynecology)
                (:pathology-anatomic-and-clinical :pathology)
                (:physical-medicine-and-rehabilitation :physical-medicine-rehabilitation)
                (:otolaryngology-head-and-neck-surgery :otolaryngology))
              :test #'equal)))

(defun low-confidence-p (id)
  (member id '(:pediatric-emergency-medicine :clinical-informatics
               :hospice-and-palliative-medicine :sleep-medicine
               :internal-medicine-pediatrics :neurodevelopmental-disabilities
               :pain-medicine :sports-medicine :urogynecology-and-reconstructive-pelvic-surgery)))

(defun salary-row (donor)
  (or (find donor *marit-salaries* :key (lambda (row) (getf row :id)))
      (error "Missing salary donor ~S" donor)))

(let* ((training (read-one *training-file*))
       (points (getf training :specialties))
       (records
         (mapcar
          (lambda (point)
            (let* ((id (getf point :id))
                   (donor (donor-for id))
                   (source (salary-row donor))
                   (direct (direct-crosswalk-p id donor))
                   (low (low-confidence-p id)))
              (list :id id :name (getf point :name)
                    :average-total-compensation-usd (getf source :average-total-compensation-usd)
                    :confidence (cond (direct :high) (low :low) (t :medium))
                    :basis (cond (direct :direct-marit-category)
                                 (low :estimated-nearest-category)
                                 (t :parent-or-subspecialty-crosswalk))
                    :salary-donor-id donor
                    :umap-use t)))
          points))
       (document
         (list
          :format :specialty-salary-feature
          :version 2
          :country :united-states
          :as-of "2026-09-05"
          :population :full-time-physicians
          :point-key :id
          :feature
          '(:id :average-total-compensation-usd
            :unit :nominal-usd-per-year
            :statistic :mean
            :includes (:base-salary :bonuses :other-income)
            :recommended-transform :log10-then-z-score
            :umap-use :all-records-including-low-confidence
            :confidence-weighting :none)
          :source
          '(:publisher "Marit Health"
            :title "Physician Salary in US"
            :url "https://www.marithealth.com/o/-/physician/salary"
            :displayed-year 2026
            :retrieved "2026-09-05"
            :note "Marit states that averages remove outliers and apply de-biasing adjustments; supplied specialty values were verified against the live Browse specialties list.")
          :method-notes
          '("Salary means average annual total compensation for full-time physicians, not base salary, median compensation, or compensation per wRVU."
            "Oncology and Hematology Oncology are separate direct Marit categories and separate UMAP points: $638,000 and $587,000 respectively."
            "The standalone Hematology source value is retained but unused because the current point universe has no hematology-only point."
            "Source categories absent from the ACGME point universe—Bariatric Medicine, Oral Maxillofacial Surgery, Podiatry, Urgent Care, and Wound Care—are retained but not mapped as points."
            "Inherited salaries are estimates, not direct subspecialty observations."
            "Per user instruction all records, including low-confidence estimates, are enabled for UMAP without confidence weighting.")
          :source-salaries *marit-salaries*
          :specialties records)))
  (with-open-file (stream *output-file* :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (let ((*print-pretty* t) (*print-right-margin* 112) (*print-case* :downcase))
      (prin1 document stream) (terpri stream)))
  (format t "Wrote ~D salary records from ~D retained Marit categories to ~A~%"
          (length records) (length *marit-salaries*) (namestring *output-file*)))
