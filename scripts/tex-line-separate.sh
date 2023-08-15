#!/usr/bin/env bash
set -x

sed \
  -e 's/$/\n/' \
  $1 >> $2

