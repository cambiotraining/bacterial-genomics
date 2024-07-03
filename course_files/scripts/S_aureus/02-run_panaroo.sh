#!/bin/bash

# before running this script make sure to
# mamba activate panaroo

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
