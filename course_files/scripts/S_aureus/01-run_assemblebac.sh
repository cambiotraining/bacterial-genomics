#!/bin/bash

# check if environment has been activated
if ! command -v nextflow 2>&1 >/dev/null
then
    echo "ERROR: nextflow not available, make sure to run 'mamba activate nextflow'"
    exit 1
fi

# run the pipeline
nextflow run avantonder/assembleBAC \
  -r "2.0.2" \
  -resume -profile singularity \
  --input SAMPLESHEET \
  --outdir results/assemblebac \
  --baktadb databases/bakta_light_20240119 \
  --genome_size GENOME_SIZE \
  --checkm2db databases/checkm2_v2_20210323/uniref100.KO.1.dmnd
