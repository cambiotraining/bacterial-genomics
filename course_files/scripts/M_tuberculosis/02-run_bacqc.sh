#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

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
  --kraken2db databases/k2_standard_08gb_20240605 \
  --kronadb databases/krona/taxonomy.tab \
  --genome_size FIX_GENOME_SIZE
