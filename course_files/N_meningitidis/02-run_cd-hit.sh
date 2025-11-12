#!/bin/bash

# check if environment has been activated
if ! command -v cd-hit 2>&1 >/dev/null
then
    echo "ERROR: cd-hit not available, make sure to run 'mamba activate reverse_vaccinology'"
    exit 1
fi

#### Settings ####

# directory with .faa files
aa_dir="data/faa"

# output directory for results
outdir="results/cd-hit"

# count the number of strains
NUM_STRAINS=$(find $aa_dir -name "*.faa" | wc -l)

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# create output directory
mkdir -p $outdir

# concatenate all .faa files into one
cat  $aa_dir/*.faa > $outdir/all_proteins.faa

# run cd-hit to cluster proteins at 95% identity
cd-hit -i $outdir/all_proteins.faa -o $outdir/conserved_clusters.txt -c 0.95 -d 0

# run python parse script
python scripts/cd-hit_parser.py $outdir/conserved_clusters.txt.clstr ${NUM_STRAINS}