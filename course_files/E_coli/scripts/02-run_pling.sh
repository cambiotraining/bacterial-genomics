#!/bin/bash

# check if environment has been activated
if ! command -v pling 2>&1 >/dev/null
then
    echo "ERROR: pling not available, make sure to run 'mamba activate pling'"
    exit 1
fi

# create output directory
mkdir -p <OUT_DIR>

# copy plasmid sequences to Pling directory
cp <PATH_PLASMID_FASTA> results/pling/

# create the input file for Pling
ls -d -1 results/pling/*.fasta > input.txt

# run Pling
pling input.txt results/pling/output align
