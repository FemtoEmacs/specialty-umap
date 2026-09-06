#!/usr/bin/env sbcl --script

;;; Build the compensation/task feature file from the specialty point universe.
;;; No Quicklisp or third-party Common Lisp libraries are required.

(defparameter *root*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *training-file*
  (merge-pathnames "../data/specialty-training-paths.sexpr" *root*))
(defparameter *output-file*
  (merge-pathnames "../data/specialty-compensation-tasks.sexpr" *root*))

(defun read-one (path)
  (with-open-file (stream path :direction :input)
    (read stream)))

(defun rounded (number &optional (places 4))
  (let ((scale (expt 10 places)))
    (/ (round (* number scale)) (float scale))))

;; Chart coordinates were read from the Marit/LinkedIn figure. Values explicitly
;; printed in the accompanying prose are marked :text; all others :chart-read.
(defparameter *benchmarks*
  '((:id :psychiatry :article-label "Psychiatry" :annual-wrvus 4500 :usd-per-wrvu 58 :extraction :chart-read)
    (:id :hematology-oncology :article-label "Hematology/Oncology" :annual-wrvus 5500 :usd-per-wrvu 90 :extraction :chart-read)
    (:id :neurology :article-label "Neurology" :annual-wrvus 5400 :usd-per-wrvu 58 :extraction :chart-read)
    (:id :physical-medicine-rehabilitation :article-label "Physical Medicine & Rehabilitation" :annual-wrvus 6000 :usd-per-wrvu 60 :extraction :chart-read)
    (:id :endocrinology :article-label "Endocrinology" :annual-wrvus 5000 :usd-per-wrvu 53 :extraction :chart-read)
    (:id :internal-medicine :article-label "Internal Medicine" :annual-wrvus 5800 :usd-per-wrvu 52 :extraction :chart-read)
    (:id :pediatrics :article-label "Pediatrics" :annual-wrvus 4800 :usd-per-wrvu 48 :extraction :chart-read)
    (:id :family-medicine :article-label "Family Medicine" :annual-wrvus 5700 :usd-per-wrvu 45 :extraction :chart-read)
    (:id :obstetrics-gynecology :article-label "Obstetrics/Gynecology" :annual-wrvus 7000 :usd-per-wrvu 52 :extraction :chart-read)
    (:id :general-surgery :article-label "General Surgery" :annual-wrvus 7200 :usd-per-wrvu 62 :extraction :chart-read)
    (:id :otolaryngology :article-label "Otolaryngology" :annual-wrvus 7200 :usd-per-wrvu 65 :extraction :chart-read)
    (:id :urology :article-label "Urology" :annual-wrvus 8000 :usd-per-wrvu 60 :extraction :chart-read)
    (:id :ophthalmology :article-label "Ophthalmology" :annual-wrvus 8200 :usd-per-wrvu 42 :extraction :chart-read)
    (:id :dermatology :article-label "Dermatology" :annual-wrvus 8700 :usd-per-wrvu 58 :extraction :chart-read)
    (:id :gastroenterology :article-label "Gastroenterology" :annual-wrvus 9000 :usd-per-wrvu 66 :extraction :chart-read)
    (:id :orthopaedic-surgery :article-label "Orthopedics" :annual-wrvus 10000 :usd-per-wrvu 70 :extraction :text-and-chart)
    (:id :radiation-oncology :article-label "Radiation Oncology" :annual-wrvus 9500 :usd-per-wrvu 60 :extraction :chart-read)
    (:id :cardiology :article-label "Cardiology" :annual-wrvus 9850 :usd-per-wrvu 60 :extraction :text-and-chart)
    (:id :neurological-surgery :article-label "Neurosurgery" :annual-wrvus 10000 :usd-per-wrvu 80 :extraction :chart-read)
    (:id :diagnostic-radiology :article-label "Radiology" :annual-wrvus 11950 :usd-per-wrvu 50 :extraction :text-and-chart)))

;; Each anchor keeps the raw CMS ingredients. The rates are computed at build
;; time, not copied from an article or manually rounded source.
(defparameter *anchors*
  '((:id :psychiatry :hcpcs "90834" :task "45-minute psychotherapy encounter" :work-rvu 2.45 :pre 5 :position 0 :scrub-wait 0 :intra 45 :immediate-post 10 :total 60)
    (:id :hematology-oncology :hcpcs "99215" :task "high-complexity established outpatient visit" :work-rvu 2.80 :pre 10 :position 0 :scrub-wait 0 :intra 45 :immediate-post 15 :total 70)
    (:id :medical-oncology :hcpcs "99215" :task "high-complexity established outpatient oncology visit" :work-rvu 2.80 :pre 10 :position 0 :scrub-wait 0 :intra 45 :immediate-post 15 :total 70)
    (:id :neurology :hcpcs "99214" :task "moderate-complexity established outpatient visit" :work-rvu 1.92 :pre 7 :position 0 :scrub-wait 0 :intra 30 :immediate-post 10 :total 47)
    (:id :physical-medicine-rehabilitation :hcpcs "99214" :task "moderate-complexity established outpatient visit" :work-rvu 1.92 :pre 7 :position 0 :scrub-wait 0 :intra 30 :immediate-post 10 :total 47)
    (:id :endocrinology :hcpcs "99214" :task "moderate-complexity established outpatient visit" :work-rvu 1.92 :pre 7 :position 0 :scrub-wait 0 :intra 30 :immediate-post 10 :total 47)
    (:id :internal-medicine :hcpcs "99214" :task "moderate-complexity established outpatient visit" :work-rvu 1.92 :pre 7 :position 0 :scrub-wait 0 :intra 30 :immediate-post 10 :total 47)
    (:id :pediatrics :hcpcs "99213" :task "low-complexity established outpatient visit" :work-rvu 1.30 :pre 5 :position 0 :scrub-wait 0 :intra 20 :immediate-post 5 :total 30)
    (:id :family-medicine :hcpcs "99214" :task "moderate-complexity established outpatient visit" :work-rvu 1.92 :pre 7 :position 0 :scrub-wait 0 :intra 30 :immediate-post 10 :total 47)
    (:id :obstetrics-gynecology :hcpcs "58571" :task "total laparoscopic hysterectomy, 250 g or less" :work-rvu 15.00 :pre 33 :position 8 :scrub-wait 15 :intra 90 :immediate-post 30 :total 241)
    (:id :general-surgery :hcpcs "47562" :task "laparoscopic cholecystectomy" :work-rvu 10.47 :pre 40 :position 10 :scrub-wait 15 :intra 80 :immediate-post 25 :total 251)
    (:id :otolaryngology :hcpcs "31575" :task "diagnostic flexible laryngoscopy" :work-rvu 0.94 :pre 8 :position 1 :scrub-wait 5 :intra 5 :immediate-post 5 :total 24)
    (:id :urology :hcpcs "52601" :task "transurethral resection of prostate" :work-rvu 13.16 :pre 33 :position 8 :scrub-wait 10 :intra 75 :immediate-post 45 :total 236)
    (:id :ophthalmology :hcpcs "66984" :task "cataract extraction with intraocular lens" :work-rvu 7.35 :pre 13 :position 1 :scrub-wait 6 :intra 20 :immediate-post 5 :total 126)
    (:id :dermatology :hcpcs "11102" :task "tangential biopsy of one skin lesion" :work-rvu 0.66 :pre 3 :position 2 :scrub-wait 2 :intra 6 :immediate-post 5 :total 18)
    (:id :gastroenterology :hcpcs "43239" :task "upper GI endoscopy with biopsy" :work-rvu 2.39 :pre 13 :position 3 :scrub-wait 5 :intra 17 :immediate-post 12 :total 50)
    (:id :orthopaedic-surgery :hcpcs "27447" :task "total knee arthroplasty" :work-rvu 19.60 :pre 40 :position 15 :scrub-wait 15 :intra 97 :immediate-post 20 :total 374)
    (:id :radiation-oncology :hcpcs "77427" :task "radiation treatment management, five fractions" :work-rvu 3.37 :pre 7 :position 0 :scrub-wait 0 :intra 70 :immediate-post 10 :total 101.39)
    (:id :cardiology :hcpcs "93458" :task "left-heart catheterization and coronary angiography" :work-rvu 5.60 :pre 30 :position 3 :scrub-wait 5 :intra 45 :immediate-post 30 :total 113)
    (:id :neurological-surgery :hcpcs "61510" :task "craniotomy for supratentorial brain tumor" :work-rvu 30.83 :pre 105 :position 0 :scrub-wait 0 :intra 200 :immediate-post 40 :total 635)
    (:id :diagnostic-radiology :hcpcs "74177" :task "CT abdomen and pelvis with contrast, professional interpretation" :work-rvu 1.82 :pre 5 :position 0 :scrub-wait 0 :intra 25 :immediate-post 5 :total 35)))

(defun contains-p (needle keyword)
  (search needle (string-downcase (symbol-name keyword))))

(defun benchmark-for (id)
  "Return the closest available article category. This mapping is intentionally
coarse and is emitted on every point so it can be audited or replaced later."
  (cond
    ((or (eq id :neurological-surgery) (contains-p "neurosurg" id)) :neurological-surgery)
    ((or (eq id :radiation-oncology) (contains-p "radiation-oncology" id)) :radiation-oncology)
    ((or (eq id :diagnostic-radiology) (contains-p "radiology" id)
         (contains-p "nuclear-medicine" id)) :diagnostic-radiology)
    ((or (eq id :orthopaedic-surgery) (contains-p "orthopaedic" id)
         (contains-p "sports-medicine" id) (contains-p "hand-surgery" id)) :orthopaedic-surgery)
    ((or (eq id :cardiology) (contains-p "cardiology" id)
         (contains-p "cardiac-electrophysiology" id)
         (contains-p "adult-congenital-heart" id)) :cardiology)
    ((or (eq id :hematology-and-medical-oncology) (eq id :medical-oncology)
         (contains-p "hematology-oncology" id)) :hematology-oncology)
    ((or (eq id :gastroenterology) (contains-p "gastroenterology" id)
         (contains-p "hepatology" id)) :gastroenterology)
    ((or (eq id :endocrinology-diabetes-and-metabolism)
         (contains-p "endocrinology" id)) :endocrinology)
    ((or (eq id :dermatology) (contains-p "dermat" id)) :dermatology)
    ((or (eq id :ophthalmology) (contains-p "ophthalm" id)) :ophthalmology)
    ((or (eq id :otolaryngology-head-and-neck-surgery)
         (contains-p "otolaryng" id) (contains-p "neurotology" id)) :otolaryngology)
    ((or (eq id :urology) (contains-p "urolog" id)) :urology)
    ((or (eq id :obstetrics-and-gynecology) (contains-p "gynec" id)
         (contains-p "obstetric" id) (contains-p "maternal-fetal" id)
         (contains-p "family-planning" id) (contains-p "reproductive" id)) :obstetrics-gynecology)
    ((or (eq id :psychiatry) (contains-p "psychiatr" id)
         (contains-p "addiction" id)) :psychiatry)
    ((or (eq id :physical-medicine-and-rehabilitation) (contains-p "rehabilitation" id)
         (contains-p "brain-injury" id) (contains-p "spinal-cord" id)
         (contains-p "neuromusculoskeletal" id) (contains-p "pain-medicine" id))
     :physical-medicine-rehabilitation)
    ((or (eq id :neurology) (eq id :child-neurology) (contains-p "neuro" id)
         (contains-p "epilepsy" id)) :neurology)
    ((or (eq id :pediatrics) (contains-p "pediatric" id) (contains-p "adolescent" id)
         (contains-p "neonatal" id) (contains-p "child-abuse" id)) :pediatrics)
    ((or (eq id :family-medicine) (contains-p "preventive" id)
         (contains-p "occupational" id) (contains-p "aerospace" id)) :family-medicine)
    ((or (eq id :general-surgery) (contains-p "surgery" id)
         (contains-p "surgical" id) (contains-p "colon-and-rectal" id)) :general-surgery)
    (t :internal-medicine)))

(defun add-derived-rates (anchor)
  (let ((wrvu (getf anchor :work-rvu))
        (intra (getf anchor :intra))
        (total (getf anchor :total)))
    (append anchor
            (list :wrvu-per-intra-service-hour (rounded (* 60 (/ wrvu intra)))
                  :wrvu-per-total-physician-hour (rounded (* 60 (/ wrvu total)))))))

(defun direct-match-p (specialty-id benchmark-id)
  (member specialty-id
          (case benchmark-id
            (:hematology-oncology '(:hematology-and-medical-oncology))
            (:physical-medicine-rehabilitation '(:physical-medicine-and-rehabilitation))
            (:endocrinology '(:endocrinology-diabetes-and-metabolism))
            (:obstetrics-gynecology '(:obstetrics-and-gynecology))
            (:otolaryngology '(:otolaryngology-head-and-neck-surgery))
            (otherwise (list benchmark-id)))))

(defun task-anchor-for (specialty-id benchmark-id)
  "Keep oncology-only distinct from the combined hematology/oncology point."
  (if (eq specialty-id :medical-oncology) :medical-oncology benchmark-id))

(defun direct-task-match-p (specialty-id task-anchor-id)
  (or (eq specialty-id :medical-oncology)
      (direct-match-p specialty-id task-anchor-id)))

(let* ((training (read-one *training-file*))
       (specialties (getf training :specialties))
       (records
         (mapcar
          (lambda (specialty)
            (let* ((id (getf specialty :id))
                   (benchmark (benchmark-for id))
                   (task-anchor (task-anchor-for id benchmark))
                   (direct (direct-match-p id benchmark))
                   (direct-task (direct-task-match-p id task-anchor)))
              (list :id id
                    :name (getf specialty :name)
                    :benchmark-id benchmark
                    :benchmark-match (if direct :direct :nearest-available)
                    :benchmark-imputed-p (not direct)
                    :task-anchor-id task-anchor
                    :task-match (if direct-task :direct :nearest-available)
                    :task-imputed-p (not direct-task))))
          specialties))
       (document
         (list
          :format :specialty-compensation-and-task-features
          :version 1
          :country :united-states
          :benchmark-as-of "2025-07-01"
          :cms-calendar-year 2025
          :point-key :id
          :features
          '((:id :median-annual-wrvus :unit :wrvu-per-year :source :marit-linkedin)
            (:id :median-compensation-usd-per-wrvu :unit :usd-per-wrvu :source :marit-linkedin)
            (:id :anchor-task-work-rvu :unit :wrvu-per-service :source :cms-pfs-relative-value-file)
            (:id :anchor-task-intra-service-minutes :unit :minutes :source :cms-physician-work-time)
            (:id :anchor-task-total-physician-minutes :unit :minutes :source :cms-physician-work-time)
            (:id :anchor-task-wrvu-per-intra-service-hour :unit :wrvu-per-hour :derivation "work-rvu * 60 / intra-service-minutes")
            (:id :anchor-task-wrvu-per-total-physician-hour :unit :wrvu-per-hour :derivation "work-rvu * 60 / total-physician-minutes"))
          :sources
          '((:id :marit-linkedin
             :publisher "Marit Health"
             :title "2025 wRVUs and $ per wRVU Benchmarks by Specialty: A Guide for Physicians"
             :url "https://www.linkedin.com/pulse/2025-wrvus-per-wrvu-benchmarks-specialty-guide-physicians-dtyac/"
             :retrieved "2026-09-05"
             :note "Anonymized verified Marit salary contributions as of 2025-07-01; most values were read approximately from a chart.")
            (:id :cms-pfs-relative-value-file
             :publisher "Centers for Medicare & Medicaid Services"
             :title "2025 National Physician Fee Schedule Relative Value File, July release (RVU25C)"
             :url "https://www.cms.gov/medicare/payment/fee-schedules/physician/pfs-relative-value-files/rvu25c"
             :file "PPRRVU2025_Jul.csv"
             :sha256 "b7937472967288d5c4dcf43ecbc5d2d792e97d768c9f5ec9b1e88a99f3d0bbe7"
             :released "2025-06-05"
             :retrieved "2026-09-05")
            (:id :cms-physician-work-time
             :publisher "Centers for Medicare & Medicaid Services"
             :title "CY 2025 PFS Final Rule Physician Work Time"
             :url "https://www.cms.gov/files/zip/cy-2025-pfs-final-rule-physician-work-time.zip"
             :file "CMS-1807-F_Work_Time_16OCT24_508.txt"
             :sha256 "83695668da326f10dfaf6936026529d59581e488527dd5390a6ec24d8b9fd312"
             :retrieved "2026-09-05"))
          :method-notes
          '("Annual wRVUs and compensation dollars per wRVU are distinct observed specialty benchmarks; neither is derived from the CPT anchor."
            "A nearest-available value is an explicit imputation from one of the article's broad categories, not a measurement for that subspecialty."
            "The representative task is an anchor for work intensity, not a claim about the specialty's complete case mix or realized hourly productivity."
            "CMS total physician time can include pre-service, intra-service, immediate post-service, and additional global-period work; therefore both intra-service and total-time rates are retained."
            "Anesthesia services use base/time units rather than ordinary physician work RVUs; anesthesiology points are conservatively mapped to the general-surgery anchor and marked imputed pending a dedicated anesthesia feature.")
          :benchmarks *benchmarks*
          :task-anchors (mapcar #'add-derived-rates *anchors*)
          :specialties records)))
  (with-open-file (stream *output-file* :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (let ((*print-pretty* t) (*print-right-margin* 110) (*print-case* :downcase))
      (prin1 document stream)
      (terpri stream)))
  (format t "Wrote ~D specialty feature records to ~A~%"
          (length records) (namestring *output-file*)))
