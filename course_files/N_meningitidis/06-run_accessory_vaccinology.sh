#!/bin/bash

# check if environment has been activated
if ! command -v diamond 2>&1 >/dev/null
then
    echo "ERROR: diamond not available, make sure to run 'mamba activate accessory-vaccinology'"
    exit 1
fi

#### Settings ####

# panaroo directory with accessory genome amino acid sequences
panaroo_dir="preprocessed/panaroo"

# directory with significant_hits.tsv file from Pyseer
pyseer_dir="results/pyseer"

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

# extract accessory gene sequences using Pyseer results
python scripts/extract_gwas_hits.py \
    --hits_file $pyseer_dir/significant_hits.tsv \
    --pan_fasta $panaroo_dir/pan_genome_reference.fa \
    --output_fasta $panaroo_dir/gwas_hit_sequences.fa \
    --gene_column variant \
    --translate

# Run PSORTb for Gram-negative bacteria
mkdir -p $outdir/accessory

./psortb_app -i $panaroo_dir/gwas_hit_sequences.fa -r $outdir/accessory -n

# parse PSORTb output to get subcellular location predictions
python3 scripts/parse_psortb.py $outdir/accessory/*.txt

# move panaroo locations file to output directory
mv accessory_locations.csv $outdir

# run diamond on swissprot database
diamond blastp -d $swissprot_db -q $panaroo_dir/gwas_hit_sequences.fa -o $outdir/function.tsv --outfmt 6 qseqid stitle evalue

# run diamond on human proteome database
diamond blastp -d $human_db -q $panaroo_dir/gwas_hit_sequences.fa -o $outdir/human_homology.tsv --outfmt 6 qseqid stitle evalue pident

# identify potential vaccine candidates
python scripts/combine_results_core.py \
  --core_fasta $panaroo_dir/gwas_hit_sequences.fa \
  --locations $outdir/accessory_locations.csv \
  --function $outdir/function.tsv \
  --human $outdir/human_homology.tsv \
  --output $outdir/accessory_vaccine_candidates.csv