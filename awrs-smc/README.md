# General AWRS-SMC engine

This directory contains the domain-independent Adaptive Weighted Rejection
Sampling and Sequential Monte Carlo implementation. Stock-specific proposal
spaces, potentials, and corpus-curation rules live in `../stk-specific/`.

Run its general tests from the project root:

```sh
sbcl --script awrs-smc/tests.lisp
```

Do not introduce stock names, ticker conventions, or market features here. If
a change is genuinely general, apply the identical change in `umap-sarcoma`.
