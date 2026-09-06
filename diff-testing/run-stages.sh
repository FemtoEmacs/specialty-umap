#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEST_RUNNER=/Users/eduardo/.codex/skills/test-cases/scripts/run-tests.lisp

clang -std=c11 -Wall -Wextra -Werror -O2 \
  "$HERE/oracle-cli.c" -o "$HERE/quicksort-oracle"
clang -std=c11 -Wall -Wextra -Werror -O2 -dynamiclib \
  "$HERE/quick-sort-array.c" -o "$HERE/libquicksort-cast.dylib"

for stage in 0 1 2 3 4; do
  echo "=== Stage $stage ==="
  CAST_STAGE=$stage sbcl --load "$HERE/preload-cffi.lisp" --script "$TEST_RUNNER" \
    "$HERE/differential-tests.lisp"
done

echo "=== Final pure Common Lisp program ==="
sbcl --script "$TEST_RUNNER" "$HERE/pure-lisp-tests.lisp"
sbcl --script "$HERE/quick-sort-array.lisp" 7 2 9 1 5
