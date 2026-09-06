(defpackage #:quick-sort-array
  (:use #:cl)
  (:export #:swap-at #:partition-indexed #:quicksort-indexed-range
           #:quicksort-indexed #:main))

(in-package #:quick-sort-array)

(defun swap-at (data i j)
  (rotatef (aref data i) (aref data j))
  (values))

(defun partition-indexed (data high scan boundary)
  (if (< scan high)
      (if (< (aref data scan) (aref data high))
          (progn
            (swap-at data scan boundary)
            (partition-indexed data high (1+ scan) (1+ boundary)))
          (partition-indexed data high (1+ scan) boundary))
      (progn
        (swap-at data boundary high)
        boundary)))

(defun quicksort-indexed-range (data low high)
  (when (< low high)
    (let ((pivot-index (partition-indexed data high low low)))
      (unless (zerop pivot-index)
        (quicksort-indexed-range data low (1- pivot-index)))
      (quicksort-indexed-range data (1+ pivot-index) high)))
  (values))

(defun quicksort-indexed (data size)
  (unless (zerop size)
    (quicksort-indexed-range data 0 (1- size)))
  data)

(defun parse-command-line (arguments)
  (handler-case
      (map 'vector #'parse-integer arguments)
    (error ()
      (format *error-output* "Usage: sbcl --script quick-sort-array.lisp [INTEGER ...]~%")
      (sb-ext:exit :code 2))))

(defun main (arguments)
  (let ((data (if arguments
                  (parse-command-line arguments)
                  #(7 2 9 1 5))))
    (quicksort-indexed data (length data))
    (loop for value across data
          for first = t then nil
          do (format t (if first "~D" " ~D") value))
    (terpri)
    data))

(unless (member :quick-sort-array-library *features*)
  (main (cdr sb-ext:*posix-argv*)))
