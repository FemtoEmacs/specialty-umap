

(:specialty Ophthalmology        (:private-practice-or-solo 70.4%))
(:specialty Orthopedic-Surgery   (:private-practice-or-solo 54.0%))
(:specialty Other-Surgical-Subspecialties (:private-practice-or-solo 51.2%))
(:specialty Radiology            (:private-practice-or-solo 46.9%))
(:specialty Anesthesiology       (:private-practice-or-solo 46.4%))
(:specialty Obstetrics-Gynecology (:private-practice-or-solo 46.3%))
(:specialty Emergency-Medicine   (:private-practice-or-solo 33.2%))
(:specialty Cardiology           (:private-practice-or-solo 30.7%))
(:specialty General-Surgery      (:private-practice-or-solo 28%))
(:specialty Primary-Care-Group   (:private-practice-or-solo 30-40%))

;; Confirmed by explicit AMA prose (not inferred):
(:specialty General-Surgery
  (:private-practice-or-solo 31.7%)
  (:confidence high (:basis "AMA text: 'less than one third of general surgeons were in private practice' — 31.7 is the only remaining bar under 33%")))

;; The AMA text explicitly groups these three as a set ("high 30s to low 40s")
;; but does NOT say which specific number goes with which specialty.
;; The five candidate values in that range are: 38.1, 38.9, 39.2, 42.2, 42.2
(:specialty Pediatrics
  (:private-practice-or-solo unclear)
  (:confidence medium (:basis "AMA text: pediatrics is in the 'high 30s to low 40s' group; occupies one of {38.1, 38.9, 39.2, 42.2, 42.2}, exact bar unidentified")))

(:specialty General-Internal-Medicine
  (:private-practice-or-solo unclear)
  (:confidence medium (:basis "same as above")))

(:specialty Family-Medicine
  (:private-practice-or-solo unclear)
  (:confidence medium (:basis "same as above")))

;; Remaining unlabeled bars: two of {38.1, 38.9, 39.2, 42.2, 42.2} (whichever
;; primary care doesn't claim), plus 43.6 and 45.2. AMA prose never names
;; these specialties at all — this is my inference from "which specialty
;; groups AMA typically uses in this survey," not from any stated figure.
(:specialty Dermatology       (:private-practice-or-solo unclear) (:confidence low))
(:specialty Neurology         (:private-practice-or-solo unclear) (:confidence low))
(:specialty Oncology          (:private-practice-or-solo unclear) (:confidence low))
(:specialty Psychiatry        (:private-practice-or-solo unclear) (:confidence low))


