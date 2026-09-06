(pushnew :quick-sort-array-library *features*)
(load (merge-pathnames "quick-sort-array.lisp" *load-truename*))

(defparameter *pure-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *pure-oracle*
  (namestring (merge-pathnames "quicksort-oracle" *pure-directory*)))

(defun pure-oracle-sort (vector)
  (let ((output (make-string-output-stream)))
    (let ((process
            (sb-ext:run-program
             *pure-oracle*
             (loop for value across vector collect (write-to-string value))
             :search nil :wait t :output output :error *error-output*)))
      (test-cases:check (zerop (sb-ext:process-exit-code process))
                        "C Oracle exited successfully"))
    (let ((text (get-output-stream-string output)))
      (if (zerop (length vector))
          #()
          (coerce (with-input-from-string (in text)
                    (loop for value = (read in nil nil)
                          while value collect value))
                  'vector)))))

(defun pure-corpus ()
  (append
   (list #() #(7) #(7 2 9 1 5) #(3 3 3) #(-5 0 4 -1 4)
         #(9 8 7 6 5 4 3 2 1 0) #(0 1 2 3 4 5 6 7 8 9))
   (loop for size from 0 to 64 collect
     (coerce (loop for i below size
                   collect (- (mod (+ (* 37 i) (* 11 size) 5) 29) 14))
             'vector))))

(test-cases:deftest all-four-pure-lisp-functions
  (let ((data #(3 1 2)))
    (quick-sort-array:swap-at data 0 2)
    (test-cases:check (equalp (vector 2 1 3) data)))
  (let ((data #(7 2 9 1 5)))
    (test-cases:check-equal
     2 (quick-sort-array:partition-indexed data 4 0 0))
    (test-cases:check (equalp (vector 2 1 5 7 9) data)))
  (let ((data #(99 7 2 9 1 5 -99)))
    (quick-sort-array:quicksort-indexed-range data 1 5)
    (test-cases:check (equalp (vector 99 1 2 5 7 9 -99) data))))

(test-cases:deftest pure-lisp-agrees-with-c-oracle
  (loop for input in (pure-corpus)
        for actual = (copy-seq input)
        for expected = (pure-oracle-sort input)
        do (quick-sort-array:quicksort-indexed actual (length actual))
           (test-cases:check-equal
            expected actual :test #'equalp
            :description (format nil "pure Lisp input ~S" input))))

(test-cases:deftest command-line-entry-point
  (let ((output
          (with-output-to-string (stream)
            (let ((*standard-output* stream))
              (test-cases:check
               (equalp (vector 1 2 5 7 9)
                       (quick-sort-array:main '("7" "2" "9" "1" "5"))))))))
    (test-cases:check (string= output (format nil "1 2 5 7 9~%")))))
