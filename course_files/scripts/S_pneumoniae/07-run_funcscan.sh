#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

# create output directory
mkdir -p results/funcscan

# FIX!!
# run the pipeline
nextflow run nf-core/funcscan \
  -resume -profile singularity \
  --max_memory 16.GB --max_cpus 8 \
  --input FIX_PATH_TO_SAMPLESHEET \
  --outdir FIX_PATH_TO_OUTPUT_DIRECTORY \
  --run_arg_screening \
  --arg_skip_deeparg
