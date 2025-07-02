#!/bin/bash

# check if environment has been activated
if ! command -v mob_recon 2>&1 >/dev/null
then
    echo "ERROR: mob_recon not available, make sure to run 'mamba activate mob_suite'"
    exit 1
fi

#### Settings #####

# directory with pseudogenome FASTA

fasta_dir="data/assemblies/"

# output directory for results
outdir="results/mobsuite"

# Enterobacteriaceae database
database="databases/mob_suite/2019-11-NCBI-Enterobacteriacea-Chromosomes.fasta"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

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
