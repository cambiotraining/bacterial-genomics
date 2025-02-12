#!/bin/bash

# check if environment has been activated
if ! command -v treetime 2>&1 >/dev/null
then
    echo "ERROR: treetime not available, make sure to run 'mamba activate treetime'"
    exit 1
fi

# create output directory
mkdir -p results/treetime/

# Remove outgroup from alignment
seqkit grep -v -p MTBC0 preprocessed/bactmap/masked_alignment/aligned_pseudogenomes_masked.fas > results/treetime/aligned_pseudogenomes_masked_no_outgroups.fas 

# Remove outgroup from rooted tree
python scripts/remove_outgroup.py -i Nam_TB_rooted.treefile -g MTBC0 -o results/treetime/Nam_TB_rooted_no_outgroup.treefile

# Run TreeTime
treetime --tree results/treetime/Nam_TB_rooted_no_outgroup.treefile \
        --dates TB_metadata.tsv \
        --name-column sample \
        --date-column Date.sample.collection \
        --aln results/treetime/aligned_pseudogenomes_masked_no_outgroups.fas \
        --outdir results/treetime \
        --report-ambiguous \
        --time-marginal only-final \
        --clock-std-dev 0.00003 \
        --relax 1.0 0