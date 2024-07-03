#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

# create output directory
mkdir -p results/fetchngs

# FIX!!
# run the pipeline
nextflow run nf-core/fetchngs \
  -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLES \
  --outdir results/fetchngs \
  --nf_core_pipeline viralrecon
