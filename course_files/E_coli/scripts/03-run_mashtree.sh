#!/bin/bash

# check if environment has been activated
if ! command -v mashtree 2>&1 >/dev/null
then
    echo "ERROR: mashtree not available, make sure to run 'mamba activate mashtree'"
    exit 1
fi


# create output directory
mkdir -p results/mashtree

# run mashtree on the assemblies
mashtree --mindepth 0 --numcpus 12 data/assemblies/*.fa > results/mashtree/tree.nwk
