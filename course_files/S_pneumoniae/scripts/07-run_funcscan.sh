#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

# create output directory
mkdir -p results/funcscan

# FIX!!
# run the pipeline
nextflow run nf-core/funcscan \
  -r "2.1.0" \
  -resume -profile singularity \
  --input FIX_PATH_TO_SAMPLESHEET \
  --outdir FIX_PATH_TO_OUTPUT_DIRECTORY \
  --run_arg_screening \
  --arg_rgi_db databases/card/ \
  --arg_skip_deeparg
