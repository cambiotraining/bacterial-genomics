#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

# create output directory
mkdir -p results/bacqc

# FIX!!
# run the pipeline
nextflow run avantonder/bacQC \
  -r main \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input FIX_SAMPLESHEET \
  --outdir results/bacqc \
  --kraken2db databases/minikraken2_v1_8GB \
  --brackendb databases/minikraken2_v1_8GB \
  --genome_size FIX_GENOME_SIZE
