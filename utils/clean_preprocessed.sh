#!/bin/bash

# Note: This is not a complete script

#### bacQC ####

# remove fastq files
find preprocessed/bacqc -type f -name "*.fastq.gz" -delete

# replace kraken files with placeholders
find preprocessed/bacqc -type f -name "*.kraken2.classifiedreads.txt" -exec sh -c 'echo "This is a placeholder file only. The original file was too large, so we removed it from the training materials." > "$1"' _ {} \;
