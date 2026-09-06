(load (merge-pathnames "cast.lisp" *load-truename*))

(defparameter *stage*
  (parse-integer (or (sb-ext:posix-getenv "CAST_STAGE") "0")))
(defparameter *directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *oracle*
  (namestring (merge-pathnames "quicksort-oracle" *directory*)))

(defun oracle-sort (vector)
  (let ((output (make-string-output-stream)))
    (let ((process
            (sb-ext:run-program
             *oracle* (loop for value across vector collect (write-to-string value))
             :search nil :wait t :output output :error *error-output*)))
      (test-cases:check (zerop (sb-ext:process-exit-code process))
                        "C oracle exited successfully"))
    (let ((text (get-output-stream-string output)))
      (if (zerop (length vector))
          #()
          (coerce (with-input-from-string (in text)
                    (loop for value = (read in nil nil)
                          while value collect value))
                  'vector)))))

(defun deterministic-corpus ()
  (append
   (list #() #(7) #(7 2 9 1 5) #(3 3 3) #(-5 0 4 -1 4)
         #(9 8 7 6 5 4 3 2 1 0) #(0 1 2 3 4 5 6 7 8 9))
   (loop for size from 0 to 32 collect
     (coerce (loop for i below size
                   collect (- (mod (+ (* 37 i) (* 11 size) 5) 29) 14))
             'vector))))

(defun call-with-foreign-vector (vector function)
  (let* ((result (map 'vector #'identity vector))
         (size (length result)))
    (cffi:with-foreign-object (data :int (max 1 size))
      (loop for value across result
            for i from 0
            do (setf (cffi:mem-aref data :int i) value))
      (let ((returned (funcall function data)))
        (loop for i below size
              do (setf (aref result i) (cffi:mem-aref data :int i)))
        (values result returned)))))

(test-cases:deftest every-function-is-reachable-through-the-current-cast
  (multiple-value-bind (swapped ignored)
      (call-with-foreign-vector
       #(3 1 2) (lambda (data)
                  (quicksort-cast:cast-swap-at data 0 2)))
    (declare (ignore ignored))
    (test-cases:check-equal #(2 1 3) swapped :test #'equalp))
  (multiple-value-bind (partitioned pivot-index)
      (call-with-foreign-vector
       #(7 2 9 1 5) (lambda (data)
                      (quicksort-cast:cast-partition-indexed data 4 0 0)))
    (test-cases:check-equal 2 pivot-index)
    (test-cases:check-equal #(2 1 5 7 9) partitioned :test #'equalp))
  (multiple-value-bind (range-sorted ignored)
      (call-with-foreign-vector
       #(99 7 2 9 1 5 -99) (lambda (data)
                              (quicksort-cast:cast-quicksort-indexed-range
                               data 1 5)))
    (declare (ignore ignored))
    (test-cases:check-equal #(99 1 2 5 7 9 -99) range-sorted :test #'equalp)))

(test-cases:deftest c-oracle-agrees-with-current-cast-stage
  (loop for input in (deterministic-corpus)
        for expected = (oracle-sort input)
        for actual = (quicksort-cast:sort-vector-at-stage input *stage*)
        do (test-cases:check-equal
            expected actual :test #'equalp
            :description (format nil "stage ~D input ~S" *stage* input))))

(test-cases:deftest result-is-sorted-and-is-a-permutation
  (loop for input in (deterministic-corpus)
        for actual = (quicksort-cast:sort-vector-at-stage input *stage*)
        do (test-cases:check
            (loop for i from 1 below (length actual)
                  always (<= (aref actual (1- i)) (aref actual i)))
            "nondecreasing order")
           (test-cases:check-equal
            (sort (coerce input 'list) #'<) (coerce actual 'list)
            :description "permutation preserved")))
