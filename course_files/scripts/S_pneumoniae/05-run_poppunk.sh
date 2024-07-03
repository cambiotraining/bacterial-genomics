#!/bin/bash

# before running this script make sure to
# mamba activate poppunk

# create output directory
mkdir -p results/poppunk/

# PopPUNK database
db="databases/poppunk/GPS_v8_ref"

# GPSC designations
clusters="databases/poppunk/GPS_v8_external_clusters.csv"

# list of assemblies
assemblies="assemblies.txt"

# output directory for results
outdir="results/poppunk"

# run PopPUNK
poppunk_assign --db $db --external-clustering $clusters --query $assemblies --output $outdir --threads 8
