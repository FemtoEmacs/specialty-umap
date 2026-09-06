;;;; Deterministic seven-feature medical-specialty UMAP. SBCL; no Quicklisp.
(defparameter *specialty-umap-directory* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *specialty-umap-root* (merge-pathnames "../" *specialty-umap-directory*))
(defparameter *build-umap-run-main* nil)
(load (merge-pathnames "build-umap.lisp" *specialty-umap-root*))
(load (merge-pathnames "src/common-lisp-umap.lisp" *specialty-umap-root*))
(load (merge-pathnames "src/embedding-clusters.lisp" *specialty-umap-root*))
(defparameter *specialty-coordinate-fields*
  '(:training-duration-z :clinical-work-intensity-z :scientific-activity-index-z
    :private-practice-z :salary-z :workforce-burden-z :competitiveness-z
    :female-representation-z :procedure-intensity-z))
(defparameter *specialty-neighbors* 15)
(defparameter *specialty-minimum-distance* 0.10d0)
(defparameter *specialty-epochs* 750)
(defparameter *specialty-seed* 20260905)
(defparameter *specialty-dbscan-minimum-points* 5)
(defparameter *specialty-feature-labels*
  '((:training-duration-z "long training" "short training")
    (:clinical-work-intensity-z "high clinical intensity" "low clinical intensity")
    (:scientific-activity-index-z "research-intensive" "research-light")
    (:private-practice-z "private-practice-oriented" "employment-oriented")
    (:salary-z "higher compensation" "lower compensation")
    (:workforce-burden-z "higher physician availability" "lower physician availability")
    (:competitiveness-z "more competitive training" "less competitive training")
    (:female-representation-z "higher female representation" "lower female representation")
    (:procedure-intensity-z "procedure-oriented" "predominantly clinical")))

(defun specialty-record-array (records)
  (let ((array (make-array (list (length records) (length *specialty-coordinate-fields*))
                           :element-type 'double-float)))
    (loop for record in records for row from 0 do
      (loop for field in *specialty-coordinate-fields* for column from 0 do
        (let ((value (getf record field)))
          (unless (realp value) (error "Row ~D field ~A is not numeric: ~S" row field value))
          (setf (aref array row column) (coerce value 'double-float)))))
    array))

(defun specialty-csv-string (value)
  (let ((text (princ-to-string value)))
    (if (or (find #\, text) (find #\" text) (find #\Newline text))
        (with-output-to-string (out)
          (write-char #\" out)
          (loop for character across text do
            (when (char= character #\") (write-char #\" out))
            (write-char character out))
          (write-char #\" out)) text)))

(defun specialty-number (value)
  (substitute #\e #\d (string-downcase
    (string-trim '(#\Space #\Tab) (format nil "~,12G" (coerce value 'double-float))))))

(defun cluster-members (assignments cluster-id)
  (loop for value across assignments for index from 0
        when (= value cluster-id) collect index))

(defun cluster-profile (input members)
  (loop for column below (array-dimension input 1)
        collect (/ (loop for row in members sum (aref input row column))
                   (length members))))

(defun cluster-name (cluster-id profile)
  (let* ((ranked (sort (loop for field in *specialty-coordinate-fields*
                             for value in profile
                             collect (list field value (abs value)))
                       #'> :key #'third))
         (all-phrases
           (loop for (field value magnitude) in ranked
                 when (> magnitude 0.20d0)
                 collect (let ((labels (assoc field *specialty-feature-labels*)))
                           (if (plusp value) (second labels) (third labels)))))
         (phrases (subseq all-phrases 0 (min 2 (length all-phrases)))))
    (format nil "Cluster ~D: ~{~A~^ + ~}" (1+ cluster-id)
            (or phrases '("mixed profile")))))

(defun write-specialty-embedding-csv (path records raw-records coordinates assignments names)
  (ensure-directories-exist path)
  (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
    (format out "specialty_id,specialty_name,x,y,cluster_id,cluster_name,representative_total_gme_years,average_total_compensation_usd,female_resident_percent,procedure_profile,procedure_intensity,training_duration_z,clinical_work_intensity_z,scientific_activity_index_z,private_practice_z,salary_z,workforce_burden_z,competitiveness_z,female_representation_z,procedure_intensity_z~%")
    (loop for record in records for raw-record in raw-records for row from 0 do
      (unless (string= (getf record :specialty-id) (getf raw-record :specialty-id))
        (error "Raw and transformed specialty order differs at row ~D." row))
      (let ((cluster (aref assignments row)))
      (format out "~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A" (specialty-csv-string (getf record :specialty-id))
              (specialty-csv-string (getf record :specialty-name))
              (specialty-number (aref coordinates row 0)) (specialty-number (aref coordinates row 1))
              (if (minusp cluster) "noise" (format nil "~D" (1+ cluster)))
              (specialty-csv-string (if (minusp cluster) "Unclustered" (aref names cluster)))
              (specialty-number (getf raw-record :representative-total-gme-years))
              (specialty-number (getf raw-record :average-total-compensation-usd))
              (specialty-number (getf raw-record :female-resident-percent))
              (specialty-csv-string (getf raw-record :procedure-profile))
              (specialty-number (getf raw-record :procedure-intensity)))
      (dolist (field *specialty-coordinate-fields*)
        (format out ",~A" (specialty-number (getf record field))))
      (terpri out)))))

(defun write-specialty-clusters (path records input assignments epsilon names)
  (let ((count (length names)))
    (ensure-directories-exist path)
    (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
      (let ((*print-pretty* t) (*print-length* nil) (*print-level* nil))
        (prin1
         (list :format :specialty-umap-clusters :version 1
               :space :two-dimensional-umap
               :algorithm :dbscan :epsilon epsilon
               :minimum-points *specialty-dbscan-minimum-points*
               :cluster-count count :noise-count (count -1 assignments)
               :clusters
               (loop for cluster below count
                     for members = (cluster-members assignments cluster)
                     collect (list :id (1+ cluster) :name (aref names cluster)
                                   :size (length members)
                                   :feature-means (mapcan #'list *specialty-coordinate-fields*
                                                          (cluster-profile input members))
                                   :specialties
                                   (mapcar (lambda (row) (getf (nth row records) :specialty-id))
                                           members))))
         out) (terpri out)))))

(defun write-specialty-result (path coordinates)
  (ensure-directories-exist path)
  (with-open-file (out path :direction :output :if-exists :supersede :if-does-not-exist :create)
    (let ((*print-pretty* t) (*print-length* nil) (*print-level* nil))
      (prin1 (list :format :specialty-umap-result :version 1
                   :manifest "specialty-problem.sexpr" :data "examples/specialty-points-umap.csv"
                   :observation-count (array-dimension coordinates 0)
                   :feature-count (length *specialty-coordinate-fields*)
                   :features *specialty-coordinate-fields*
                   :parameters (list :neighbors *specialty-neighbors*
                                     :minimum-distance *specialty-minimum-distance*
                                     :epochs *specialty-epochs* :seed *specialty-seed*
                                     :standardize nil)
                   :coordinates coordinates) out)
      (terpri out))))

(defun build-specialty-umap ()
  (let* ((input-path (merge-pathnames "examples/specialty-points-umap.csv" *specialty-umap-root*))
         (embedding-path (merge-pathnames "output/specialty-umap-embedding.csv" *specialty-umap-root*))
         (result-path (merge-pathnames "output/specialty-umap-result.sexp" *specialty-umap-root*))
         (clusters-path (merge-pathnames "output/specialty-umap-clusters.sexp" *specialty-umap-root*))
         (html-path (merge-pathnames "output/specialty-umap.html" *specialty-umap-root*))
         (raw-path (merge-pathnames "examples/specialty-points-raw.csv" *specialty-umap-root*))
         (records (read-csv-records input-path))
         (raw-records (read-csv-records raw-path))
         (input (specialty-record-array records)))
    (unless (= (length records) 143) (error "Expected 143 specialty points; found ~D." (length records)))
    (let* ((result (cl-umap-fit input :neighbors *specialty-neighbors*
                                      :minimum-distance *specialty-minimum-distance*
                                      :epochs *specialty-epochs* :seed *specialty-seed*
                                      :standardize nil))
           (coordinates (cl-umap-result-coordinates result))
           (standardized (embedding-standardized-coordinates coordinates))
           (epsilon (embedding-knee-epsilon standardized *specialty-dbscan-minimum-points*))
           (assignments (embedding-dbscan standardized epsilon *specialty-dbscan-minimum-points*))
           (cluster-count (1+ (loop for value across assignments maximize value)))
           (names (make-array cluster-count)))
      (dotimes (cluster cluster-count)
        (setf (aref names cluster)
              (cluster-name cluster (cluster-profile input (cluster-members assignments cluster)))))
      (unless (= (length raw-records) (length records))
        (error "Raw and transformed point counts differ."))
      (write-specialty-embedding-csv embedding-path records raw-records coordinates assignments names)
      (write-specialty-result result-path coordinates)
      (write-specialty-clusters clusters-path records input assignments epsilon names)
      (build-umap-html (namestring (merge-pathnames "specialty-problem.sexpr" *specialty-umap-root*))
                       (namestring html-path))
      (format t "Wrote deterministic ~Dx~D UMAP (seed ~D); DBSCAN found ~D clusters and ~D noise points.~%"
              (array-dimension input 0) (array-dimension input 1) *specialty-seed*
              cluster-count (count -1 assignments)))))
(build-specialty-umap)
