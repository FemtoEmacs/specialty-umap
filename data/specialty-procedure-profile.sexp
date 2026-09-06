(:FORMAT :SPECIALTY-PROCEDURE-PROFILE :VERSION 1 :COUNTRY :UNITED-STATES :AS-OF
 "2026-09-05" :UNIT :ORDINAL-PROCEDURAL-PRACTICE-INTENSITY
 :OPERATIONAL-DEFINITION
 "Extent to which physician-performed operative or invasive procedures are central to ordinary practice; routine examination, image interpretation, laboratory interpretation, and medication administration alone do not qualify."
 :SCALE
 ((:PREDOMINANTLY-CLINICAL 0.0d0) (:MIXED-PROCEDURAL-CLINICAL 0.5d0)
  (:PROCEDURE-DOMINANT 1.0d0))
 :METHOD :EXPLICIT-SPECIALTY-REVIEW :NOTES
 ("This is a practice-content feature, not a billing-volume estimate."
  "Individual physicians can have a different practice mix from their specialty category."
  "Mixed and disputed classifications are intentionally retained rather than forced into a binary label.")
 :RECORDS
 ((:ID :ALLERGY-AND-IMMUNOLOGY :NAME "Allergy and Immunology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :ANESTHESIOLOGY :NAME "Anesthesiology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :COLON-AND-RECTAL-SURGERY :NAME "Colon and Rectal Surgery"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :DERMATOLOGY :NAME "Dermatology" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :EMERGENCY-MEDICINE :NAME "Emergency Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :FAMILY-MEDICINE :NAME "Family Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :INTERNAL-MEDICINE :NAME "Internal Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MEDICAL-GENETICS-AND-GENOMICS :NAME "Medical Genetics and Genomics"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CLINICAL-BIOCHEMICAL-GENETICS :NAME "Clinical Biochemical Genetics"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :LABORATORY-GENETICS-AND-GENOMICS :NAME
   "Laboratory Genetics and Genomics" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEUROLOGICAL-SURGERY :NAME "Neurological Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :NEUROLOGY :NAME "Neurology" :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL
   :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CHILD-NEUROLOGY :NAME "Child Neurology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NUCLEAR-MEDICINE :NAME "Nuclear Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :OBSTETRICS-AND-GYNECOLOGY :NAME "Obstetrics and Gynecology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :OPHTHALMOLOGY :NAME "Ophthalmology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ORTHOPAEDIC-SURGERY :NAME "Orthopaedic Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :OSTEOPATHIC-NEUROMUSCULOSKELETAL-MEDICINE :NAME
   "Osteopathic Neuromusculoskeletal Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :OTOLARYNGOLOGY-HEAD-AND-NECK-SURGERY :NAME
   "Otolaryngology - Head and Neck Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PATHOLOGY-ANATOMIC-AND-CLINICAL :NAME
   "Pathology - Anatomic and Clinical" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRICS :NAME "Pediatrics" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PHYSICAL-MEDICINE-AND-REHABILITATION :NAME
   "Physical Medicine and Rehabilitation" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PLASTIC-SURGERY :NAME "Plastic Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PLASTIC-SURGERY-INTEGRATED :NAME "Plastic Surgery - Integrated"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PUBLIC-HEALTH-AND-GENERAL-PREVENTIVE-MEDICINE :NAME
   "Public Health and General Preventive Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :AEROSPACE-MEDICINE :NAME "Aerospace Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :OCCUPATIONAL-AND-ENVIRONMENTAL-MEDICINE :NAME
   "Occupational and Environmental Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PSYCHIATRY :NAME "Psychiatry" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :RADIATION-ONCOLOGY :NAME "Radiation Oncology" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :DIAGNOSTIC-RADIOLOGY :NAME "Diagnostic Radiology" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :INTERVENTIONAL-RADIOLOGY-INDEPENDENT :NAME
   "Interventional Radiology - Independent" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :INTERVENTIONAL-RADIOLOGY-INTEGRATED :NAME
   "Interventional Radiology - Integrated" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :GENERAL-SURGERY :NAME "General Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :VASCULAR-SURGERY-INTEGRATED :NAME "Vascular Surgery - Integrated"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :THORACIC-SURGERY-INDEPENDENT :NAME "Thoracic Surgery - Independent"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :THORACIC-SURGERY-INTEGRATED :NAME "Thoracic Surgery - Integrated"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :UROLOGY :NAME "Urology" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :INTERNAL-MEDICINE-PEDIATRICS :NAME "Internal Medicine/Pediatrics"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :ADULT-CARDIOTHORACIC-ANESTHESIOLOGY :NAME
   "Adult Cardiothoracic Anesthesiology" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ANESTHESIOLOGY-CRITICAL-CARE-MEDICINE :NAME
   "Anesthesiology Critical Care Medicine" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :OBSTETRIC-ANESTHESIOLOGY :NAME "Obstetric Anesthesiology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PAIN-MEDICINE :NAME "Pain Medicine" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-ANESTHESIOLOGY :NAME "Pediatric Anesthesiology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-CARDIAC-ANESTHESIOLOGY :NAME
   "Pediatric Cardiac Anesthesiology" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :REGIONAL-ANESTHESIOLOGY-AND-ACUTE-PAIN-MEDICINE :NAME
   "Regional Anesthesiology and Acute Pain Medicine" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :DERMATOPATHOLOGY :NAME "Dermatopathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MICROGRAPHIC-SURGERY-AND-DERMATOLOGIC-ONCOLOGY :NAME
   "Micrographic Surgery and Dermatologic Oncology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-DERMATOLOGY :NAME "Pediatric Dermatology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :EMERGENCY-MEDICAL-SERVICES :NAME "Emergency Medical Services"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :MEDICAL-TOXICOLOGY :NAME "Medical Toxicology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-EMERGENCY-MEDICINE :NAME "Pediatric Emergency Medicine"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :SPORTS-MEDICINE :NAME "Sports Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :UNDERSEA-AND-HYPERBARIC-MEDICINE :NAME
   "Undersea and Hyperbaric Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CLINICAL-INFORMATICS :NAME "Clinical Informatics" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :GERIATRIC-MEDICINE :NAME "Geriatric Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :HOSPICE-AND-PALLIATIVE-MEDICINE :NAME "Hospice and Palliative Medicine"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CARDIOLOGY :NAME "Cardiology (Cardiovascular Disease)"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :ADULT-CONGENITAL-HEART-DISEASE :NAME "Adult Congenital Heart Disease"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :ADVANCED-HEART-FAILURE-AND-TRANSPLANT-CARDIOLOGY :NAME
   "Advanced Heart Failure and Transplant Cardiology" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :CARDIAC-ELECTROPHYSIOLOGY :NAME "Clinical Cardiac Electrophysiology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :INTERVENTIONAL-CARDIOLOGY :NAME "Interventional Cardiology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :INTERNAL-MEDICINE-CRITICAL-CARE-MEDICINE :NAME
   "Internal Medicine Critical Care Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :ENDOCRINOLOGY-DIABETES-AND-METABOLISM :NAME
   "Endocrinology, Diabetes, and Metabolism" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :GASTROENTEROLOGY :NAME "Gastroenterology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :HEMATOLOGY-AND-MEDICAL-ONCOLOGY :NAME "Hematology and Medical Oncology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :INFECTIOUS-DISEASE :NAME "Infectious Disease" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :INTERVENTIONAL-PULMONOLOGY :NAME "Interventional Pulmonology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :MEDICAL-ONCOLOGY :NAME "Medical Oncology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEPHROLOGY :NAME "Nephrology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PULMONARY-DISEASE :NAME "Pulmonary Disease" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PULMONARY-DISEASE-AND-CRITICAL-CARE-MEDICINE :NAME
   "Pulmonary Disease and Critical Care Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :RHEUMATOLOGY :NAME "Rheumatology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :SLEEP-MEDICINE :NAME "Sleep Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :TRANSPLANT-HEPATOLOGY :NAME "Transplant Hepatology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MEDICAL-BIOCHEMICAL-GENETICS :NAME "Medical Biochemical Genetics"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MOLECULAR-GENETIC-PATHOLOGY :NAME "Molecular Genetic Pathology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CLINICAL-NEUROPHYSIOLOGY :NAME "Clinical Neurophysiology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :EPILEPSY :NAME "Epilepsy" :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL
   :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEUROCRITICAL-CARE :NAME "Neurocritical Care" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :NEURODEVELOPMENTAL-DISABILITIES :NAME "Neurodevelopmental Disabilities"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEUROMUSCULAR-MEDICINE :NAME "Neuromuscular Medicine"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :VASCULAR-NEUROLOGY :NAME "Vascular Neurology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :COMPLEX-FAMILY-PLANNING :NAME "Complex Family Planning"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :GYNECOLOGIC-ONCOLOGY :NAME "Gynecologic Oncology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :MATERNAL-FETAL-MEDICINE :NAME "Maternal-Fetal Medicine"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :REPRODUCTIVE-ENDOCRINOLOGY-AND-INFERTILITY :NAME
   "Reproductive Endocrinology and Infertility" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :UROGYNECOLOGY-AND-RECONSTRUCTIVE-PELVIC-SURGERY :NAME
   "Urogynecology and Reconstructive Pelvic Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :OPHTHALMIC-PLASTIC-AND-RECONSTRUCTIVE-SURGERY :NAME
   "Ophthalmic Plastic and Reconstructive Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ADULT-RECONSTRUCTIVE-ORTHOPAEDICS :NAME
   "Adult Reconstructive Orthopaedics" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :FOOT-AND-ANKLE-ORTHOPAEDICS :NAME "Foot and Ankle Orthopaedics"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :HAND-SURGERY :NAME "Hand Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :MUSCULOSKELETAL-ONCOLOGY :NAME "Musculoskeletal Oncology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ORTHOPAEDIC-SPORTS-MEDICINE :NAME "Orthopaedic Sports Medicine"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ORTHOPAEDIC-SURGERY-OF-THE-SPINE :NAME
   "Orthopaedic Surgery of the Spine" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ORTHOPAEDIC-TRAUMA :NAME "Orthopaedic Trauma" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-ORTHOPAEDICS :NAME "Pediatric Orthopaedics"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :NEUROTOLOGY :NAME "Neurotology" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-OTOLARYNGOLOGY :NAME "Pediatric Otolaryngology"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :BLOOD-BANKING-TRANSFUSION-MEDICINE :NAME
   "Blood Banking/Transfusion Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CHEMICAL-PATHOLOGY :NAME "Chemical Pathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CYTOPATHOLOGY :NAME "Cytopathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :FORENSIC-PATHOLOGY :NAME "Forensic Pathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :HEMATOPATHOLOGY :NAME "Hematopathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MEDICAL-MICROBIOLOGY :NAME "Medical Microbiology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEUROPATHOLOGY :NAME "Neuropathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-PATHOLOGY :NAME "Pediatric Pathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :SELECTIVE-PATHOLOGY :NAME "Selective Pathology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :ADOLESCENT-MEDICINE :NAME "Adolescent Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CHILD-ABUSE-PEDIATRICS :NAME "Child Abuse Pediatrics"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :DEVELOPMENTAL-BEHAVIORAL-PEDIATRICS :NAME
   "Developmental-Behavioral Pediatrics" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEONATAL-PERINATAL-MEDICINE :NAME "Neonatal-Perinatal Medicine"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PEDIATRIC-CARDIOLOGY :NAME "Pediatric Cardiology" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PEDIATRIC-CRITICAL-CARE-MEDICINE :NAME
   "Pediatric Critical Care Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PEDIATRIC-ENDOCRINOLOGY :NAME "Pediatric Endocrinology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-GASTROENTEROLOGY :NAME "Pediatric Gastroenterology"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PEDIATRIC-HEMATOLOGY-ONCOLOGY :NAME "Pediatric Hematology/Oncology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-INFECTIOUS-DISEASES :NAME "Pediatric Infectious Diseases"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-NEPHROLOGY :NAME "Pediatric Nephrology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-PULMONOLOGY :NAME "Pediatric Pulmonology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-RHEUMATOLOGY :NAME "Pediatric Rheumatology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-TRANSPLANT-HEPATOLOGY :NAME "Pediatric Transplant Hepatology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-HOSPITAL-MEDICINE :NAME "Pediatric Hospital Medicine"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :BRAIN-INJURY-MEDICINE :NAME "Brain Injury Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :SPINAL-CORD-INJURY-MEDICINE :NAME "Spinal Cord Injury Medicine"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :PEDIATRIC-REHABILITATION-MEDICINE :NAME
   "Pediatric Rehabilitation Medicine" :PROCEDURE-PROFILE
   :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :CRANIOFACIAL-SURGERY :NAME "Craniofacial Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :ADDICTION-MEDICINE :NAME "Addiction Medicine" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :ADDICTION-PSYCHIATRY :NAME "Addiction Psychiatry" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CHILD-AND-ADOLESCENT-PSYCHIATRY :NAME "Child and Adolescent Psychiatry"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :FORENSIC-PSYCHIATRY :NAME "Forensic Psychiatry" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :GERIATRIC-PSYCHIATRY :NAME "Geriatric Psychiatry" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :CONSULTATION-LIAISON-PSYCHIATRY :NAME "Consultation-Liaison Psychiatry"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :ABDOMINAL-RADIOLOGY :NAME "Abdominal Radiology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :MUSCULOSKELETAL-RADIOLOGY :NAME "Musculoskeletal Radiology"
   :PROCEDURE-PROFILE :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NEURORADIOLOGY :NAME "Neuroradiology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :NUCLEAR-RADIOLOGY :NAME "Nuclear Radiology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :PEDIATRIC-RADIOLOGY :NAME "Pediatric Radiology" :PROCEDURE-PROFILE
   :PREDOMINANTLY-CLINICAL :PROCEDURE-INTENSITY 0.0d0 :CONFIDENCE :MEDIUM
   :RATIONALE
   "Invasive or operative procedures are not central to ordinary practice.")
  (:ID :COMPLEX-GENERAL-SURGICAL-ONCOLOGY :NAME
   "Complex General Surgical Oncology" :PROCEDURE-PROFILE :PROCEDURE-DOMINANT
   :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-SURGERY :NAME "Pediatric Surgery" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :SURGICAL-CRITICAL-CARE :NAME "Surgical Critical Care"
   :PROCEDURE-PROFILE :MIXED-PROCEDURAL-CLINICAL :PROCEDURE-INTENSITY 0.5d0
   :CONFIDENCE :MEDIUM :RATIONALE
   "Practice commonly combines longitudinal/diagnostic care with physician-performed procedures.")
  (:ID :VASCULAR-SURGERY-INDEPENDENT :NAME "Vascular Surgery - Independent"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :CONGENITAL-CARDIAC-SURGERY :NAME "Congenital Cardiac Surgery"
   :PROCEDURE-PROFILE :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0
   :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")
  (:ID :PEDIATRIC-UROLOGY :NAME "Pediatric Urology" :PROCEDURE-PROFILE
   :PROCEDURE-DOMINANT :PROCEDURE-INTENSITY 1.0d0 :CONFIDENCE :HIGH :RATIONALE
   "Operative or invasive intervention is central to ordinary practice.")))
