#!/bin/bash

# check if environment has been activated
if ! command -v pairsnp 2>&1 >/dev/null
then
    echo "ERROR: pairsnp not available, make sure to run 'mamba activate pairsnp'"
    exit 1
fi

# create output directory
mkdir -p results/transmission/

# masked variants file to extract pairwise SNP distances from
snp_file="preprocessed/snp-sites/aligned_pseudogenomes_masked_snps.fas"

# output file
outfile="results/transmission/aligned_pseudogenomes_masked_snps.csv"

# Run pairsnp
pairsnp $snp_file -c > $outfile
