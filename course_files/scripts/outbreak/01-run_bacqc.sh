#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

# create output directory
mkdir -p results/bacqc

# create samplesheet
python scripts/fastq_dir_to_samplesheet.py data/reads samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz

# FIX!!
# run the pipeline
nextflow run avantonder/bacQC \
  -r "2.0.1" \
  -resume -profile singularity \
  --input samplesheet.csv \
  --outdir results/bacqc \
  --kraken2db databases/k2_standard_08gb_20240605 \
  --kronadb databases/krona/taxonomy.tab \
  --genome_size 5000000
