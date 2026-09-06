#!/usr/bin/env sbcl --script

;;; Build research-intensity features for the same 143 specialty points.
;;; The common quantitative backbone is Table 1 of Shah et al. (2011-2020 NIH
;;; awards), because it supplies a consistent specialty definition and an
;;; active-physician denominator. Other literature is retained as context.

(defparameter *root* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *training-file* (merge-pathnames "../data/specialty-training-paths.sexpr" *root*))
(defparameter *output-file* (merge-pathnames "../data/specialty-scientific-activity.sexpr" *root*))

(defun read-one (path)
  (with-open-file (stream path :direction :input) (read stream)))

(defun contains-p (needle keyword)
  (search needle (string-downcase (symbol-name keyword))))

;; Exact transcription of Table 1. Funding is inflation-adjusted to 2011 USD.
(defparameter *nih-specialty-benchmarks*
  '((:id :pathology :paper-label "Pathology" :funding-rank 1 :grants 14946 :grant-share-percent 8.1 :grants-per-active-physician-per-year 0.112 :funding-million-usd 6366.7 :funding-share-percent 7.6 :mean-active-physicians 13311 :funding-thousand-usd-per-active-physician-per-year 47.8)
    (:id :neurology :paper-label "Neurology" :funding-rank 2 :grants 12448 :grant-share-percent 6.8 :grants-per-active-physician-per-year 0.092 :funding-million-usd 6001.6 :funding-share-percent 7.2 :mean-active-physicians 13539 :funding-thousand-usd-per-active-physician-per-year 44.3)
    (:id :internal-medicine :paper-label "Internal medicine/medicine" :funding-rank 3 :grants 72205 :grant-share-percent 39.2 :grants-per-active-physician-per-year 0.063 :funding-million-usd 36022.6 :funding-share-percent 43.2 :mean-active-physicians 114639 :funding-thousand-usd-per-active-physician-per-year 31.4)
    (:id :psychiatry :paper-label "Psychiatry" :funding-rank 4 :grants 19029 :grant-share-percent 10.3 :grants-per-active-physician-per-year 0.050 :funding-million-usd 8267.6 :funding-share-percent 9.9 :mean-active-physicians 38089 :funding-thousand-usd-per-active-physician-per-year 21.7)
    (:id :neurological-surgery :paper-label "Neurosurgery" :funding-rank 5 :grants 2956 :grant-share-percent 1.6 :grants-per-active-physician-per-year 0.055 :funding-million-usd 1111.6 :funding-share-percent 1.3 :mean-active-physicians 5410 :funding-thousand-usd-per-active-physician-per-year 20.5)
    (:id :pediatrics :paper-label "Paediatrics" :funding-rank 6 :grants 17422 :grant-share-percent 9.4 :grants-per-active-physician-per-year 0.030 :funding-million-usd 7896.5 :funding-share-percent 9.5 :mean-active-physicians 57967 :funding-thousand-usd-per-active-physician-per-year 13.6)
    (:id :ophthalmology :paper-label "Ophthalmology" :funding-rank 7 :grants 5957 :grant-share-percent 3.2 :grants-per-active-physician-per-year 0.032 :funding-million-usd 2380.8 :funding-share-percent 2.9 :mean-active-physicians 18684 :funding-thousand-usd-per-active-physician-per-year 12.7)
    (:id :general-surgery :paper-label "Surgery" :funding-rank 8 :grants 8171 :grant-share-percent 4.4 :grants-per-active-physician-per-year 0.032 :funding-million-usd 3212.5 :funding-share-percent 3.9 :mean-active-physicians 25378 :funding-thousand-usd-per-active-physician-per-year 12.7)
    (:id :otolaryngology :paper-label "Otolaryngology" :funding-rank 9 :grants 3198 :grant-share-percent 1.7 :grants-per-active-physician-per-year 0.034 :funding-million-usd 1102.3 :funding-share-percent 1.3 :mean-active-physicians 9485 :funding-thousand-usd-per-active-physician-per-year 11.6)
    (:id :radiation-diagnostic-oncology :paper-label "Radiation-diagnostic/oncology" :funding-rank 10 :grants 9562 :grant-share-percent 5.2 :grants-per-active-physician-per-year 0.025 :funding-million-usd 3999.4 :funding-share-percent 4.8 :mean-active-physicians 38702 :funding-thousand-usd-per-active-physician-per-year 10.3)
    (:id :dermatology :paper-label "Dermatology" :funding-rank 11 :grants 2270 :grant-share-percent 1.2 :grants-per-active-physician-per-year 0.019 :funding-million-usd 764.5 :funding-share-percent 0.9 :mean-active-physicians 11803 :funding-thousand-usd-per-active-physician-per-year 6.5)
    (:id :urology :paper-label "Urology" :funding-rank 12 :grants 1474 :grant-share-percent 0.8 :grants-per-active-physician-per-year 0.015 :funding-million-usd 572.7 :funding-share-percent 0.7 :mean-active-physicians 9922 :funding-thousand-usd-per-active-physician-per-year 5.8)
    (:id :obstetrics-gynecology :paper-label "Obstetrics and gynaecology" :funding-rank 13 :grants 4343 :grant-share-percent 2.4 :grants-per-active-physician-per-year 0.010 :funding-million-usd 1697.8 :funding-share-percent 2.0 :mean-active-physicians 41552 :funding-thousand-usd-per-active-physician-per-year 4.1)
    (:id :physical-medicine-rehabilitation :paper-label "Physical medicine and rehabilitation" :funding-rank 14 :grants 1124 :grant-share-percent 0.6 :grants-per-active-physician-per-year 0.012 :funding-million-usd 357.9 :funding-share-percent 0.4 :mean-active-physicians 9220 :funding-thousand-usd-per-active-physician-per-year 3.9)
    (:id :orthopaedic-surgery :paper-label "Orthopaedics" :funding-rank 15 :grants 2218 :grant-share-percent 1.2 :grants-per-active-physician-per-year 0.012 :funding-million-usd 750.2 :funding-share-percent 0.9 :mean-active-physicians 19222 :funding-thousand-usd-per-active-physician-per-year 3.9)
    (:id :anesthesiology :paper-label "Anaesthesiology" :funding-rank 16 :grants 3770 :grant-share-percent 2.0 :grants-per-active-physician-per-year 0.0091 :funding-million-usd 1434.7 :funding-share-percent 1.7 :mean-active-physicians 41391 :funding-thousand-usd-per-active-physician-per-year 3.5)
    (:id :emergency-medicine :paper-label "Emergency medicine" :funding-rank 17 :grants 1258 :grant-share-percent 0.7 :grants-per-active-physician-per-year 0.0031 :funding-million-usd 550.2 :funding-share-percent 0.7 :mean-active-physicians 40395 :funding-thousand-usd-per-active-physician-per-year 1.4)
    (:id :family-medicine :paper-label "Family medicine" :funding-rank 18 :grants 2015 :grant-share-percent 1.1 :grants-per-active-physician-per-year 0.0018 :funding-million-usd 848.5 :funding-share-percent 1.0 :mean-active-physicians 112396 :funding-thousand-usd-per-active-physician-per-year 0.8)
    (:id :plastic-surgery :paper-label "Plastic surgery" :funding-rank 19 :grants 16 :grant-share-percent 0.0 :grants-per-active-physician-per-year 0.00023 :funding-million-usd 4.6 :funding-share-percent 0.0 :mean-active-physicians 7079 :funding-thousand-usd-per-active-physician-per-year 0.1)))

(defun benchmark-for (id)
  (cond
    ((or (eq id :anesthesiology) (contains-p "anesthesiology" id)) :anesthesiology)
    ((or (eq id :neurological-surgery) (contains-p "neurosurg" id)) :neurological-surgery)
    ((or (eq id :pathology-anatomic-and-clinical) (contains-p "pathology" id)
         (contains-p "genetic" id) (contains-p "blood-banking" id)
         (contains-p "medical-microbiology" id)) :pathology)
    ((or (eq id :diagnostic-radiology) (eq id :radiation-oncology)
         (contains-p "radiology" id) (contains-p "nuclear-medicine" id)) :radiation-diagnostic-oncology)
    ((or (eq id :orthopaedic-surgery) (contains-p "orthopaedic" id)
         (contains-p "sports-medicine" id) (contains-p "hand-surgery" id)
         (contains-p "musculoskeletal-oncology" id)) :orthopaedic-surgery)
    ((or (eq id :plastic-surgery) (eq id :plastic-surgery-integrated)
         (contains-p "craniofacial" id)) :plastic-surgery)
    ((or (eq id :otolaryngology-head-and-neck-surgery) (contains-p "otolaryng" id)
         (contains-p "neurotology" id)) :otolaryngology)
    ((or (eq id :urology) (contains-p "urolog" id)) :urology)
    ((or (eq id :obstetrics-and-gynecology) (contains-p "gynec" id)
         (contains-p "obstetric" id) (contains-p "maternal-fetal" id)
         (contains-p "family-planning" id) (contains-p "reproductive" id)) :obstetrics-gynecology)
    ((or (eq id :psychiatry) (contains-p "psychiatr" id)
         (contains-p "addiction" id)) :psychiatry)
    ((or (eq id :physical-medicine-and-rehabilitation) (contains-p "rehabilitation" id)
         (contains-p "brain-injury" id) (contains-p "spinal-cord-injury" id)
         (contains-p "neuromusculoskeletal" id) (contains-p "pain-medicine" id))
     :physical-medicine-rehabilitation)
    ((or (eq id :neurology) (eq id :child-neurology) (contains-p "neuro" id)
         (contains-p "epilepsy" id)) :neurology)
    ((or (eq id :pediatrics) (contains-p "pediatric" id) (contains-p "adolescent" id)
         (contains-p "neonatal" id) (contains-p "child-abuse" id)
         (contains-p "developmental-behavioral" id)) :pediatrics)
    ((or (eq id :dermatology) (contains-p "dermat" id)) :dermatology)
    ((or (eq id :ophthalmology) (contains-p "ophthalm" id)) :ophthalmology)
    ((eq id :emergency-medicine) :emergency-medicine)
    ((or (eq id :family-medicine) (contains-p "preventive" id)
         (contains-p "occupational" id) (contains-p "aerospace" id)) :family-medicine)
    ((or (eq id :general-surgery) (contains-p "surgery" id) (contains-p "surgical" id)
         (contains-p "colon-and-rectal" id)) :general-surgery)
    (t :internal-medicine)))

(defun match-kind (id donor)
  (cond
    ((member id '(:pathology-anatomic-and-clinical :otolaryngology-head-and-neck-surgery
                  :obstetrics-and-gynecology :physical-medicine-and-rehabilitation)) :direct-name-crosswalk)
    ((eq id donor) :direct)
    ((and (eq donor :radiation-diagnostic-oncology)
          (member id '(:diagnostic-radiology :radiation-oncology))) :component-of-combined-category)
    (t :nearest-available)))

(let* ((training (read-one *training-file*))
       (points (getf training :specialties))
       (records
         (mapcar (lambda (point)
                   (let* ((id (getf point :id))
                          (donor (benchmark-for id))
                          (match (match-kind id donor)))
                     (list :id id :name (getf point :name)
                           :nih-benchmark-id donor
                           :match match
                           :imputed-p (not (null (member match '(:nearest-available :component-of-combined-category)))))))
                 points))
       (document
         (list
          :format :specialty-scientific-activity-features
          :version 1
          :country :united-states
          :study-period '(2011 2020)
          :point-key :id
          :umap-features
          '((:id :nih-grants-per-active-physician-per-year
             :source-field :grants-per-active-physician-per-year
             :recommended-transform :log10-then-z-score
             :reason "Award frequency normalized for specialty workforce size.")
            (:id :nih-funding-per-active-physician-per-year
             :source-field :funding-thousand-usd-per-active-physician-per-year
             :unit :thousand-2011-usd-per-active-physician-per-year
             :recommended-transform :log10-then-z-score
             :reason "Inflation- and workforce-normalized NIH award intensity."))
          :retained-but-not-umap-features
          '((:id :funding-rank :reason :ordinal-and-redundant)
            (:id :grants :reason :confounded-by-specialty-workforce-size)
            (:id :grant-share-percent :reason :compositional-and-size-confounded)
            (:id :funding-million-usd :reason :confounded-by-specialty-workforce-size)
            (:id :funding-share-percent :reason :compositional-and-size-confounded)
            (:id :mean-active-physicians :reason :denominator-not-scientific-output))
          :sources
          '((:id :shah-nih-specialties-2022
             :citation "Shah et al. Does NIH funding differ between medical specialties? BMJ Open. 2022;12:e058191."
             :doi "10.1136/bmjopen-2021-058191"
             :url "https://pmc.ncbi.nlm.nih.gov/articles/PMC9809243/"
             :table 1
             :role :quantitative-backbone)
            (:id :glass-akirtava-investigators-2017
             :url "https://www.appliedclinicaltrialsonline.com/view/what-actual-number-active-us-clinical-trial-investigators"
             :role :context-only
             :reason "Industry-sponsored investigator counts cover 2015-2016 and only the ten most reported specialties; no common workforce denominator in the article.")
            (:id :califf-clinicaltrials-2012
             :citation "Califf et al. Characteristics of Clinical Trials Registered in ClinicalTrials.gov, 2007-2010. JAMA. 2012;307:1838-1847."
             :doi "10.1001/jama.2012.3424"
             :url "https://jamanetwork.com/journals/jama/fullarticle/1150093"
             :role :context-only
             :reason "Trial counts are therapeutic-area measures, not physician-specialty measures.")
            (:id :zwierzyna-trials-2018
             :citation "Zwierzyna et al. Clinical trial design and dissemination. BMJ. 2018;361:k2130."
             :url "https://pmc.ncbi.nlm.nih.gov/articles/PMC5989153/"
             :role :context-only
             :reason "Seven MeSH-derived disease areas and drug/biologic trials cannot cover the specialty point universe without category error.")
            (:id :keswani-surgeon-scientists-2022
             :citation "Keswani et al. NIH Funding for Surgeon-Scientists in the US: What Is the Current Status? Ann Surg. 2022."
             :url "https://pmc.ncbi.nlm.nih.gov/articles/PMC9376791/"
             :role :refinement-candidate
             :reason "Useful surgical subspecialty evidence, but a 2020 active-PI snapshot is not directly mergeable with the 2011-2020 annual per-physician backbone.")
            (:id :westafer-k-grants-2024
             :citation "Westafer et al. K Grant Funding to Internal Medicine Specialties. J Gen Intern Med. 2024."
             :url "https://pmc.ncbi.nlm.nih.gov/articles/PMC10853154/"
             :role :refinement-candidate
             :reason "Adds internal-medicine K08/K23 detail for 2015-2022 but measures only early-career awards and uses an academic-faculty denominator.")
            (:id :karsy-journal-networks-2018
             :citation "Karsy et al. The Impact of Specialization in Journal Networks and Scholarship. World Neurosurg. 2018."
             :doi "10.1016/j.wneu.2018.08.075"
             :url "https://pubmed.ncbi.nlm.nih.gov/30144595/"
             :role :context-only
             :reason "Journal-level citation metrics and journal coverage differ by field and are not physician-level research output."))
          :method-notes
          '("Scientific activity is multidimensional; this first common matrix operationalizes only NIH award frequency and NIH funding intensity."
            "The source categorizes grants by NIH department name, not necessarily by a principal investigator's clinical board certification."
            "Only awarded grants were available, so these values do not measure application success rates."
            "Non-physician investigators can hold grants assigned to clinical departments."
            "Subspecialty donor mappings are hypotheses for a first UMAP and must remain visible during sensitivity analysis."
            "Do not combine the two enabled measures into a hand-weighted scalar before feature scaling.")
          :nih-specialty-benchmarks *nih-specialty-benchmarks*
          :specialties records)))
  (with-open-file (stream *output-file* :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (let ((*print-pretty* t) (*print-right-margin* 115) (*print-case* :downcase))
      (prin1 document stream) (terpri stream)))
  (format t "Wrote ~D scientific-activity mappings and ~D NIH benchmarks to ~A~%"
          (length records) (length *nih-specialty-benchmarks*) (namestring *output-file*)))
