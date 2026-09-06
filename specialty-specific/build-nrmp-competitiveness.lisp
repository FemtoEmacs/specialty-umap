(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(defparameter *root* (merge-pathnames "../" *here*))

(defun read-one (path) (with-open-file (in path) (read in nil nil)))

;; (point-id source-label candidates positions). Main Match candidates are all
;; applicants naming the specialty as first or only choice, summed over MD/DO
;; seniors, MD/DO graduates, U.S. IMGs, and non-U.S. IMGs. Preliminary tracks
;; are excluded. Fellowship candidates are all active applicants ranking at
;; least one program in the specialty.
(defparameter *main-match*
  '((:anesthesiology "Anesthesiology" 2987 2290)
    (:child-neurology "Child Neurology" 249 243)
    (:dermatology "Dermatology" 1099 602)
    (:emergency-medicine "Emergency Medicine" 3224 3198)
    (:family-medicine "Family Medicine" 4684 5491)
    (:internal-medicine "Internal Medicine" 14737 11632)
    (:internal-medicine-pediatrics "Internal Medicine/Pediatrics" 468 404)
    (:interventional-radiology-integrated "Interventional Radiology" 276 245)
    (:neurological-surgery "Neurological Surgery" 480 280)
    (:neurology "Neurology" 1689 1260)
    (:obstetrics-and-gynecology "Obstetrics and Gynecology" 1886 1638)
    (:occupational-and-environmental-medicine "Occupational & Environmental Medicine" 36 41)
    (:orthopaedic-surgery "Orthopaedic Surgery" 1598 963)
    (:osteopathic-neuromusculoskeletal-medicine "Osteopathic Neuromusculoskeletal Medicine" 12 40)
    (:otolaryngology-head-and-neck-surgery "Otolaryngology" 580 403)
    (:pathology-anatomic-and-clinical "Pathology-Anatomic and Clinical" 957 636)
    (:pediatrics "Pediatrics" 3021 3185)
    (:physical-medicine-and-rehabilitation "Physical Medicine and Rehabilitation" 828 601)
    (:plastic-surgery-integrated "Plastic Surgery" 406 230)
    (:public-health-and-general-preventive-medicine "Preventive Medicine" 61 63)
    (:psychiatry "Psychiatry" 2872 2516)
    (:radiation-oncology "Radiation Oncology" 222 187)
    (:diagnostic-radiology "Radiology-Diagnostic" 1419 1268)
    (:general-surgery "Surgery-General" 2760 1807)
    (:thoracic-surgery-integrated "Thoracic Surgery" 89 56)
    (:vascular-surgery-integrated "Vascular Surgery" 165 110)))

(defparameter *sms-match*
  '((:addiction-medicine "Addiction Medicine" 201 271)
    (:addiction-psychiatry "Addiction Psychiatry" 87 112)
    (:allergy-and-immunology "Allergy and Immunology" 241 177)
    (:pain-medicine "Pain Medicine" 355 390)
    (:emergency-medical-services "Emergency Medical Services" 125 144)
    (:medical-toxicology "Medical Toxicology" 45 54)
    (:adult-congenital-heart-disease "Adult Congenital Heart Disease" 26 25)
    (:advanced-heart-failure-and-transplant-cardiology "Advanced Heart Failure & Transplant Cardiology" 88 127)
    (:interventional-cardiology "Interventional Cardiology" 247 307)
    (:internal-medicine-critical-care-medicine "Critical Care Medicine" 439 242)
    (:endocrinology-diabetes-and-metabolism "Endocrinology, Diabetes, and Metabolism" 484 398)
    (:gastroenterology "Gastroenterology" 1247 759)
    (:geriatric-medicine "Geriatric Medicine" 192 388)
    (:hematology-and-medical-oncology "Hematology and Oncology" 1187 809)
    (:hospice-and-palliative-medicine "Hospice and Palliative Medicine" 451 478)
    (:infectious-disease "Infectious Disease" 319 447)
    (:interventional-pulmonology "Interventional Pulmonology" 66 51)
    (:medical-oncology "Oncology" 46 3)
    (:nephrology "Nephrology" 386 501)
    (:pulmonary-disease "Pulmonary Disease" 112 21)
    (:pulmonary-disease-and-critical-care-medicine "Pulmonary Disease and Critical Care Medicine" 1262 844)
    (:rheumatology "Rheumatology" 385 302)
    (:sleep-medicine "Sleep Medicine" 266 222)
    (:medical-genetics-and-genomics "Medical Genetics" 19 40)
    (:clinical-neurophysiology "Clinical Neurophysiology" 129 108)
    (:epilepsy "Epilepsy" 158 184)
    (:vascular-neurology "Vascular Neurology" 202 236)
    (:complex-family-planning "Complex Family Planning" 29 38)
    (:gynecologic-oncology "Gynecologic Oncology" 99 88)
    (:maternal-fetal-medicine "Maternal-Fetal Medicine" 163 166)
    (:reproductive-endocrinology-and-infertility "Reproductive Endocrinology" 73 59)
    (:urogynecology-and-reconstructive-pelvic-surgery "Urogynecology and Reconstructive Pelvic Surgery" 102 74)
    (:forensic-pathology "Forensic Pathology" 51 71)
    (:hematopathology "Hematopathology" 116 127)
    (:molecular-genetic-pathology "Molecular Genetic Pathology" 45 53)
    (:adolescent-medicine "Adolescent Medicine" 25 45)
    (:child-abuse-pediatrics "Child Abuse" 15 28)
    (:developmental-behavioral-pediatrics "Developmental and Behavioral Pediatrics" 36 50)
    (:neonatal-perinatal-medicine "Neonatal-Perinatal Medicine" 270 308)
    (:pediatric-cardiology "Pediatric Cardiology" 216 194)
    (:pediatric-critical-care-medicine "Pediatric Critical Care Medicine" 199 220)
    (:pediatric-emergency-medicine "Pediatric Emergency Medicine" 237 251)
    (:pediatric-endocrinology "Pediatric Endocrinology" 56 106)
    (:pediatric-gastroenterology "Pediatric Gastroenterology" 128 124)
    (:pediatric-hematology-oncology "Pediatric Hematology/Oncology" 158 194)
    (:pediatric-hospital-medicine "Pediatric Hospital Medicine" 141 143)
    (:pediatric-infectious-diseases "Pediatric Infectious Diseases" 51 86)
    (:pediatric-nephrology "Pediatric Nephrology" 32 73)
    (:pediatric-pulmonology "Pediatric Pulmonology" 59 87)
    (:pediatric-rheumatology "Pediatric Rheumatology" 25 44)
    (:pediatric-transplant-hepatology "Pediatric Transplant Hepatology" 8 15)
    (:brain-injury-medicine "Brain Injury Medicine" 22 30)
    (:pediatric-rehabilitation-medicine "Pediatric Rehabilitation Medicine" 15 29)
    (:spinal-cord-injury-medicine "Spinal Cord Injury Medicine" 23 33)
    (:child-and-adolescent-psychiatry "Child and Adolescent Psychiatry" 388 399)
    (:consultation-liaison-psychiatry "Consultation-Liaison Psychiatry" 91 133)
    (:forensic-psychiatry "Forensic Psychiatry" 91 125)
    (:interventional-radiology-independent "Interventional Radiology" 98 146)
    (:musculoskeletal-radiology "Musculoskeletal Radiology" 167 218)
    (:neuroradiology "Neuroradiology" 300 327)
    (:sports-medicine "Sports Medicine" 523 412)
    (:colon-and-rectal-surgery "Colon and Rectal Surgery" 171 121)
    (:hand-surgery "Hand Surgery" 184 201)
    (:pediatric-surgery "Pediatric Surgery" 66 47)
    (:surgical-critical-care "Surgical Critical Care" 315 365)
    (:complex-general-surgical-oncology "Surgical Oncology" 111 77)
    (:thoracic-surgery-independent "Thoracic Surgery" 168 97)
    (:vascular-surgery-independent "Vascular Surgery" 168 137)))

(defun benchmark-plist (row source definition)
  (destructuring-bind (id label candidates positions) row
    (list :id id :source-label label :candidates candidates :positions-offered positions
          :candidates-per-position (/ (float candidates 1d0) positions)
          :match-source source :candidate-definition definition :appointment-year 2026)))

(defun median (xs)
  (let* ((v (sort (copy-list xs) #'<)) (n (length v)))
    (if (oddp n) (nth (floor n 2) v)
        (/ (+ (nth (1- (/ n 2)) v) (nth (/ n 2) v)) 2d0))))

(let* ((training (read-one (merge-pathnames "data/specialty-training-paths.sexpr" *root*)))
       (points (getf training :specialties))
       (benchmarks (append
                    (mapcar (lambda (r) (benchmark-plist r :nrmp-main-2026 :first-or-only-choice-all-applicant-types)) *main-match*)
                    (mapcar (lambda (r) (benchmark-plist r :nrmp-sms-2026 :active-applicant-ranking-at-least-one-program)) *sms-match*)))
       (neutral (median (mapcar (lambda (b) (getf b :candidates-per-position)) benchmarks)))
       (point-table (mapcar (lambda (p) (cons (getf p :id) p)) points))
       (direct-table (mapcar (lambda (b) (cons (getf b :id) b)) benchmarks)))
  (labels ((resolve (id seen)
             (or (cdr (assoc id direct-table))
                 (unless (member id seen)
                   (let* ((p (cdr (assoc id point-table))) (parent (and p (getf p :parent))))
                     (and parent (not (eq parent :multiple)) (resolve parent (cons id seen))))))))
    (let* ((records
             (mapcar
              (lambda (p)
                (let* ((id (getf p :id)) (name (getf p :name)) (direct (cdr (assoc id direct-table)))
                       (donor (or direct (resolve id nil))))
                  (if donor
                      (list :id id :name name :candidates-per-position (getf donor :candidates-per-position)
                            :candidates (getf donor :candidates) :positions-offered (getf donor :positions-offered)
                            :candidate-definition (getf donor :candidate-definition)
                            :match-source (getf donor :match-source) :appointment-year 2026
                            :mapping (if direct :direct :inherited-from-training-parent)
                            :donor-id (getf donor :id) :confidence (if direct :high :low) :umap-use t)
                      (list :id id :name name :candidates-per-position neutral
                            :candidates nil :positions-offered nil :candidate-definition :not-reported-by-nrmp
                            :match-source :neutral-median-imputation :appointment-year 2026
                            :mapping :neutral-median-for-unreported-specialty :donor-id nil
                            :confidence :low :umap-use t))))
              points))
           (output
             (list :format :specialty-nrmp-competitiveness :version 1 :country :united-states :appointment-year 2026
                   :feature (list :id :candidates-per-position :type :continuous
                                  :direction :higher-means-more-competitive
                                  :recommended-transform :log2-then-z-score :umap-use-all-records t)
                   :sources
                   '((:id :nrmp-main-2026 :title "Results and Data: 2026 Main Residency Match"
                      :url "https://www.nrmp.org/wp-content/uploads/2026/05/Main_Match_Results_and_Data-2026.pdf"
                      :tables "11A-11C")
                     (:id :nrmp-sms-2026 :title "Results and Data: Specialties Matching Service, 2026 Appointment Year"
                      :url "https://www.nrmp.org/wp-content/uploads/2026/05/SMS_Results_and_Data_2026_Revised-20260522.pdf"
                      :table "1A")
                     (:id :methodology :path "../data-sources/nrmp-competitiveness-methodology.md"))
                   :notes
                   '("Candidates per position measures trainee demand relative to offered places, not probability of matching for an individual applicant."
                     "Main Match candidates are first-or-only-choice applicants across six applicant groups; SMS candidates are active applicants ranking at least one program."
                     "Applicants may participate in or rank more than one fellowship within combined matches."
                     "Non-NRMP and unreported specialties receive the direct-benchmark median as a neutral low-confidence value.")
                   :neutral-median-imputation neutral :benchmarks benchmarks :records records)))
      (with-open-file (out (merge-pathnames "data/specialty-nrmp-competitiveness.sexp" *root*)
                           :direction :output :if-exists :supersede :if-does-not-exist :create)
        (let ((*print-pretty* t) (*print-right-margin* 118)) (prin1 output out) (terpri out)))
      (format t "Wrote ~D records from ~D direct NRMP benchmarks; neutral median ~,4F.~%"
              (length records) (length benchmarks) neutral))))
