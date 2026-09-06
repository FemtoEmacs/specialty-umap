;;;; Dependency-free Gaussian radial-basis network with fitted linear outputs.
;;;; The output head learns normalized atlas coordinates and cluster indicators.
(defun rbf-distance (a b) (loop for x in a for y in b sum (expt (- x y) 2)))
(defun rbf-kernel (a b width) (exp (- (/ (rbf-distance a b) (* 2d0 width width)))))
(defun rbf-solve (matrix rhs)
 "Partial-pivot elimination on copies; multiple output columns share one solve."
 (let* ((a (make-array (array-dimensions matrix) :element-type 'double-float))
        (b (make-array (array-dimensions rhs) :element-type 'double-float))
        (n (array-dimension a 0)) (m (array-dimension b 1)))
  (dotimes (i (array-total-size a)) (setf (row-major-aref a i) (row-major-aref matrix i)))
  (dotimes (i (array-total-size b)) (setf (row-major-aref b i) (row-major-aref rhs i)))
  (dotimes (k n)
   (let ((pivot k))
    (loop for i from (1+ k) below n do (when (> (abs (aref a i k)) (abs (aref a pivot k))) (setf pivot i)))
    (when (< (abs (aref a pivot k)) 1d-14) (error "Singular RBF system"))
    (dotimes (j n) (rotatef (aref a k j) (aref a pivot j)))
    (dotimes (j m) (rotatef (aref b k j) (aref b pivot j))))
   (loop for i from (1+ k) below n for factor = (/ (aref a i k) (aref a k k)) do
    (loop for j from k below n do (decf (aref a i j) (* factor (aref a k j))))
    (dotimes (j m) (decf (aref b i j) (* factor (aref b k j))))))
  (loop for i downfrom (1- n) to 0 do
   (dotimes (j m)
    (setf (aref b i j) (/ (- (aref b i j) (loop for k from (1+ i) below n sum (* (aref a i k) (aref b k j)))) (aref a i i)))))
  b))
(defun rbf-fit (inputs targets width ridge)
 (unless (and (plusp width) (plusp ridge) (= (length inputs) (length targets))) (error "Invalid RBF training arguments"))
 (let* ((n (length inputs)) (m (length (first targets)))
        (k (make-array (list n n) :element-type 'double-float))
        (y (make-array (list n m) :element-type 'double-float)))
  (loop for a in inputs for i from 0 do
   (loop for b in inputs for j from 0 do (setf (aref k i j) (+ (rbf-kernel a b width) (if (= i j) ridge 0d0))))
   (loop for v in (nth i targets) for j from 0 do (setf (aref y i j) (coerce v 'double-float))))
  (let ((weights (rbf-solve k y)))
   (list :format :gaussian-rbf :version 1 :width width :ridge ridge :centers inputs
         :weights (loop for i below n collect (loop for j below m collect (aref weights i j)))))))
(defun rbf-predict (model input)
 (unless (= (length input) (length (first (getf model :centers)))) (error "RBF input dimension mismatch"))
 (let ((result (make-list (length (first (getf model :weights))) :initial-element 0d0)))
  (loop for c in (getf model :centers) for weights in (getf model :weights)
        for activation = (rbf-kernel c input (getf model :width)) do
   (setf result (mapcar (lambda (sum w) (+ sum (* activation w))) result weights)))
  result))
