#!/bin/bash

# check if environment has been activated
if ! command -v diamond 2>&1 >/dev/null
then
    echo "ERROR: diamond not available, make sure to run 'mamba activate reverse_vaccinology'"
    exit 1
fi

#### Settings ####

# directory with core genome amino acid sequences from Panaroo
aa_dir="preprocessed/panaroo"

# output directory for results
outdir="results/reverse_vaccinology_accessory"

# path to swissprot database
swissprot_db="databases/swissprot.dmnd"

# path to human proteome database
human_db="databases/human_proteome.dmnd"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# create output directory
mkdir -p $outdir

# Run PSORTb for Gram-negative bacteria
mkdir -p $outdir/panaroo

./psortb_app -i $aa_dir/core_genome_protein_sequences.fa -r $outdir/panaroo -n

# parse PSORTb output to get subcellular location predictions
python3 scripts/parse_psortb.py $outdir/panaroo/*.txt

# move panaroo locations file to output directory
mv panaroo_locations.csv $outdir

# run diamond on swissprot database
diamond blastp -d $swissprot_db -q $aa_dir/core_genome_protein_sequences.fa -o $outdir/function.tsv --outfmt 6 qseqid stitle evalue

# run diamond on human proteome database
diamond blastp -d $human_db -q $aa_dir/core_genome_protein_sequences.fa -o $outdir/human_homology.tsv --outfmt 6 qseqid stitle evalue pident

# identify potential vaccine candidates
python3 scripts/combine_results_core.py \
  --core_fasta $aa_dir/core_genome_protein_sequences.fa \
  --locations $outdir/panaroo_locations.csv \
  --function $outdir/function.tsv \
  --human $outdir/human_homology.tsv \
  --output $outdir/core_vaccine_candidates.csv