(:format :specialty-salary-feature :version 2 :country :united-states :as-of "2026-09-05" :population
 :full-time-physicians :point-key :id :feature
 (:id :average-total-compensation-usd :unit :nominal-usd-per-year :statistic :mean :includes
  (:base-salary :bonuses :other-income) :recommended-transform :log10-then-z-score :umap-use
  :all-records-including-low-confidence :confidence-weighting :none)
 :source
 (:publisher "Marit Health" :title "Physician Salary in US" :url
  "https://www.marithealth.com/o/-/physician/salary" :displayed-year 2026 :retrieved "2026-09-05" :note
  "Marit states that averages remove outliers and apply de-biasing adjustments; supplied specialty values were verified against the live Browse specialties list.")
 :method-notes
 ("Salary means average annual total compensation for full-time physicians, not base salary, median compensation, or compensation per wRVU."
  "Oncology and Hematology Oncology are separate direct Marit categories and separate UMAP points: $638,000 and $587,000 respectively."
  "The standalone Hematology source value is retained but unused because the current point universe has no hematology-only point."
  "Source categories absent from the ACGME point universe—Bariatric Medicine, Oral Maxillofacial Surgery, Podiatry, Urgent Care, and Wound Care—are retained but not mapped as points."
  "Inherited salaries are estimates, not direct subspecialty observations."
  "Per user instruction all records, including low-confidence estimates, are enabled for UMAP without confidence weighting.")
 :source-salaries
 ((:id :allergy-and-immunology :label "Allergy & Immunology" :average-total-compensation-usd 368000 :url-path
   "/o/-/allergist/salary")
  (:id :anesthesiology :label "Anesthesiology" :average-total-compensation-usd 570000 :url-path
   "/o/-/anesthesiologist/salary")
  (:id :bariatric-medicine :label "Bariatric Medicine" :average-total-compensation-usd 359000 :point-universe
   :not-present)
  (:id :cardiology :label "Cardiology" :average-total-compensation-usd 634000 :url-path
   "/o/-/cardiologist/salary")
  (:id :dermatology :label "Dermatology" :average-total-compensation-usd 536000 :url-path
   "/o/-/dermatologist/salary")
  (:id :emergency-medicine :label "Emergency Medicine" :average-total-compensation-usd 440000 :url-path
   "/o/-/emergency-medicine-physician/salary")
  (:id :endocrinology :label "Endocrinology" :average-total-compensation-usd 320000 :url-path
   "/o/-/endocrinologist/salary")
  (:id :family-medicine :label "Family Medicine" :average-total-compensation-usd 314000 :url-path
   "/o/-/family-medicine-physician/salary")
  (:id :gastroenterology :label "Gastroenterology" :average-total-compensation-usd 626000 :url-path
   "/o/-/gastroenterologist/salary")
  (:id :genetics :label "Genetics" :average-total-compensation-usd 240000 :url-path "/o/-/geneticist/salary")
  (:id :hematology :label "Hematology" :average-total-compensation-usd 574000 :point-universe
   :no-hematology-only-point)
  (:id :hematology-oncology :label "Hematology Oncology" :average-total-compensation-usd 587000 :url-path
   "/o/-/hematologist-oncologist/salary")
  (:id :hepatology :label "Hepatology" :average-total-compensation-usd 459000 :url-path
   "/o/-/hepatologist/salary")
  (:id :infectious-disease :label "Infectious Disease" :average-total-compensation-usd 321000 :url-path
   "/o/-/infectious-disease-physician/salary")
  (:id :internal-medicine :label "Internal Medicine" :average-total-compensation-usd 327000 :url-path
   "/o/-/internist/salary")
  (:id :nephrology :label "Nephrology" :average-total-compensation-usd 385000 :url-path
   "/o/-/nephrologist/salary")
  (:id :neurology :label "Neurology" :average-total-compensation-usd 370000 :url-path
   "/o/-/neurologist/salary")
  (:id :neuromusculoskeletal-medicine :label "Neuromusculoskeletal Medicine" :average-total-compensation-usd
   242000 :url-path "/o/-/neuromusculoskeletal-physician/salary")
  (:id :neurological-surgery :label "Neurosurgery" :average-total-compensation-usd 988000 :url-path
   "/o/-/neurosurgeon/salary")
  (:id :nuclear-medicine :label "Nuclear Medicine" :average-total-compensation-usd 376000 :url-path
   "/o/-/nuclear-medicine-physician/salary")
  (:id :obstetrics-gynecology :label "Obstetrics & Gynecology" :average-total-compensation-usd 410000 :url-path
   "/o/-/obgyn/salary")
  (:id :medical-oncology :label "Oncology" :average-total-compensation-usd 638000 :url-path
   "/o/-/oncologist/salary")
  (:id :ophthalmology :label "Ophthalmology" :average-total-compensation-usd 553000 :url-path
   "/o/-/ophthalmologist/salary")
  (:id :oral-maxillofacial-surgery :label "Oral Maxillofacial Surgery" :average-total-compensation-usd 667000
   :point-universe :not-present)
  (:id :orthopaedic-surgery :label "Orthopedic Surgery" :average-total-compensation-usd 801000 :url-path
   "/o/-/orthopedic-surgeon/salary")
  (:id :otolaryngology :label "Otolaryngology" :average-total-compensation-usd 613000 :url-path
   "/o/-/ent/salary")
  (:id :pathology :label "Pathology" :average-total-compensation-usd 409000 :url-path
   "/o/-/pathologist/salary")
  (:id :pediatrics :label "Pediatrics" :average-total-compensation-usd 265000 :url-path
   "/o/-/pediatrician/salary")
  (:id :physical-medicine-rehabilitation :label "Physical Medicine & Rehabilitation"
   :average-total-compensation-usd 348000 :url-path "/o/-/physiatrist/salary")
  (:id :plastic-surgery :label "Plastic Surgery" :average-total-compensation-usd 725000 :url-path
   "/o/-/plastic-surgeon/salary")
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
  (:id :wound-care :label "Wound Care" :average-total-compensation-usd 344000 :point-universe :not-present))
 :specialties
 ((:id :allergy-and-immunology :name "Allergy and Immunology" :average-total-compensation-usd 368000
   :confidence :high :basis :direct-marit-category :salary-donor-id :allergy-and-immunology :umap-use t)
  (:id :anesthesiology :name "Anesthesiology" :average-total-compensation-usd 570000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :anesthesiology :umap-use t)
  (:id :colon-and-rectal-surgery :name "Colon and Rectal Surgery" :average-total-compensation-usd 513000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery :umap-use t)
  (:id :dermatology :name "Dermatology" :average-total-compensation-usd 536000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :dermatology :umap-use t)
  (:id :emergency-medicine :name "Emergency Medicine" :average-total-compensation-usd 440000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :emergency-medicine :umap-use t)
  (:id :family-medicine :name "Family Medicine" :average-total-compensation-usd 314000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :family-medicine :umap-use t)
  (:id :internal-medicine :name "Internal Medicine" :average-total-compensation-usd 327000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :internal-medicine :umap-use t)
  (:id :medical-genetics-and-genomics :name "Medical Genetics and Genomics" :average-total-compensation-usd
   240000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :genetics :umap-use t)
  (:id :clinical-biochemical-genetics :name "Clinical Biochemical Genetics" :average-total-compensation-usd
   240000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :genetics :umap-use t)
  (:id :laboratory-genetics-and-genomics :name "Laboratory Genetics and Genomics"
   :average-total-compensation-usd 240000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :genetics :umap-use t)
  (:id :neurological-surgery :name "Neurological Surgery" :average-total-compensation-usd 988000 :confidence
   :high :basis :direct-marit-category :salary-donor-id :neurological-surgery :umap-use t)
  (:id :neurology :name "Neurology" :average-total-compensation-usd 370000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :neurology :umap-use t)
  (:id :child-neurology :name "Child Neurology" :average-total-compensation-usd 370000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :nuclear-medicine :name "Nuclear Medicine" :average-total-compensation-usd 376000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :nuclear-medicine :umap-use t)
  (:id :obstetrics-and-gynecology :name "Obstetrics and Gynecology" :average-total-compensation-usd 410000
   :confidence :high :basis :direct-marit-category :salary-donor-id :obstetrics-gynecology :umap-use t)
  (:id :ophthalmology :name "Ophthalmology" :average-total-compensation-usd 553000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :ophthalmology :umap-use t)
  (:id :orthopaedic-surgery :name "Orthopaedic Surgery" :average-total-compensation-usd 801000 :confidence
   :high :basis :direct-marit-category :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :osteopathic-neuromusculoskeletal-medicine :name "Osteopathic Neuromusculoskeletal Medicine"
   :average-total-compensation-usd 242000 :confidence :high :basis :direct-marit-category :salary-donor-id
   :neuromusculoskeletal-medicine :umap-use t)
  (:id :otolaryngology-head-and-neck-surgery :name "Otolaryngology - Head and Neck Surgery"
   :average-total-compensation-usd 613000 :confidence :high :basis :direct-marit-category :salary-donor-id
   :otolaryngology :umap-use t)
  (:id :pathology-anatomic-and-clinical :name "Pathology - Anatomic and Clinical"
   :average-total-compensation-usd 409000 :confidence :high :basis :direct-marit-category :salary-donor-id
   :pathology :umap-use t)
  (:id :pediatrics :name "Pediatrics" :average-total-compensation-usd 265000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :pediatrics :umap-use t)
  (:id :physical-medicine-and-rehabilitation :name "Physical Medicine and Rehabilitation"
   :average-total-compensation-usd 348000 :confidence :high :basis :direct-marit-category :salary-donor-id
   :physical-medicine-rehabilitation :umap-use t)
  (:id :plastic-surgery :name "Plastic Surgery" :average-total-compensation-usd 725000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :plastic-surgery :umap-use t)
  (:id :plastic-surgery-integrated :name "Plastic Surgery - Integrated" :average-total-compensation-usd 725000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :plastic-surgery :umap-use t)
  (:id :public-health-and-general-preventive-medicine :name "Public Health and General Preventive Medicine"
   :average-total-compensation-usd 365000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :preventive-medicine :umap-use t)
  (:id :aerospace-medicine :name "Aerospace Medicine" :average-total-compensation-usd 365000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :preventive-medicine :umap-use t)
  (:id :occupational-and-environmental-medicine :name "Occupational and Environmental Medicine"
   :average-total-compensation-usd 365000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :preventive-medicine :umap-use t)
  (:id :psychiatry :name "Psychiatry" :average-total-compensation-usd 351000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :psychiatry :umap-use t)
  (:id :radiation-oncology :name "Radiation Oncology" :average-total-compensation-usd 647000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :radiation-oncology :umap-use t)
  (:id :diagnostic-radiology :name "Diagnostic Radiology" :average-total-compensation-usd 691000 :confidence
   :high :basis :direct-marit-category :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :interventional-radiology-independent :name "Interventional Radiology - Independent"
   :average-total-compensation-usd 691000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :interventional-radiology-integrated :name "Interventional Radiology - Integrated"
   :average-total-compensation-usd 691000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :general-surgery :name "General Surgery" :average-total-compensation-usd 513000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :general-surgery :umap-use t)
  (:id :vascular-surgery-integrated :name "Vascular Surgery - Integrated" :average-total-compensation-usd
   513000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery
   :umap-use t)
  (:id :thoracic-surgery-independent :name "Thoracic Surgery - Independent" :average-total-compensation-usd
   513000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery
   :umap-use t)
  (:id :thoracic-surgery-integrated :name "Thoracic Surgery - Integrated" :average-total-compensation-usd
   513000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery
   :umap-use t)
  (:id :urology :name "Urology" :average-total-compensation-usd 639000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :urology :umap-use t)
  (:id :internal-medicine-pediatrics :name "Internal Medicine/Pediatrics" :average-total-compensation-usd
   265000 :confidence :low :basis :estimated-nearest-category :salary-donor-id :pediatrics :umap-use t)
  (:id :adult-cardiothoracic-anesthesiology :name "Adult Cardiothoracic Anesthesiology"
   :average-total-compensation-usd 570000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :anesthesiology :umap-use t)
  (:id :anesthesiology-critical-care-medicine :name "Anesthesiology Critical Care Medicine"
   :average-total-compensation-usd 570000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :anesthesiology :umap-use t)
  (:id :obstetric-anesthesiology :name "Obstetric Anesthesiology" :average-total-compensation-usd 570000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :anesthesiology :umap-use t)
  (:id :pain-medicine :name "Pain Medicine" :average-total-compensation-usd 348000 :confidence :low :basis
   :estimated-nearest-category :salary-donor-id :physical-medicine-rehabilitation :umap-use t)
  (:id :pediatric-anesthesiology :name "Pediatric Anesthesiology" :average-total-compensation-usd 570000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :anesthesiology :umap-use t)
  (:id :pediatric-cardiac-anesthesiology :name "Pediatric Cardiac Anesthesiology"
   :average-total-compensation-usd 570000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :anesthesiology :umap-use t)
  (:id :regional-anesthesiology-and-acute-pain-medicine :name "Regional Anesthesiology and Acute Pain Medicine"
   :average-total-compensation-usd 570000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :anesthesiology :umap-use t)
  (:id :dermatopathology :name "Dermatopathology" :average-total-compensation-usd 536000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :dermatology :umap-use t)
  (:id :micrographic-surgery-and-dermatologic-oncology :name "Micrographic Surgery and Dermatologic Oncology"
   :average-total-compensation-usd 536000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :dermatology :umap-use t)
  (:id :pediatric-dermatology :name "Pediatric Dermatology" :average-total-compensation-usd 536000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :dermatology :umap-use t)
  (:id :emergency-medical-services :name "Emergency Medical Services" :average-total-compensation-usd 440000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :emergency-medicine :umap-use
   t)
  (:id :medical-toxicology :name "Medical Toxicology" :average-total-compensation-usd 440000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :emergency-medicine :umap-use t)
  (:id :pediatric-emergency-medicine :name "Pediatric Emergency Medicine" :average-total-compensation-usd
   265000 :confidence :low :basis :estimated-nearest-category :salary-donor-id :pediatrics :umap-use t)
  (:id :sports-medicine :name "Sports Medicine" :average-total-compensation-usd 801000 :confidence :low :basis
   :estimated-nearest-category :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :undersea-and-hyperbaric-medicine :name "Undersea and Hyperbaric Medicine"
   :average-total-compensation-usd 440000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :emergency-medicine :umap-use t)
  (:id :clinical-informatics :name "Clinical Informatics" :average-total-compensation-usd 327000 :confidence
   :low :basis :estimated-nearest-category :salary-donor-id :internal-medicine :umap-use t)
  (:id :geriatric-medicine :name "Geriatric Medicine" :average-total-compensation-usd 327000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :internal-medicine :umap-use t)
  (:id :hospice-and-palliative-medicine :name "Hospice and Palliative Medicine" :average-total-compensation-usd
   327000 :confidence :low :basis :estimated-nearest-category :salary-donor-id :internal-medicine :umap-use t)
  (:id :cardiology :name "Cardiology (Cardiovascular Disease)" :average-total-compensation-usd 634000
   :confidence :high :basis :direct-marit-category :salary-donor-id :cardiology :umap-use t)
  (:id :adult-congenital-heart-disease :name "Adult Congenital Heart Disease" :average-total-compensation-usd
   634000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :cardiology :umap-use
   t)
  (:id :advanced-heart-failure-and-transplant-cardiology :name
   "Advanced Heart Failure and Transplant Cardiology" :average-total-compensation-usd 634000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :cardiology :umap-use t)
  (:id :cardiac-electrophysiology :name "Clinical Cardiac Electrophysiology" :average-total-compensation-usd
   634000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :cardiology :umap-use
   t)
  (:id :interventional-cardiology :name "Interventional Cardiology" :average-total-compensation-usd 634000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :cardiology :umap-use t)
  (:id :internal-medicine-critical-care-medicine :name "Internal Medicine Critical Care Medicine"
   :average-total-compensation-usd 327000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :internal-medicine :umap-use t)
  (:id :endocrinology-diabetes-and-metabolism :name "Endocrinology, Diabetes, and Metabolism"
   :average-total-compensation-usd 320000 :confidence :high :basis :direct-marit-category :salary-donor-id
   :endocrinology :umap-use t)
  (:id :gastroenterology :name "Gastroenterology" :average-total-compensation-usd 626000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :gastroenterology :umap-use t)
  (:id :hematology-and-medical-oncology :name "Hematology and Medical Oncology" :average-total-compensation-usd
   587000 :confidence :high :basis :direct-marit-category :salary-donor-id :hematology-oncology :umap-use t)
  (:id :infectious-disease :name "Infectious Disease" :average-total-compensation-usd 321000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :infectious-disease :umap-use t)
  (:id :interventional-pulmonology :name "Interventional Pulmonology" :average-total-compensation-usd 484000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pulmonology :umap-use t)
  (:id :medical-oncology :name "Medical Oncology" :average-total-compensation-usd 638000 :confidence :high
   :basis :direct-marit-category :salary-donor-id :medical-oncology :umap-use t)
  (:id :nephrology :name "Nephrology" :average-total-compensation-usd 385000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :nephrology :umap-use t)
  (:id :pulmonary-disease :name "Pulmonary Disease" :average-total-compensation-usd 484000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pulmonology :umap-use t)
  (:id :pulmonary-disease-and-critical-care-medicine :name "Pulmonary Disease and Critical Care Medicine"
   :average-total-compensation-usd 484000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :pulmonology :umap-use t)
  (:id :rheumatology :name "Rheumatology" :average-total-compensation-usd 318000 :confidence :high :basis
   :direct-marit-category :salary-donor-id :rheumatology :umap-use t)
  (:id :sleep-medicine :name "Sleep Medicine" :average-total-compensation-usd 327000 :confidence :low :basis
   :estimated-nearest-category :salary-donor-id :internal-medicine :umap-use t)
  (:id :transplant-hepatology :name "Transplant Hepatology" :average-total-compensation-usd 459000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :hepatology :umap-use t)
  (:id :medical-biochemical-genetics :name "Medical Biochemical Genetics" :average-total-compensation-usd
   240000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :genetics :umap-use t)
  (:id :molecular-genetic-pathology :name "Molecular Genetic Pathology" :average-total-compensation-usd 240000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :genetics :umap-use t)
  (:id :clinical-neurophysiology :name "Clinical Neurophysiology" :average-total-compensation-usd 370000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :epilepsy :name "Epilepsy" :average-total-compensation-usd 370000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :neurocritical-care :name "Neurocritical Care" :average-total-compensation-usd 370000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :neurodevelopmental-disabilities :name "Neurodevelopmental Disabilities" :average-total-compensation-usd
   327000 :confidence :low :basis :estimated-nearest-category :salary-donor-id :internal-medicine :umap-use t)
  (:id :neuromuscular-medicine :name "Neuromuscular Medicine" :average-total-compensation-usd 370000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :vascular-neurology :name "Vascular Neurology" :average-total-compensation-usd 370000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :neurology :umap-use t)
  (:id :complex-family-planning :name "Complex Family Planning" :average-total-compensation-usd 410000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :obstetrics-gynecology
   :umap-use t)
  (:id :gynecologic-oncology :name "Gynecologic Oncology" :average-total-compensation-usd 410000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :obstetrics-gynecology :umap-use t)
  (:id :maternal-fetal-medicine :name "Maternal-Fetal Medicine" :average-total-compensation-usd 410000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :obstetrics-gynecology
   :umap-use t)
  (:id :reproductive-endocrinology-and-infertility :name "Reproductive Endocrinology and Infertility"
   :average-total-compensation-usd 410000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :obstetrics-gynecology :umap-use t)
  (:id :urogynecology-and-reconstructive-pelvic-surgery :name "Urogynecology and Reconstructive Pelvic Surgery"
   :average-total-compensation-usd 410000 :confidence :low :basis :estimated-nearest-category :salary-donor-id
   :obstetrics-gynecology :umap-use t)
  (:id :ophthalmic-plastic-and-reconstructive-surgery :name "Ophthalmic Plastic and Reconstructive Surgery"
   :average-total-compensation-usd 553000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :ophthalmology :umap-use t)
  (:id :adult-reconstructive-orthopaedics :name "Adult Reconstructive Orthopaedics"
   :average-total-compensation-usd 801000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :foot-and-ankle-orthopaedics :name "Foot and Ankle Orthopaedics" :average-total-compensation-usd 801000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use
   t)
  (:id :hand-surgery :name "Hand Surgery" :average-total-compensation-usd 801000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :musculoskeletal-oncology :name "Musculoskeletal Oncology" :average-total-compensation-usd 801000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use
   t)
  (:id :orthopaedic-sports-medicine :name "Orthopaedic Sports Medicine" :average-total-compensation-usd 801000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use
   t)
  (:id :orthopaedic-surgery-of-the-spine :name "Orthopaedic Surgery of the Spine"
   :average-total-compensation-usd 801000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :orthopaedic-trauma :name "Orthopaedic Trauma" :average-total-compensation-usd 801000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use t)
  (:id :pediatric-orthopaedics :name "Pediatric Orthopaedics" :average-total-compensation-usd 801000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :orthopaedic-surgery :umap-use
   t)
  (:id :neurotology :name "Neurotology" :average-total-compensation-usd 613000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :otolaryngology :umap-use t)
  (:id :pediatric-otolaryngology :name "Pediatric Otolaryngology" :average-total-compensation-usd 613000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :otolaryngology :umap-use t)
  (:id :blood-banking-transfusion-medicine :name "Blood Banking/Transfusion Medicine"
   :average-total-compensation-usd 409000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :pathology :umap-use t)
  (:id :chemical-pathology :name "Chemical Pathology" :average-total-compensation-usd 409000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :cytopathology :name "Cytopathology" :average-total-compensation-usd 409000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :forensic-pathology :name "Forensic Pathology" :average-total-compensation-usd 409000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :hematopathology :name "Hematopathology" :average-total-compensation-usd 409000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :medical-microbiology :name "Medical Microbiology" :average-total-compensation-usd 409000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :neuropathology :name "Neuropathology" :average-total-compensation-usd 409000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :pediatric-pathology :name "Pediatric Pathology" :average-total-compensation-usd 409000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :selective-pathology :name "Selective Pathology" :average-total-compensation-usd 409000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pathology :umap-use t)
  (:id :adolescent-medicine :name "Adolescent Medicine" :average-total-compensation-usd 265000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :child-abuse-pediatrics :name "Child Abuse Pediatrics" :average-total-compensation-usd 265000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :developmental-behavioral-pediatrics :name "Developmental-Behavioral Pediatrics"
   :average-total-compensation-usd 265000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :pediatrics :umap-use t)
  (:id :neonatal-perinatal-medicine :name "Neonatal-Perinatal Medicine" :average-total-compensation-usd 265000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :pediatric-cardiology :name "Pediatric Cardiology" :average-total-compensation-usd 634000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :cardiology :umap-use t)
  (:id :pediatric-critical-care-medicine :name "Pediatric Critical Care Medicine"
   :average-total-compensation-usd 265000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :pediatrics :umap-use t)
  (:id :pediatric-endocrinology :name "Pediatric Endocrinology" :average-total-compensation-usd 265000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :pediatric-gastroenterology :name "Pediatric Gastroenterology" :average-total-compensation-usd 626000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :gastroenterology :umap-use t)
  (:id :pediatric-hematology-oncology :name "Pediatric Hematology/Oncology" :average-total-compensation-usd
   265000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use
   t)
  (:id :pediatric-infectious-diseases :name "Pediatric Infectious Diseases" :average-total-compensation-usd
   321000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :infectious-disease
   :umap-use t)
  (:id :pediatric-nephrology :name "Pediatric Nephrology" :average-total-compensation-usd 385000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :nephrology :umap-use t)
  (:id :pediatric-pulmonology :name "Pediatric Pulmonology" :average-total-compensation-usd 265000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :pediatric-rheumatology :name "Pediatric Rheumatology" :average-total-compensation-usd 318000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :rheumatology :umap-use t)
  (:id :pediatric-transplant-hepatology :name "Pediatric Transplant Hepatology" :average-total-compensation-usd
   459000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :hepatology :umap-use
   t)
  (:id :pediatric-hospital-medicine :name "Pediatric Hospital Medicine" :average-total-compensation-usd 265000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :brain-injury-medicine :name "Brain Injury Medicine" :average-total-compensation-usd 348000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :physical-medicine-rehabilitation
   :umap-use t)
  (:id :spinal-cord-injury-medicine :name "Spinal Cord Injury Medicine" :average-total-compensation-usd 348000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id
   :physical-medicine-rehabilitation :umap-use t)
  (:id :pediatric-rehabilitation-medicine :name "Pediatric Rehabilitation Medicine"
   :average-total-compensation-usd 265000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :pediatrics :umap-use t)
  (:id :craniofacial-surgery :name "Craniofacial Surgery" :average-total-compensation-usd 725000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :plastic-surgery :umap-use t)
  (:id :addiction-medicine :name "Addiction Medicine" :average-total-compensation-usd 327000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :internal-medicine :umap-use t)
  (:id :addiction-psychiatry :name "Addiction Psychiatry" :average-total-compensation-usd 351000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :psychiatry :umap-use t)
  (:id :child-and-adolescent-psychiatry :name "Child and Adolescent Psychiatry" :average-total-compensation-usd
   265000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use
   t)
  (:id :forensic-psychiatry :name "Forensic Psychiatry" :average-total-compensation-usd 351000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :psychiatry :umap-use t)
  (:id :geriatric-psychiatry :name "Geriatric Psychiatry" :average-total-compensation-usd 351000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :psychiatry :umap-use t)
  (:id :consultation-liaison-psychiatry :name "Consultation-Liaison Psychiatry" :average-total-compensation-usd
   351000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :psychiatry :umap-use
   t)
  (:id :abdominal-radiology :name "Abdominal Radiology" :average-total-compensation-usd 691000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :musculoskeletal-radiology :name "Musculoskeletal Radiology" :average-total-compensation-usd 691000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :diagnostic-radiology
   :umap-use t)
  (:id :neuroradiology :name "Neuroradiology" :average-total-compensation-usd 691000 :confidence :medium :basis
   :parent-or-subspecialty-crosswalk :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :nuclear-radiology :name "Nuclear Radiology" :average-total-compensation-usd 691000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :diagnostic-radiology :umap-use t)
  (:id :pediatric-radiology :name "Pediatric Radiology" :average-total-compensation-usd 265000 :confidence
   :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :complex-general-surgical-oncology :name "Complex General Surgical Oncology"
   :average-total-compensation-usd 513000 :confidence :medium :basis :parent-or-subspecialty-crosswalk
   :salary-donor-id :general-surgery :umap-use t)
  (:id :pediatric-surgery :name "Pediatric Surgery" :average-total-compensation-usd 265000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)
  (:id :surgical-critical-care :name "Surgical Critical Care" :average-total-compensation-usd 513000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery :umap-use t)
  (:id :vascular-surgery-independent :name "Vascular Surgery - Independent" :average-total-compensation-usd
   513000 :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery
   :umap-use t)
  (:id :congenital-cardiac-surgery :name "Congenital Cardiac Surgery" :average-total-compensation-usd 513000
   :confidence :medium :basis :parent-or-subspecialty-crosswalk :salary-donor-id :general-surgery :umap-use t)
  (:id :pediatric-urology :name "Pediatric Urology" :average-total-compensation-usd 265000 :confidence :medium
   :basis :parent-or-subspecialty-crosswalk :salary-donor-id :pediatrics :umap-use t)))
