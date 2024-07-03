#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

# create output directory
mkdir -p results/bactmap

# FIX!!
# run the pipeline
nextflow run nf-core/bactmap \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input FIX_SAMPLESHEET \
  --outdir results/bactmap \
  --reference FIX_REFERENCE_FASTA \
  --genome_size 4.3M
