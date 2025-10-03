#!/usr/bin/env bash

for script in ./*.sh; do
  if [ $script == "./run.sh" ]; then continue; fi
  bash "$script"
done
