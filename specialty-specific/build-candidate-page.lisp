;;;; Default candidate page now uses all nine features and the trained RBF model.
(load (merge-pathnames "build-nine-candidate-page.lisp"
        (make-pathname :name nil :type nil :defaults *load-truename*)))
