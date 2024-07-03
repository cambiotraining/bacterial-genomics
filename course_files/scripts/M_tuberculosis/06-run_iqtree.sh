#!/bin/bash

# before running this script make sure to
# mamba activate iqtree

# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# FIX!!
# extract variable sites
snp-sites FIX_INPUT_PSEUDOGENOMES_FASTA > results/snp-sites/aligned_pseudogenomes_masked_snps.fas

# FIX!!
# count invariant sites
snp-sites -C FIX_INPUT_PSEUDOGENOMES_FASTA > results/snp-sites/constant_sites.txt

# FIX!!
# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s FIX_INPUT_SNP_ALIGNMENT \
  --prefix results/iqtree/Nam_TB \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m GTR+F+I \
  -bb 1000
