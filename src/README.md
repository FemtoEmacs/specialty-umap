# General UMAP sources

These Common Lisp programs and `general-umap.template` are shared analytical
infrastructure. Medical-specialty logic belongs in `../specialty-specific/`,
the specialty manifest, and derived specialty data.

The public builders at the project root load these sources. Typical use:

```sh
sbcl --script build-umap.lisp specialty-problem.sexpr \
  output/specialty-umap.html
sbcl --script score-umap.lisp specialty-problem.sexpr
```
