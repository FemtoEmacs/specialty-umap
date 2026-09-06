(require :asdf)
(asdf:initialize-source-registry
 `(:source-registry
   (:tree ,(namestring
            (merge-pathnames "quicklisp/dists/quicklisp/software/"
                             (user-homedir-pathname))))
   :inherit-configuration))
(asdf:load-system :cffi)
