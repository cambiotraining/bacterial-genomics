#!/bin/bash

#### Settings ####

# directory with .faa files
aa_dir="data/faa"

# output directory for results
outdir="results/psortb"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# create output directory
mkdir -p $outdir

# create locations output directory
mkdir -p $outdir/locations

# Loop through each protein file from Bakta and run PSORTb
for PROTEINS in $(ls $aa_dir/*.faa | head -n 2); do
  STRAIN_ID=$(basename ${PROTEINS} .faa)
  
  mkdir -p $outdir/${STRAIN_ID}
  
  # Run PSORTb for Gram-negative bacteria
  ./psortb_app -i ${PROTEINS} -r $outdir/${STRAIN_ID} -n

  # parse PSORTb output to get subcellular location predictions
  python3 scripts/parse_psortb.py $outdir/${STRAIN_ID}/*.txt

  # move locations file to output directory
  mv ${STRAIN_ID}_locations.csv $outdir/locations/
done