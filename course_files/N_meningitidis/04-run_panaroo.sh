#!/bin/bash

# check if environment has been activated
if ! command -v panaroo 2>&1 >/dev/null
then
    echo "ERROR: panaroo not available, make sure to run 'mamba activate panaroo'"
    exit 1
fi

# create output directory
mkdir -p results/panaroo/

# Run panaroo
panaroo \
  --input data/gff/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8

# extract core genes
python scripts/extract_panaroo_core.py \
    --gene_list_embl results/panaroo/core_alignment_filtered_header.embl \
    --ref_fasta results/panaroo/pan_genome_reference.fa \
    --output results/panaroo/core_genome_protein_sequences.fa \
    --translate
