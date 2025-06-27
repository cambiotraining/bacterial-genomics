#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

# create output directory
mkdir results/bactmap

# FIX!!
# run the pipeline
nextflow run nf-core/bactmap \
  -r 1.0.0 \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir results/bactmap \
  --reference REFERENCE \
  --genome_size 2.0M
