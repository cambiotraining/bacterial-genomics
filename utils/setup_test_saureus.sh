#!/bin/bash

set -euxo pipefail

eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

#### S. aureus ####

cd S_aureus

## 01-run_assemblebac.sh
mamba activate nextflow

# samplesheet
python scripts/fastq_dir_to_samplesheet.py data/reads \
    samplesheet.csv \
    -r1 _1.fastq.gz \
    -r2 _2.fastq.gz

# run the pipeline
nextflow run avantonder/assembleBAC \
  -r "v2.0.2" \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samplesheet.csv \
  --outdir results/assemblebac \
  --baktadb databases/bakta_light_20240119 \
  --genome_size 2M \
  --checkm2db databases/checkm2_v2_20210323/uniref100.KO.1.dmnd

## 02-run_panaroo.sh
mamba activate panaroo

# create output directory
mkdir -p results/panaroo/
mkdir -p results/snp-sites/

# Run panaroo
panaroo \
  --input results/assemblebac/bakta/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8


## 03-run_iqtree.sh
mamba activate iqtree

# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# extract variable sites
snp-sites results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/core_gene_alignment_snps.aln

# count invariant sites
snp-sites -C results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/constant_sites.txt

# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s results/snp-sites/core_gene_alignment_snps.aln \
  --prefix results/iqtree/School_Staph \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m MFP \
  -bb 1000
