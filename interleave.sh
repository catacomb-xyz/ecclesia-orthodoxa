#!/usr/bin/env bash
set -x
awk '{print; if(getline < "'$2'") print}' $1
