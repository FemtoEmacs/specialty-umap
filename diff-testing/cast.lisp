(unless (find-package :cffi)
  (error "CFFI is not loaded; run through run-stages.sh or load preload-cffi.lisp"))

(defpackage #:quicksort-cast
  (:use #:cl)
  (:export #:*cast-stage* #:sort-vector-at-stage #:cast-swap-at
           #:cast-partition-indexed #:cast-quicksort-indexed-range
           #:cast-quicksort-indexed))

(in-package #:quicksort-cast)

(defparameter *cast-stage* 0
  "0 is all C; stages 1 through 4 replace C functions top-down.")

(defparameter *here*
  (make-pathname :name nil :type nil :defaults
                 (or *load-truename* *compile-file-truename*)))

(cffi:load-foreign-library (merge-pathnames "libquicksort-cast.dylib" *here*))

(cffi:defcfun ("swapAt" %c-swap-at) :void
  (data :pointer) (i :int) (j :int))
(cffi:defcfun ("partitionIndexed" %c-partition-indexed) :int
  (data :pointer) (high :int) (scan :int) (boundary :int))
(cffi:defcfun ("quicksortIndexedRange" %c-quicksort-indexed-range) :void
  (data :pointer) (low :int) (high :int))
(cffi:defcfun ("quicksortIndexed" %c-quicksort-indexed) :void
  (data :pointer) (size :int))

(defun cast-swap-at (data i j)
  (if (< *cast-stage* 4)
      (%c-swap-at data i j)
      (let ((left (cffi:mem-aref data :int i))
            (right (cffi:mem-aref data :int j)))
        (setf (cffi:mem-aref data :int i) right
              (cffi:mem-aref data :int j) left)))
  (values))

(defun cast-partition-indexed (data high scan boundary)
  (if (< *cast-stage* 3)
      (%c-partition-indexed data high scan boundary)
      (if (< scan high)
          (let ((pivot (cffi:mem-aref data :int high))
                (current (cffi:mem-aref data :int scan)))
            (if (< current pivot)
                (progn
                  (cast-swap-at data scan boundary)
                  (cast-partition-indexed data high (1+ scan) (1+ boundary)))
                (cast-partition-indexed data high (1+ scan) boundary)))
          (progn
            (cast-swap-at data boundary high)
            boundary))))

(defun cast-quicksort-indexed-range (data low high)
  (if (< *cast-stage* 2)
      (%c-quicksort-indexed-range data low high)
      (when (< low high)
        (let ((pivot-index (cast-partition-indexed data high low low)))
          (unless (zerop pivot-index)
            (cast-quicksort-indexed-range data low (1- pivot-index)))
          (cast-quicksort-indexed-range data (1+ pivot-index) high))))
  (values))

(defun cast-quicksort-indexed (data size)
  (if (< *cast-stage* 1)
      (%c-quicksort-indexed data size)
      (unless (zerop size)
        (cast-quicksort-indexed-range data 0 (1- size))))
  (values))

(defun sort-vector-at-stage (vector stage)
  (let* ((*cast-stage* stage)
         (result (map 'vector #'identity vector))
         (size (length result)))
    (cffi:with-foreign-object (data :int (max 1 size))
      (loop for value across result
            for i from 0
            do (setf (cffi:mem-aref data :int i) value))
      (cast-quicksort-indexed data size)
      (loop for i below size
            do (setf (aref result i) (cffi:mem-aref data :int i))))
    result))
