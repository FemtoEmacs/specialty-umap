(:format :specialty-private-practice-feature :version 2 :country :united-states :survey-year 2024 :point-key
 :id :feature
 (:id :private-practice-percent :label "Physicians in practices wholly owned by physicians" :unit :percent
  :range (0.0 100.0) :umap-use :all-records-including-low-confidence :recommended-transform :z-score
  :confidence-weighting :none)
 :source
 (:publisher "American Medical Association" :author "Carol K. Kane" :title
  "Physician Practice Characteristics in 2024: Private Practices Account for Less Than Half of Physicians in Most Specialties"
  :url "https://www.ama-assn.org/system/files/2024-prp-pp-characteristics.pdf" :exhibit 2 :sample-size 5000
  :specialty-minimum-n 100 :survey-period "late August through late September 2024" :response-rate-percent 43
  :retrieved "2026-09-05")
 :definition-notes
 ("Private practice means a practice wholly owned by one or more physicians in the practice."
  "It does not mean solo practice, practice ownership by the individual respondent, or merely a non-hospital work site."
  "Survey estimates are weighted to represent eligible US patient-care physicians; federal employees and physicians providing under 20 patient-care hours per week are excluded."
  "High confidence denotes an ACGME point directly matching a plotted AMA category."
  "Medium confidence denotes a subspecialty assigned to an explicitly plotted AMA grouped or parent category."
  "Low confidence denotes a best-available guess using the AMA overall or Other category where membership is not published."
  "Per user instruction, every record including low-confidence estimates is enabled for UMAP without confidence weighting.")
 :source-categories
 ((:id :cardiology :label "Cardiology" :private-practice-percent 30.7)
  (:id :general-surgery :label "General surgery" :private-practice-percent 31.7)
  (:id :emergency-medicine :label "Emergency medicine" :private-practice-percent 33.2)
  (:id :pediatrics :label "Pediatrics" :private-practice-percent 38.1)
  (:id :internal-medicine :label "Internal medicine" :private-practice-percent 38.9)
  (:id :internal-medicine-subspecialties :label "Internal medicine subspecialties" :private-practice-percent
   39.2)
  (:id :family-medicine :label "Family medicine" :private-practice-percent 42.2)
  (:id :all-physicians :label "All physicians" :private-practice-percent 42.2)
  (:id :other :label "Other" :private-practice-percent 43.6)
  (:id :psychiatry :label "Psychiatry" :private-practice-percent 45.2)
  (:id :obstetrics-gynecology :label "Obstetrics/gynecology" :private-practice-percent 46.3)
  (:id :anesthesiology :label "Anesthesiology" :private-practice-percent 46.4)
  (:id :radiology :label "Radiology" :private-practice-percent 46.9)
  (:id :surgical-subspecialties :label "Other surgical subspecialties" :private-practice-percent 51.2)
  (:id :orthopaedic-surgery :label "Orthopedic surgery" :private-practice-percent 54.0)
  (:id :ophthalmology :label "Ophthalmology" :private-practice-percent 70.4))
 :specialties
 ((:id :allergy-and-immunology :name "Allergy and Immunology" :private-practice-percent 39.2 :confidence
   :medium :basis :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :anesthesiology :name "Anesthesiology" :private-practice-percent 46.4 :confidence :high :basis
   :observed-category :source-category :anesthesiology :umap-use t)
  (:id :colon-and-rectal-surgery :name "Colon and Rectal Surgery" :private-practice-percent 51.2 :confidence
   :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :dermatology :name "Dermatology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :emergency-medicine :name "Emergency Medicine" :private-practice-percent 33.2 :confidence :high :basis
   :observed-category :source-category :emergency-medicine :umap-use t)
  (:id :family-medicine :name "Family Medicine" :private-practice-percent 42.2 :confidence :high :basis
   :observed-category :source-category :family-medicine :umap-use t)
  (:id :internal-medicine :name "Internal Medicine" :private-practice-percent 38.9 :confidence :high :basis
   :observed-category :source-category :internal-medicine :umap-use t)
  (:id :medical-genetics-and-genomics :name "Medical Genetics and Genomics" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :clinical-biochemical-genetics :name "Clinical Biochemical Genetics" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :laboratory-genetics-and-genomics :name "Laboratory Genetics and Genomics" :private-practice-percent
   43.6 :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :neurological-surgery :name "Neurological Surgery" :private-practice-percent 51.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :neurology :name "Neurology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :child-neurology :name "Child Neurology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :nuclear-medicine :name "Nuclear Medicine" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :obstetrics-and-gynecology :name "Obstetrics and Gynecology" :private-practice-percent 46.3 :confidence
   :high :basis :observed-category :source-category :obstetrics-gynecology :umap-use t)
  (:id :ophthalmology :name "Ophthalmology" :private-practice-percent 70.4 :confidence :high :basis
   :observed-category :source-category :ophthalmology :umap-use t)
  (:id :orthopaedic-surgery :name "Orthopaedic Surgery" :private-practice-percent 54.0 :confidence :high :basis
   :observed-category :source-category :orthopaedic-surgery :umap-use t)
  (:id :osteopathic-neuromusculoskeletal-medicine :name "Osteopathic Neuromusculoskeletal Medicine"
   :private-practice-percent 43.6 :confidence :low :basis :estimated-from-other-category :source-category
   :other :umap-use t)
  (:id :otolaryngology-head-and-neck-surgery :name "Otolaryngology - Head and Neck Surgery"
   :private-practice-percent 51.2 :confidence :medium :basis :group-category-crosswalk :source-category
   :surgical-subspecialties :umap-use t)
  (:id :pathology-anatomic-and-clinical :name "Pathology - Anatomic and Clinical" :private-practice-percent
   43.6 :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :pediatrics :name "Pediatrics" :private-practice-percent 38.1 :confidence :high :basis
   :observed-category :source-category :pediatrics :umap-use t)
  (:id :physical-medicine-and-rehabilitation :name "Physical Medicine and Rehabilitation"
   :private-practice-percent 43.6 :confidence :low :basis :estimated-from-other-category :source-category
   :other :umap-use t)
  (:id :plastic-surgery :name "Plastic Surgery" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :plastic-surgery-integrated :name "Plastic Surgery - Integrated" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :public-health-and-general-preventive-medicine :name "Public Health and General Preventive Medicine"
   :private-practice-percent 43.6 :confidence :low :basis :estimated-from-other-category :source-category
   :other :umap-use t)
  (:id :aerospace-medicine :name "Aerospace Medicine" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :occupational-and-environmental-medicine :name "Occupational and Environmental Medicine"
   :private-practice-percent 43.6 :confidence :low :basis :estimated-from-other-category :source-category
   :other :umap-use t)
  (:id :psychiatry :name "Psychiatry" :private-practice-percent 45.2 :confidence :high :basis
   :observed-category :source-category :psychiatry :umap-use t)
  (:id :radiation-oncology :name "Radiation Oncology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :diagnostic-radiology :name "Diagnostic Radiology" :private-practice-percent 46.9 :confidence :high
   :basis :observed-category :source-category :radiology :umap-use t)
  (:id :interventional-radiology-independent :name "Interventional Radiology - Independent"
   :private-practice-percent 46.9 :confidence :medium :basis :group-category-crosswalk :source-category
   :radiology :umap-use t)
  (:id :interventional-radiology-integrated :name "Interventional Radiology - Integrated"
   :private-practice-percent 46.9 :confidence :medium :basis :group-category-crosswalk :source-category
   :radiology :umap-use t)
  (:id :general-surgery :name "General Surgery" :private-practice-percent 31.7 :confidence :high :basis
   :observed-category :source-category :general-surgery :umap-use t)
  (:id :vascular-surgery-integrated :name "Vascular Surgery - Integrated" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :thoracic-surgery-independent :name "Thoracic Surgery - Independent" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :thoracic-surgery-integrated :name "Thoracic Surgery - Integrated" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :urology :name "Urology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :internal-medicine-pediatrics :name "Internal Medicine/Pediatrics" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :adult-cardiothoracic-anesthesiology :name "Adult Cardiothoracic Anesthesiology"
   :private-practice-percent 46.4 :confidence :medium :basis :group-category-crosswalk :source-category
   :anesthesiology :umap-use t)
  (:id :anesthesiology-critical-care-medicine :name "Anesthesiology Critical Care Medicine"
   :private-practice-percent 46.4 :confidence :medium :basis :group-category-crosswalk :source-category
   :anesthesiology :umap-use t)
  (:id :obstetric-anesthesiology :name "Obstetric Anesthesiology" :private-practice-percent 46.4 :confidence
   :medium :basis :group-category-crosswalk :source-category :anesthesiology :umap-use t)
  (:id :pain-medicine :name "Pain Medicine" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :pediatric-anesthesiology :name "Pediatric Anesthesiology" :private-practice-percent 46.4 :confidence
   :medium :basis :group-category-crosswalk :source-category :anesthesiology :umap-use t)
  (:id :pediatric-cardiac-anesthesiology :name "Pediatric Cardiac Anesthesiology" :private-practice-percent
   46.4 :confidence :medium :basis :group-category-crosswalk :source-category :anesthesiology :umap-use t)
  (:id :regional-anesthesiology-and-acute-pain-medicine :name "Regional Anesthesiology and Acute Pain Medicine"
   :private-practice-percent 46.4 :confidence :medium :basis :group-category-crosswalk :source-category
   :anesthesiology :umap-use t)
  (:id :dermatopathology :name "Dermatopathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :micrographic-surgery-and-dermatologic-oncology :name "Micrographic Surgery and Dermatologic Oncology"
   :private-practice-percent 51.2 :confidence :medium :basis :group-category-crosswalk :source-category
   :surgical-subspecialties :umap-use t)
  (:id :pediatric-dermatology :name "Pediatric Dermatology" :private-practice-percent 38.1 :confidence :medium
   :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :emergency-medical-services :name "Emergency Medical Services" :private-practice-percent 33.2
   :confidence :medium :basis :group-category-crosswalk :source-category :emergency-medicine :umap-use t)
  (:id :medical-toxicology :name "Medical Toxicology" :private-practice-percent 33.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :emergency-medicine :umap-use t)
  (:id :pediatric-emergency-medicine :name "Pediatric Emergency Medicine" :private-practice-percent 38.1
   :confidence :low :basis :ambiguous-multidisciplinary-crosswalk :source-category :pediatrics :umap-use t)
  (:id :sports-medicine :name "Sports Medicine" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :undersea-and-hyperbaric-medicine :name "Undersea and Hyperbaric Medicine" :private-practice-percent
   33.2 :confidence :medium :basis :group-category-crosswalk :source-category :emergency-medicine :umap-use t)
  (:id :clinical-informatics :name "Clinical Informatics" :private-practice-percent 43.6 :confidence :low
   :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :geriatric-medicine :name "Geriatric Medicine" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :hospice-and-palliative-medicine :name "Hospice and Palliative Medicine" :private-practice-percent 39.2
   :confidence :medium :basis :group-category-crosswalk :source-category :internal-medicine-subspecialties
   :umap-use t)
  (:id :cardiology :name "Cardiology (Cardiovascular Disease)" :private-practice-percent 30.7 :confidence :high
   :basis :observed-category :source-category :cardiology :umap-use t)
  (:id :adult-congenital-heart-disease :name "Adult Congenital Heart Disease" :private-practice-percent 30.7
   :confidence :medium :basis :group-category-crosswalk :source-category :cardiology :umap-use t)
  (:id :advanced-heart-failure-and-transplant-cardiology :name
   "Advanced Heart Failure and Transplant Cardiology" :private-practice-percent 30.7 :confidence :medium :basis
   :group-category-crosswalk :source-category :cardiology :umap-use t)
  (:id :cardiac-electrophysiology :name "Clinical Cardiac Electrophysiology" :private-practice-percent 30.7
   :confidence :medium :basis :group-category-crosswalk :source-category :cardiology :umap-use t)
  (:id :interventional-cardiology :name "Interventional Cardiology" :private-practice-percent 30.7 :confidence
   :medium :basis :group-category-crosswalk :source-category :cardiology :umap-use t)
  (:id :internal-medicine-critical-care-medicine :name "Internal Medicine Critical Care Medicine"
   :private-practice-percent 39.2 :confidence :medium :basis :group-category-crosswalk :source-category
   :internal-medicine-subspecialties :umap-use t)
  (:id :endocrinology-diabetes-and-metabolism :name "Endocrinology, Diabetes, and Metabolism"
   :private-practice-percent 39.2 :confidence :medium :basis :group-category-crosswalk :source-category
   :internal-medicine-subspecialties :umap-use t)
  (:id :gastroenterology :name "Gastroenterology" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :hematology-and-medical-oncology :name "Hematology and Medical Oncology" :private-practice-percent 39.2
   :confidence :medium :basis :group-category-crosswalk :source-category :internal-medicine-subspecialties
   :umap-use t)
  (:id :infectious-disease :name "Infectious Disease" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :interventional-pulmonology :name "Interventional Pulmonology" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :medical-oncology :name "Medical Oncology" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :nephrology :name "Nephrology" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :pulmonary-disease :name "Pulmonary Disease" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :pulmonary-disease-and-critical-care-medicine :name "Pulmonary Disease and Critical Care Medicine"
   :private-practice-percent 39.2 :confidence :medium :basis :group-category-crosswalk :source-category
   :internal-medicine-subspecialties :umap-use t)
  (:id :rheumatology :name "Rheumatology" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :sleep-medicine :name "Sleep Medicine" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :transplant-hepatology :name "Transplant Hepatology" :private-practice-percent 39.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :medical-biochemical-genetics :name "Medical Biochemical Genetics" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :molecular-genetic-pathology :name "Molecular Genetic Pathology" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :clinical-neurophysiology :name "Clinical Neurophysiology" :private-practice-percent 43.6 :confidence
   :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :epilepsy :name "Epilepsy" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :neurocritical-care :name "Neurocritical Care" :private-practice-percent 39.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :internal-medicine-subspecialties :umap-use t)
  (:id :neurodevelopmental-disabilities :name "Neurodevelopmental Disabilities" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :neuromuscular-medicine :name "Neuromuscular Medicine" :private-practice-percent 43.6 :confidence :low
   :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :vascular-neurology :name "Vascular Neurology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :complex-family-planning :name "Complex Family Planning" :private-practice-percent 46.3 :confidence
   :medium :basis :group-category-crosswalk :source-category :obstetrics-gynecology :umap-use t)
  (:id :gynecologic-oncology :name "Gynecologic Oncology" :private-practice-percent 46.3 :confidence :medium
   :basis :group-category-crosswalk :source-category :obstetrics-gynecology :umap-use t)
  (:id :maternal-fetal-medicine :name "Maternal-Fetal Medicine" :private-practice-percent 46.3 :confidence
   :medium :basis :group-category-crosswalk :source-category :obstetrics-gynecology :umap-use t)
  (:id :reproductive-endocrinology-and-infertility :name "Reproductive Endocrinology and Infertility"
   :private-practice-percent 46.3 :confidence :medium :basis :group-category-crosswalk :source-category
   :obstetrics-gynecology :umap-use t)
  (:id :urogynecology-and-reconstructive-pelvic-surgery :name "Urogynecology and Reconstructive Pelvic Surgery"
   :private-practice-percent 46.3 :confidence :medium :basis :group-category-crosswalk :source-category
   :obstetrics-gynecology :umap-use t)
  (:id :ophthalmic-plastic-and-reconstructive-surgery :name "Ophthalmic Plastic and Reconstructive Surgery"
   :private-practice-percent 70.4 :confidence :medium :basis :group-category-crosswalk :source-category
   :ophthalmology :umap-use t)
  (:id :adult-reconstructive-orthopaedics :name "Adult Reconstructive Orthopaedics" :private-practice-percent
   54.0 :confidence :medium :basis :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :foot-and-ankle-orthopaedics :name "Foot and Ankle Orthopaedics" :private-practice-percent 54.0
   :confidence :medium :basis :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :hand-surgery :name "Hand Surgery" :private-practice-percent 54.0 :confidence :medium :basis
   :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :musculoskeletal-oncology :name "Musculoskeletal Oncology" :private-practice-percent 43.6 :confidence
   :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :orthopaedic-sports-medicine :name "Orthopaedic Sports Medicine" :private-practice-percent 54.0
   :confidence :medium :basis :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :orthopaedic-surgery-of-the-spine :name "Orthopaedic Surgery of the Spine" :private-practice-percent
   54.0 :confidence :medium :basis :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :orthopaedic-trauma :name "Orthopaedic Trauma" :private-practice-percent 54.0 :confidence :medium :basis
   :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :pediatric-orthopaedics :name "Pediatric Orthopaedics" :private-practice-percent 54.0 :confidence
   :medium :basis :group-category-crosswalk :source-category :orthopaedic-surgery :umap-use t)
  (:id :neurotology :name "Neurotology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :pediatric-otolaryngology :name "Pediatric Otolaryngology" :private-practice-percent 51.2 :confidence
   :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :blood-banking-transfusion-medicine :name "Blood Banking/Transfusion Medicine" :private-practice-percent
   43.6 :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :chemical-pathology :name "Chemical Pathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :cytopathology :name "Cytopathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :forensic-pathology :name "Forensic Pathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :hematopathology :name "Hematopathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :medical-microbiology :name "Medical Microbiology" :private-practice-percent 43.6 :confidence :low
   :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :neuropathology :name "Neuropathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :pediatric-pathology :name "Pediatric Pathology" :private-practice-percent 38.1 :confidence :medium
   :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :selective-pathology :name "Selective Pathology" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :adolescent-medicine :name "Adolescent Medicine" :private-practice-percent 38.1 :confidence :medium
   :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :child-abuse-pediatrics :name "Child Abuse Pediatrics" :private-practice-percent 38.1 :confidence
   :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :developmental-behavioral-pediatrics :name "Developmental-Behavioral Pediatrics"
   :private-practice-percent 38.1 :confidence :medium :basis :group-category-crosswalk :source-category
   :pediatrics :umap-use t)
  (:id :neonatal-perinatal-medicine :name "Neonatal-Perinatal Medicine" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-cardiology :name "Pediatric Cardiology" :private-practice-percent 30.7 :confidence :medium
   :basis :group-category-crosswalk :source-category :cardiology :umap-use t)
  (:id :pediatric-critical-care-medicine :name "Pediatric Critical Care Medicine" :private-practice-percent
   38.1 :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-endocrinology :name "Pediatric Endocrinology" :private-practice-percent 38.1 :confidence
   :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-gastroenterology :name "Pediatric Gastroenterology" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-hematology-oncology :name "Pediatric Hematology/Oncology" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-infectious-diseases :name "Pediatric Infectious Diseases" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-nephrology :name "Pediatric Nephrology" :private-practice-percent 38.1 :confidence :medium
   :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-pulmonology :name "Pediatric Pulmonology" :private-practice-percent 38.1 :confidence :medium
   :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-rheumatology :name "Pediatric Rheumatology" :private-practice-percent 38.1 :confidence
   :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-transplant-hepatology :name "Pediatric Transplant Hepatology" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :pediatric-hospital-medicine :name "Pediatric Hospital Medicine" :private-practice-percent 38.1
   :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :brain-injury-medicine :name "Brain Injury Medicine" :private-practice-percent 43.6 :confidence :low
   :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :spinal-cord-injury-medicine :name "Spinal Cord Injury Medicine" :private-practice-percent 43.6
   :confidence :low :basis :estimated-from-other-category :source-category :other :umap-use t)
  (:id :pediatric-rehabilitation-medicine :name "Pediatric Rehabilitation Medicine" :private-practice-percent
   38.1 :confidence :medium :basis :group-category-crosswalk :source-category :pediatrics :umap-use t)
  (:id :craniofacial-surgery :name "Craniofacial Surgery" :private-practice-percent 51.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :addiction-medicine :name "Addiction Medicine" :private-practice-percent 43.6 :confidence :low :basis
   :estimated-from-other-category :source-category :other :umap-use t)
  (:id :addiction-psychiatry :name "Addiction Psychiatry" :private-practice-percent 45.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :psychiatry :umap-use t)
  (:id :child-and-adolescent-psychiatry :name "Child and Adolescent Psychiatry" :private-practice-percent 45.2
   :confidence :medium :basis :group-category-crosswalk :source-category :psychiatry :umap-use t)
  (:id :forensic-psychiatry :name "Forensic Psychiatry" :private-practice-percent 45.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :psychiatry :umap-use t)
  (:id :geriatric-psychiatry :name "Geriatric Psychiatry" :private-practice-percent 45.2 :confidence :medium
   :basis :group-category-crosswalk :source-category :psychiatry :umap-use t)
  (:id :consultation-liaison-psychiatry :name "Consultation-Liaison Psychiatry" :private-practice-percent 45.2
   :confidence :medium :basis :group-category-crosswalk :source-category :psychiatry :umap-use t)
  (:id :abdominal-radiology :name "Abdominal Radiology" :private-practice-percent 46.9 :confidence :medium
   :basis :group-category-crosswalk :source-category :radiology :umap-use t)
  (:id :musculoskeletal-radiology :name "Musculoskeletal Radiology" :private-practice-percent 46.9 :confidence
   :medium :basis :group-category-crosswalk :source-category :radiology :umap-use t)
  (:id :neuroradiology :name "Neuroradiology" :private-practice-percent 46.9 :confidence :medium :basis
   :group-category-crosswalk :source-category :radiology :umap-use t)
  (:id :nuclear-radiology :name "Nuclear Radiology" :private-practice-percent 46.9 :confidence :medium :basis
   :group-category-crosswalk :source-category :radiology :umap-use t)
  (:id :pediatric-radiology :name "Pediatric Radiology" :private-practice-percent 46.9 :confidence :medium
   :basis :group-category-crosswalk :source-category :radiology :umap-use t)
  (:id :complex-general-surgical-oncology :name "Complex General Surgical Oncology" :private-practice-percent
   51.2 :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties
   :umap-use t)
  (:id :pediatric-surgery :name "Pediatric Surgery" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :surgical-critical-care :name "Surgical Critical Care" :private-practice-percent 51.2 :confidence
   :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :vascular-surgery-independent :name "Vascular Surgery - Independent" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :congenital-cardiac-surgery :name "Congenital Cardiac Surgery" :private-practice-percent 51.2
   :confidence :medium :basis :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)
  (:id :pediatric-urology :name "Pediatric Urology" :private-practice-percent 51.2 :confidence :medium :basis
   :group-category-crosswalk :source-category :surgical-subspecialties :umap-use t)))
