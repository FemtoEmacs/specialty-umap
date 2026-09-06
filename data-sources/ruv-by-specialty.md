# Medical Specialty Anchor Metrics Documentation

> **2025 CMS audit note (2026-09-05):** This file is retained as the original
> design input. Several illustrative values below do not match the official
> CMS July 2025 Relative Value File and Final Rule Physician Work Time file.
> The corrected, provenance-preserving data used by the project are in
> `../data/specialty-compensation-tasks.sexpr`; the method and discrepancies are
> documented in `compensation-wrvu-methodology.md`. Do not ingest the numbers
> below as current feature values.

This documentation provides a clean, un-confounded structural data matrix comparing the remuneration, physical effort, and time footprint across key medical specialties. It utilizes the **Resource-Based Relative Value Scale (RBRVS)** framework to analyze the fundamental physics of clinical and surgical encounters. 

The metrics provided below act as ideal inputs for low-level parametric dimensional reduction pipelines (such as dependency-free **Common Lisp UMAP implementations**) by establishing objective mathematical scales for both procedural complexity and temporal velocity.

---

## Specialty Remuneration & Temporal Physics Matrix

The values below capture the professional work component (wRVU) alongside the federally allocated intra-service time footprint for highly standard, high-volume "anchor" codes within each respective field.

```lisp
(((:specialty "Dermatology")
  (:cpt "11102")
  (:descriptor "Tangential biopsy of skin single lesion")
  (:wrvu 0.55)
  (:allocated-time 8)
  (:wrvu-per-min 0.06875))

 ((:specialty "Radiology")
  (:cpt "74177")
  (:descriptor "CT scan of abdomen & pelvis with contrast")
  (:wrvu 1.82)
  (:allocated-time 15)
  (:wrvu-per-min 0.12133))

 ((:specialty "Gastroenterology")
  (:cpt "43239")
  (:descriptor "Upper GI endoscopy with biopsy")
  (:wrvu 1.76)
  (:allocated-time 35)
  (:wrvu-per-min 0.05029))

 ((:specialty "Medical Oncology")
  (:cpt "99215")
  (:descriptor "High-complexity outpatient evaluation management")
  (:wrvu 2.80)
  (:allocated-time 50)
  (:wrvu-per-min 0.05600))

 ((:specialty "Cardiology")
  (:cpt "93458")
  (:descriptor "Left heart cath and coronary angiogram")
  (:wrvu 5.45)
  (:allocated-time 60)
  (:wrvu-per-min 0.09083))

 ((:specialty "Orthopedic Surgery")
  (:cpt "27447")
  (:descriptor "Total knee arthroplasty replacement")
  (:wrvu 19.60)
  (:allocated-time 100)
  (:wrvu-per-min 0.19600))

 ((:specialty "Neurosurgery")
  (:cpt "61510")
  (:descriptor "Craniectomy/craniotomy to excise brain tumor")
  (:wrvu 26.96)
  (:allocated-time 240)
  (:wrvu-per-min 0.11233)))
```

All values are derived directly from the official United States Federal Registry databases managed by the **Centers for Medicare & Medicaid Services (CMS)**. 

*   **Primary Data Portal:** [CMS Physician Fee Schedule Overview Page](https://www.cms.gov/medicare/payment/fee-schedules/physician "Physician Fee Schedule - CMS")
*   **Interactive Query Engine:** [CMS Physician Fee Schedule Search Tool](https://www.cms.gov/medicare/physician-fee-schedule/search "Search the Physician Fee Schedule - CMS")

*Methodology for Extraction:* The wRVU benchmarks match the professional component (Modifier 26 / PC) extracted through a **"Single Procedure Code"** search with **"All Modifiers"** enabled, filtering strictly for the direct intellectual and manual labor of the physician (excluding facility infrastructure and technical equipment expenditures).

## RVU value and RVU/year

https://www.linkedin.com/pulse/2025-wrvus-per-wrvu-benchmarks-specialty-guide-physicians-dtyac/



---
*This documentation is intended for mathematical model preparation and decision-support optimization structures.*
