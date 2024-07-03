#!/bin/bash

# before running this script make sure to
# mamba activate nextflow

nextflow run avantonder/assembleBAC \
  -r main \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir results/assemblebac \
  --baktadb databases/db-light \
  --genome_size GENOME_SIZE \
  --checkm2db databases/CheckM2_database/uniref100.KO.1.dmnd
