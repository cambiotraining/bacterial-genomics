#!/bin/bash

# before running this script make sure to
# mamba activate pairsnp

# create output directory
mkdir -p results/transmission/

# masked variants file to extract pairwise SNP distances from
snp_file="preprocessed/snp-sites/aligned_pseudogenomes_masked_snps.fas"

# output file
outfile="results/transmission/aligned_pseudogenomes_masked_snps.csv"

# Run pairsnp
pairsnp $snp_file -c > $outfile
