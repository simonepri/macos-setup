#!/usr/bin/env bash

cd system
bash run.sh
cd ..
cd cli
bash run.sh
cd ..
cd app
bash run.sh
cd ..

printf "System set up!\n"
