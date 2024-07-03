#!/bin/bash

# before running this script make sure to
# mamba activate gubbins

# create output directory
mkdir -p results/gubbins/

# reference genome gff
gff=resources/reference/GCF_000299015.1_ASM29901v1_genomic.gff

# masked variants file to extract pairwise SNP distances from
alignment="results/bactmap/pseudogenomes/aligned_pseudogenomes.fas"

# prefix for gubbins outputs
prefix="sero1"

# output directory for results
outdir="results/gubbins"

# name of masked alignment
outfile="results/gubbins/aligned_pseudogenomes_masked.fas"

# run gubbins
run_gubbins.py --prefix $prefix --tree-builder iqtree $alignment

# move gubbins outputs to results directory
mv ${prefix}.* $outdir

# mask original alignment with recombinant regions
mask_gubbins_aln.py --aln $alignment --gff $outdir/${prefix}.recombination_predictions.gff --out $outfile

# run plot_gubbins.R to create plot of recombinant regions
plot_gubbins.R -t $outdir/${prefix}.final_tree.tre -r $outdir/${prefix}.recombination_predictions.gff -a $gff -o $outdir/${prefix}.recombination.png
