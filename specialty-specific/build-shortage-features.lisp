(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(defparameter *root* (merge-pathnames "../" *here*))

(defun read-form (path)
  (with-open-file (in path) (read in nil nil)))

(defun plist-section (key form) (getf form key))
(defun contains-ci (needle haystack)
  (search needle haystack :test #'char-equal))

;; Each benchmark is (id label physicians patients physician-year patient-year
;; confidence physician-source patient-source scope-note).
(defparameter *benchmarks*
  '((:allergy "Allergy/immunology" 5009 81000000 2021 2021 :medium :aamc-2022 :cdc-allergy "people with allergic disease")
    (:anesthesiology "Anesthesiology" 42000 50000000 2021 2018 :low :aamc-2022 :ahrq-surgery "annual patients undergoing procedures; utilization proxy")
    (:cardiology "Cardiovascular disease" 22262 127900000 2021 2018 :medium :aamc-2022 :aha-cvd "adults with cardiovascular disease")
    (:cardiac-electrophysiology "Clinical cardiac electrophysiology" 2632 12100000 2021 2023 :medium :aamc-2022 :cdc-afib "people projected/estimated with atrial fibrillation")
    (:interventional-cardiology "Interventional cardiology" 4500 20100000 2021 2021 :low :aamc-2022 :cdc-cad "adults with coronary artery disease")
    (:colorectal "Colon and rectal surgery" 1600 4900000 2021 2021 :low :aamc-2022 :cdc-ibd-crc "IBD plus colorectal-cancer prevalence proxy")
    (:critical-care "Critical care" 13000 5700000 2021 2018 :low :aamc-2022 :sccm-icu "annual ICU admissions")
    (:dermatology "Dermatology" 12500 84500000 2021 2013 :medium :aamc-2022 :aad-skin-disease "people affected by skin disease")
    (:emergency-medicine "Emergency medicine" 46857 139800000 2021 2021 :medium :aamc-2022 :cdc-ed "annual emergency-department visits; visits proxy patients")
    (:endocrinology "Endocrinology" 8000 40000000 2022 2021 :medium :endocrine-society :cdc-diabetes "user-specified rounded endocrine workforce and cases; diabetes burden proxy")
    (:gastroenterology "Gastroenterology" 16600 60000000 2021 2019 :low :aamc-2022 :niddk-digestive "people with digestive diseases; broad burden proxy")
    (:general-surgery "General surgery" 25200 50000000 2021 2018 :low :aamc-2022 :ahrq-surgery "annual surgical patients proxy")
    (:genetics "Medical genetics" 1600 30000000 2021 2024 :low :aamc-2022 :nih-rare-disease "people with a rare disease; not all require geneticists")
    (:geriatrics "Geriatric medicine" 7500 57800000 2021 2022 :medium :aamc-2022 :census-older "US population age 65 and older")
    (:hematology-oncology "Hematology/oncology" 16715 20000000 2021 2022 :medium :user-specified-combined-need :nci-cancer "11,937 hematologist-oncologists plus 4,778 oncology-only physicians serving the same pool; 18 million survivors plus 2 million new cancer cases annually")
    (:medical-oncology "Medical oncology" 4778 20000000 2021 2022 :medium :user-correction :nci-cancer "4,778 oncology-only physicians; 18 million survivors plus 2 million new cancer cases annually")
    (:infectious-disease "Infectious disease" 9300 40000000 2021 2021 :low :aamc-2022 :cdc-infectious "annual clinically significant infectious-disease burden proxy")
    (:nephrology "Nephrology" 11000 35500000 2021 2023 :medium :aamc-2022 :cdc-ckd "US adults with chronic kidney disease")
    (:neurology "Neurology" 19700 100000000 2021 2021 :low :aamc-2022 :nih-neurologic "people with neurological disease; broad burden proxy")
    (:neurosurgery "Neurological surgery" 5900 3200000 2021 2018 :low :aamc-2022 :ahrq-neurosurgery "annual neurosurgical candidates/utilization proxy")
    (:obgyn "Obstetrics and gynecology" 42300 168000000 2021 2022 :low :aamc-2022 :census-female "female population; service-population proxy")
    (:ophthalmology "Ophthalmology" 18948 93000000 2021 2020 :medium :aamc-2022 :cdc-vision "people at risk of or living with vision/eye disease")
    (:orthopaedics "Orthopaedic surgery" 20500 127400000 2021 2018 :medium :aamc-2022 :usbji-msk "people with a musculoskeletal condition")
    (:otolaryngology "Otolaryngology" 12000 100000000 2021 2021 :low :aamc-2022 :cdc-ent "people with hearing, sinus, sleep, or related ENT burden proxy")
    (:pain "Pain medicine" 7900 51600000 2021 2021 :medium :aamc-2022 :cdc-chronic-pain "adults with chronic pain")
    (:pathology "Pathology" 21000 331900000 2021 2021 :low :aamc-2022 :census-population "whole population; diagnostic-service proxy")
    (:pediatrics "Pediatrics" 60305 73000000 2021 2021 :medium :aamc-2022 :census-children "US population under 18")
    (:pediatric-cardiology "Pediatric cardiology" 3000 1000000 2021 2021 :low :aamc-2022 :cdc-chd "children living with congenital heart disease proxy")
    (:pediatric-hematology-oncology "Pediatric hematology/oncology" 2300 500000 2021 2020 :low :aamc-2022 :nci-childhood-cancer "childhood cancer survivors plus hematologic burden proxy")
    (:pmr "Physical medicine and rehabilitation" 10000 61000000 2021 2016 :low :aamc-2022 :cdc-disability "adults with disability; rehabilitation burden proxy")
    (:preventive "Preventive medicine" 6000 331900000 2021 2021 :low :aamc-2022 :census-population "whole population")
    (:psychiatry "Psychiatry" 41700 59000000 2021 2022 :medium :aamc-2022 :nimh-ami "adults with any mental illness")
    (:pulmonary "Pulmonary disease" 12500 35000000 2021 2021 :medium :aamc-2022 :cdc-lung "people with chronic lung disease proxy")
    (:radiation-oncology "Radiation oncology" 5500 18000000 2021 2022 :medium :aamc-2022 :nci-cancer "cancer prevalence")
    (:radiology "Diagnostic/interventional radiology" 31000 80000000 2021 2018 :low :aamc-2022 :ahrq-imaging "annual patients receiving advanced imaging proxy")
    (:rheumatology "Rheumatology" 6300 54400000 2021 2017 :medium :aamc-2022 :cdc-arthritis "adults with doctor-diagnosed arthritis")
    (:sleep "Sleep medicine" 7500 70000000 2021 2020 :low :aamc-2022 :aasm-sleep "people with chronic sleep disorders proxy")
    (:urology "Urology" 10081 33000000 2021 2021 :medium :aamc-2022 :niddk-urologic "people with major urologic disease proxy")
    (:vascular-surgery "Vascular surgery" 3600 8500000 2021 2021 :low :aamc-2022 :cdc-pad "people with peripheral arterial disease proxy")
    (:population-primary-care "Primary care" 118641 331900000 2021 2021 :medium :aamc-2022 :census-population "whole US population; family-medicine count")
    (:adult-primary-care "Adult primary care" 120342 258300000 2021 2021 :medium :aamc-2022 :census-adults "US adult population; internal-medicine count")))

(defun benchmark-id-for (id name parent)
  (declare (ignore parent))
  (cond
    ((eq id :hematology-and-medical-oncology) :hematology-oncology)
    ((eq id :medical-oncology) :medical-oncology)
    ((eq id :endocrinology-diabetes-and-metabolism) :endocrinology)
    ((eq id :clinical-neurophysiology) :neurology)
    ((eq id :interventional-cardiology) :interventional-cardiology)
    ((eq id :adult-congenital-heart-disease) :cardiology)
    ((eq id :advanced-heart-failure-and-transplant-cardiology) :cardiology)
    ((contains-ci "cardiac" name) (if (contains-ci "anesthes" name) :anesthesiology :cardiac-electrophysiology))
    ((eq id :pediatric-cardiology) :pediatric-cardiology)
    ((eq id :pediatric-hematology-oncology) :pediatric-hematology-oncology)
    ((contains-ci "pediatric" name) :pediatrics)
    ((contains-ci "anesthes" name) :anesthesiology)
    ((contains-ci "critical care" name) :critical-care)
    ((or (contains-ci "radiology" name) (contains-ci "radiological" name)) :radiology)
    ((contains-ci "pathology" name) :pathology)
    ((or (contains-ci "genetic" name) (contains-ci "genomic" name)) :genetics)
    ((contains-ci "dermat" name) :dermatology)
    ((contains-ci "emergency" name) :emergency-medicine)
    ((contains-ci "geriatric" name) :geriatrics)
    ((or (contains-ci "psychiat" name) (contains-ci "addiction" name)) :psychiatry)
    ((or (contains-ci "neurolog" name) (contains-ci "epilep" name) (contains-ci "brain injury" name)
         (contains-ci "neurodevelopment" name) (contains-ci "neuromuscular" name)) :neurology)
    ((contains-ci "neurosurg" name) :neurosurgery)
    ((or (contains-ci "obstetric" name) (contains-ci "gynecologic" name) (contains-ci "maternal" name)
         (contains-ci "family planning" name) (contains-ci "infertility" name) (contains-ci "urogynecology" name)) :obgyn)
    ((contains-ci "ophthalm" name) :ophthalmology)
    ((or (contains-ci "orthopaedic" name) (contains-ci "hand surgery" name) (contains-ci "sports medicine" name)) :orthopaedics)
    ((or (contains-ci "otolaryng" name) (contains-ci "neurotology" name)) :otolaryngology)
    ((contains-ci "pain" name) :pain)
    ((contains-ci "rehabilitation" name) :pmr)
    ((or (contains-ci "preventive" name) (contains-ci "aerospace" name) (contains-ci "occupational" name)) :preventive)
    ((or (contains-ci "pulmonary" name) (contains-ci "sleep" name)) (if (contains-ci "sleep" name) :sleep :pulmonary))
    ((contains-ci "rheumat" name) :rheumatology)
    ((contains-ci "nephro" name) :nephrology)
    ((or (contains-ci "infectious" name) (contains-ci "microbiology" name) (contains-ci "toxicology" name)) :infectious-disease)
    ((or (contains-ci "gastro" name) (contains-ci "hepat" name)) :gastroenterology)
    ((contains-ci "oncology" name) :medical-oncology)
    ((contains-ci "urolog" name) :urology)
    ((contains-ci "vascular surgery" name) :vascular-surgery)
    ((or (contains-ci "thoracic surgery" name) (contains-ci "general surgery" name) (contains-ci "surgical" name)
         (contains-ci "plastic surgery" name) (contains-ci "craniofacial" name) (contains-ci "colon and rectal" name)) :general-surgery)
    ((contains-ci "allergy" name) :allergy)
    ((contains-ci "nuclear medicine" name) :radiology)
    ((contains-ci "family medicine" name) :population-primary-care)
    ((contains-ci "internal medicine/pediatrics" name) :population-primary-care)
    ((contains-ci "internal medicine" name) :adult-primary-care)
    ((contains-ci "pediatrics" name) :pediatrics)
    (t :population-primary-care)))

(defun benchmark (id) (find id *benchmarks* :key #'first))
(defun direct-match-p (point-id benchmark-id)
  (or (member point-id '(:allergy-and-immunology :anesthesiology :dermatology :emergency-medicine
                          :family-medicine :internal-medicine :neurological-surgery :neurology
                          :obstetrics-and-gynecology :ophthalmology :orthopaedic-surgery
                          :pathology-anatomic-and-clinical :pediatrics :public-health-and-general-preventive-medicine
                          :psychiatry :radiation-oncology :diagnostic-radiology :general-surgery :urology
                          :interventional-cardiology :endocrinology-diabetes-and-metabolism :gastroenterology
                          :hematology-and-medical-oncology :medical-oncology :infectious-disease :nephrology
                          :pulmonary-disease :rheumatology :sleep-medicine :pediatric-cardiology
                          :pediatric-hematology-oncology))
      (eq point-id benchmark-id)))

(defun emit-object (out object) (let ((*print-pretty* t) (*print-right-margin* 118)) (prin1 object out) (terpri out)))

(let* ((training (read-form (merge-pathnames "data/specialty-training-paths.sexpr" *root*)))
       (points (plist-section :specialties training))
       (records
         (mapcar
          (lambda (p)
            (let* ((id (getf p :id)) (name (getf p :name)) (parent (getf p :parent))
                   (bid (benchmark-id-for id name parent)) (b (benchmark bid))
                   (phys (third b)) (patients (fourth b))
                   (ratio (/ (* 1000.0d0 phys) patients))
                   (direct (direct-match-p id bid))
                   (conf (if direct (seventh b) :low)))
              (list :id id :name name :physicians-per-1000-relevant-patients ratio
                    :physician-count phys :relevant-patient-count patients
                    :calculation (format nil "(/ ~,1f (/ ~,1f 1000.0))" (float phys) (float patients))
                    :benchmark-id bid :mapping (if direct :direct-or-explicit :broad-proxy-inherited)
                    :confidence conf :umap-use t)))
          points))
       (output
         (list :format :specialty-workforce-burden
               :version 1 :country :united-states :as-of "2026-09-05"
               :feature (list :id :physicians-per-1000-relevant-patients :type :continuous
                              :direction :higher-means-more-physician-supply-relative-to-burden
                              :formula "physician-count / (relevant-patient-count / 1000)"
                              :recommended-transform :log10-then-z-score :umap-use-all-records t)
               :interpretation (list :preferred-label "workforce-to-burden density"
                                     :not-equivalent-to "formal shortage, adequacy, access, wait time, geographic distribution, or demand")
               :sources
               '((:id :aamc-2022 :url "https://www.aamc.org/data-reports/workforce/data/2022-physician-specialty-data-report-executive-summary")
                 (:id :aamc-dashboard :url "https://www.aamc.org/data-reports/report/us-physician-workforce-data-dashboard")
                 (:id :cdc-diabetes :url "https://www.cdc.gov/diabetes/php/data-research/index.html")
                 (:id :nci-cancer :url "https://cancercontrol.cancer.gov/ocs/statistics")
                 (:id :census-population :url "https://www.census.gov/quickfacts/fact/table/US/PST045224")
                 (:id :census-adults :url "https://www.census.gov/quickfacts/fact/table/US/PST045224")
                 (:id :census-children :url "https://www.census.gov/quickfacts/fact/table/US/PST045224")
                 (:id :census-older :url "https://www.census.gov/quickfacts/fact/table/US/PST045224")
                 (:id :cdc-afib :url "https://www.cdc.gov/heart-disease/about/atrial-fibrillation.html")
                 (:id :cdc-cad :url "https://www.cdc.gov/heart-disease/about/coronary-artery-disease.html")
                 (:id :cdc-ckd :url "https://www.cdc.gov/kidney-disease/php/data-research/index.html")
                 (:id :cdc-chd :url "https://www.cdc.gov/heart-defects/data/index.html")
                 (:id :cdc-chronic-pain :url "https://www.cdc.gov/mmwr/volumes/72/wr/mm7215a1.htm")
                 (:id :cdc-arthritis :url "https://www.cdc.gov/arthritis/data-research/index.html")
                 (:id :cdc-disability :url "https://www.cdc.gov/disability-and-health/articles-documents/disability-impacts-all-of-us-infographic.html")
                 (:id :cdc-ed :url "https://www.cdc.gov/nchs/fastats/emergency-department.htm")
                 (:id :nimh-ami :url "https://www.nimh.nih.gov/health/statistics/mental-illness")
                 (:id :nih-rare-disease :url "https://ncats.nih.gov/research/research-activities/rare-diseases")
                 (:id :niddk-digestive :url "https://www.niddk.nih.gov/health-information/health-statistics/digestive-diseases")
                 (:id :ahrq-surgery :url "https://hcup-us.ahrq.gov/reports/statbriefs/sb281-Operating-Room-Procedures-During-Hospital-Stays-2018.jsp")
                 (:id :methodology :path "../data-sources/workforce-burden-methodology.md"))
               :notes
               '("Counts and disease burdens come from different years; this is a cross-sectional proxy, not a time-series estimate."
                 "The AAMC reports active physicians, which include some non-patient-care physicians."
                 "For narrow specialties without compatible national numerator and patient denominator, the nearest broad clinical burden is inherited and confidence is low."
                 "For need, hematology/medical oncology uses the combined 11,937 plus 4,778 cancer-care workforce; medical oncology remains a separate point, and salary categories remain separate.")
               :benchmarks
               (mapcar (lambda (b)
                         (destructuring-bind (id label phys patients py dy conf ps ds note) b
                           (list :id id :label label :physician-count phys :relevant-patient-count patients
                                 :physician-count-year py :patient-count-year dy :confidence conf
                                 :physician-source ps :patient-source ds :scope-note note
                                 :physicians-per-1000-relevant-patients (/ (* 1000.0d0 phys) patients))))
                       *benchmarks*)
               :records records)))
  (with-open-file (out (merge-pathnames "data/specialty-workforce-burden.sexp" *root*)
                       :direction :output :if-exists :supersede :if-does-not-exist :create)
    (emit-object out output))
  (format t "Wrote ~D workforce-burden records from ~D benchmarks.~%" (length records) (length *benchmarks*)))
