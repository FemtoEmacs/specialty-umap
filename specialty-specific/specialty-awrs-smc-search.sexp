(:format :umap-smc-search
 :version 1
 :manifest "../specialty-problem.sexpr"
 :label-field :cluster-name
 :features
 ((:name :training-duration-z :column 0
   :transformations (:identity :asinh :signed-log1p))
  (:name :clinical-work-intensity-z :column 1
   :transformations (:identity :asinh :signed-log1p))
  (:name :scientific-activity-index-z :column 2
   :transformations (:identity :asinh :signed-log1p))
  (:name :private-practice-z :column 3
   :transformations (:identity :asinh :signed-log1p))
  (:name :salary-z :column 4
   :transformations (:identity :asinh :signed-log1p))
  (:name :workforce-burden-z :column 5
   :transformations (:identity :asinh :signed-log1p))
  (:name :competitiveness-z :column 6
   :transformations (:identity :asinh :signed-log1p))
  (:name :female-representation-z :column 7
   :transformations (:identity :asinh :signed-log1p))
  (:name :procedure-intensity-z :column 8
   :transformations (:identity :asinh :signed-log1p)))
 :search
 (:particles 32
  :resampling-threshold 0.65d0
  :minimum-features 7
  :maximum-features 9
  :neighbors 15
  :minimum-distance 0.10d0
  :epochs 250
  :umap-seed 20260905
  :smc-seed 20260906
  :minimum-points 5
  :epsilon :automatic
  :standardize nil
  :feature-penalty 0.002d0
  :beta 8.0d0
  :adjacency-strength 0.05d0
  :resampling-method :multinomial))
