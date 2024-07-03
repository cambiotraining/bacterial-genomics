#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

# create output directory
mkdir results/bactmap

# FIX!!
# run the pipeline
nextflow run nf-core/bactmap \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir results/bactmap \
  --reference REFERENCE \
  --genome_size 2.0M
