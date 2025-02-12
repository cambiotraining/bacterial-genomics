#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

# create output directory
mkdir -p results/fetchngs

# FIX!!
# run the pipeline
nextflow run nf-core/fetchngs \
  -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLES \
  --outdir results/fetchngs \
  --nf_core_pipeline viralrecon \
  --download_method sratools
