# Dependency-free Common Lisp test runner

Run a registered suite from the project root:

```sh
sbcl --script vendor/test-cases/run-tests.lisp \
  "$PWD/stk-specific/stock-smc-trainer-tests.lisp"
```

The process exits with status zero only when every registered test passes.
