#!/bin/bash

set -euxo pipefail

eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

cd E_coli

## 01-run_mobsuite.sh
mamba activate mob_suite

# directory with pseudogenome FASTA
fasta_dir="data/assemblies/"

# output directory for results
outdir="results/mobsuite"

# Enterobacteriaceae database
database="databases/mob_suite/2019-11-NCBI-Enterobacteriacea-Chromosomes.fasta"

# create output directory
mkdir -p $outdir

# loop through each set of fasta files
for filepath in $fasta_dir/*.fa
do
    # get the sample name
    sample=$(basename ${filepath%.fa})

    # print a message
    echo "Processing $sample"

    # run mob_recon command
    mob_recon --infile $filepath --outdir $outdir/$sample -g $database -n 8
done

# rename mob_recon fasta files with sample name
# loop through each subdirectory
for dir in "$outdir"/*/; do
    if [ -d "$dir" ]; then  # Check if it's a directory
        dir_name=$(basename "$dir")
        echo "Processing directory: $dir_name"
        
        # Rename FASTA files inside the directory
        for file in "$dir"*.fasta; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                mv "$file" "${dir}${dir_name}_${filename}"
                echo "  Renamed: $filename → ${dir_name}_${filename}"
            fi
        done
    fi
done


## 02-run_pling.sh
mamba activate pling

# create output directory
mkdir -p results/pling/

# copy plasmid sequences to Pling directory
cp results/mobsuite/*/*_plasmid_*.fasta results/pling/

# create the input file for Pling
ls -d -1 results/pling/*.fasta > input.txt

# run Pling
pling input.txt results/pling/output align


## 03-run_mashtree.sh
mamba activate mashtree

# create output directory
mkdir -p results/mashtree

# run mashtree on the assemblies
mashtree --mindepth 0 --numcpus 12 data/assemblies/*.fa > results/mashtree/tree.nwk


## 04-plot_pling.R

Rscript scripts/04-plot_pling.R