#!/bin/bash

# check if environment has been activated
if ! command -v diamond 2>&1 >/dev/null
then
    echo "ERROR: diamond not available, make sure to run 'mamba activate reverse_vaccinology'"
    exit 1
fi

#### Settings ####

# directory with .faa files
aa_dir="results/cd-hit"

# output directory for results
outdir="results/homology_searches"

# path to swissprot database
swissprot_db="databases/swissprot.dmnd"

# path to human proteome database
human_db="databases/human_proteome.dmnd"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# create output directory
mkdir -p $outdir

# run diamond on swissprot database
diamond blastp -d $swissprot_db -q $aa_dir/all_proteins.faa -o $outdir/function.tsv --outfmt 6 qseqid stitle evalue

# run diamond on human proteome database
diamond blastp -d $human_db -q $aa_dir/all_proteins.faa -o $outdir/human_homology.tsv --outfmt 6 qseqid stitle evalue pident