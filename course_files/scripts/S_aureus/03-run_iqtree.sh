#!/bin/bash

# check if environment has been activated
if ! command -v iqtree 2>&1 >/dev/null
then
    echo "ERROR: iqtree not available, make sure to run 'mamba activate iqtree'"
    exit 1
fi

# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# FIX!!
# extract variable sites
snp-sites FIX_INPUT_CORE_ALIGNMENT > results/snp-sites/core_gene_alignment_snps.aln

# FIX!!
# count invariant sites
snp-sites -C FIX_INPUT_CORE_ALIGNMENT > results/snp-sites/constant_sites.txt

# FIX!!
# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s FIX_INPUT_SNP_ALIGNMENT \
  --prefix results/iqtree/School_Staph \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m MFP \
  -bb 1000
