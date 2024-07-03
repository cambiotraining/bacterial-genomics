#!/bin/bash

# before running this script make sure to
# mamba activate remove_blocks

#### Settings #####

# directory with pseudogenome FASTA

fasta_dir="results/bactmap/pseudogenomes"

# output directory for results
outdir="results/bactmap/masked_alignment"

# path to bed file with masking co-ordinates
bed="resources/masking/MTBC0_Goigetal_regions_toDiscard.bed"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# exit upon any error
set -e

# create output directory
mkdir -p $outdir

# copy pseudogenome alignment to output directory
cp $fasta_dir/aligned_pseudogenomes.fas $outdir

# mask alignment with co-ordinates in bed file
remove_blocks_from_aln.py -a $outdir/aligned_pseudogenomes.fas -t $bed -o $outdir/aligned_pseudogenomes_masked.fas
