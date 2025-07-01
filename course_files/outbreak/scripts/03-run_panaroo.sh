#!/bin/bash

# check if environment has been activated
if ! command -v panaroo 2>&1 >/dev/null
then
    echo "ERROR: panaroo not available, make sure to run 'mamba activate panaroo'"
    exit 1
fi

# create output directory
mkdir -p results/panaroo/
mkdir -p results/snp-sites/

# FIX!!
# Run panaroo
panaroo \
  --input results/assemblebac/bakta/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.9 \
  --remove-invalid-genes \
  --threads 8
