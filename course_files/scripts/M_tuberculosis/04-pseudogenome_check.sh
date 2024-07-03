#!/bin/bash

# before running this script make sure to
# mamba activate seqtk

#### Settings #####

# directory with pseudogenome FASTA

fasta_dir="results/bactmap/pseudogenomes"

# output directory for results
outdir="results/bactmap/pseudogenomes_check"

# path to seqtk_parser.py
parser="scripts/seqtk_parser.py"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# exit upon any error
set -e

# create output directory
mkdir -p $outdir/seqtk

# rename aligned_pseudogenomes.fas
mv $fasta_dir/aligned_pseudogenomes.fas $fasta_dir/aligned_pseudogenomes.fasta

# loop through each pseudogenome
for filepath in $fasta_dir/*.fas
do
    # get the sample name
    sample=$(basename $filepath)

    # print a message
    echo "Processing $sample"

    # run seqtk command
    seqtk comp $filepath > ${outdir}/seqtk/${sample}.tsv
done

# run seqtk_parser.py
python $parser --input_dir $outdir/seqtk

# move mapping_summary.tsv to results/bactmap/pseudogenomes_check
mv mapping_summary.tsv $outdir

# rename aligned_pseudogenomes.fas
mv $fasta_dir/aligned_pseudogenomes.fasta $fasta_dir/aligned_pseudogenomes.fas
