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
  --input FIX_PATH_TO_INPUT_FILES \
  --out_dir FIX_OUTPUT_DIRECTORY \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
