#!/usr/bin/env bash
set -x

sed \
  -e 's/^/\\emph{\\footnotesize /' \
  -e 's/$/}/' \
  $1 >> $2
