#!/bin/bash

# check if environment has been activated
if ! command -v tb-profiler 2>&1 >/dev/null
then
    echo "ERROR: tb-profiler not available, make sure to run 'mamba activate tb-profiler'"
    exit 1
fi

#### Settings #####

# directory with pseudogenome FASTA

fastq_dir="data/reads"

# output directory for results
outdir="results/tb-profiler"

# set prefix for collated results
prefix="Nam_TB"

#### End of settings ####

#### Analysis ####
# WARNING: be careful changing the code below

# create output directory
mkdir -p $outdir

# loop through each set of fastq files
for filepath in $fastq_dir/*_1.fastq.gz
do
    # get the sample name
    sample=$(basename ${filepath%_1.fastq.gz})

    # print a message
    echo "Processing $sample"

    # run tb-profiler command
    tb-profiler profile -1 $filepath -2 ${filepath%_1.fastq.gz}_2.fastq.gz -p $sample -t 8 --csv -d $outdir 2> $outdir/"$sample".log

    # Check if tb-profiler exited with an error
    if [ $? -ne 0 ]; then
        echo "tb-profiler failed for $sample. See $sample.log for details."
    else
        echo "tb-profiler completed successfully for $sample."
    fi
done

# run tb-profiler collate
tb-profiler collate -d $outdir/results --prefix $prefix

# move collated result to tb-profiler results directory
mv ${prefix}.* $outdir
