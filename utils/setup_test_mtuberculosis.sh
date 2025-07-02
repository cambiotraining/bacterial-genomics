#!/bin/bash

set -euxo pipefail

eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

#### Mycobacterium tuberculosis ####

cd M_tuberculosis

## 01-fetch_ngs.sh
mamba activate nextflow

# samplesheet
echo "ERR9907668
ERR9907669
ERR9907670
ERR9907671
ERR9907672" > samples.csv

# create output directory
mkdir -p results/fetchngs

# run the pipeline
nextflow run nf-core/fetchngs \
  -r 1.12.0 \
  -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samples.csv \
  --outdir results/fetchngs \
  --nf_core_pipeline viralrecon \
  --download_method sratools


## 02-run_bacqc.sh
mamba activate nextflow

# samplesheet
python scripts/fastq_dir_to_samplesheet.py data/reads \
    samplesheet.csv \
    -r1 _1.fastq.gz \
    -r2 _2.fastq.gz

# create output directory
mkdir -p results/bacqc

# run the pipeline
nextflow run avantonder/bacQC \
  -r "v2.0.1" \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samplesheet.csv \
  --outdir results/bacqc \
  --kraken2db databases/k2_standard_08gb_20240605 \
  --kronadb databases/krona/taxonomy.tab \
  --genome_size 4400000


## 03-run_bactmap.sh
mamba activate nextflow

# create output directory
mkdir -p results/bactmap

# run the pipeline
nextflow run nf-core/bactmap \
  -r 1.0.0 \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samplesheet.csv \
  --outdir results/bactmap \
  --reference resources/reference/MTBC0.fasta \
  --genome_size 4.3M


## 04-pseudogenome_check.sh
mamba activate seqtk

# directory with pseudogenome FASTA
fasta_dir="preprocessed/bactmap/pseudogenomes"

# output directory for results
outdir="results/bactmap/pseudogenomes_check"

# path to seqtk_parser.py
parser="scripts/seqtk_parser.py"

# create output directory
mkdir -p $outdir/seqtk

# rename aligned_pseudogenomes.fas
mv $fasta_dir/aligned_pseudogenomes.fas $fasta_dir/aligned_pseudogenomes.fasta

# loop through each pseudogenome
for filepath in $fasta_dir/*.fas
do
    # get the sample name
    sample=$(basename $filepath)

    # print a message
    echo "Processing $sample"

    # run seqtk command
    seqtk comp $filepath > ${outdir}/seqtk/${sample}.tsv
done

# run seqtk_parser.py
python $parser --input_dir $outdir/seqtk

# move mapping_summary.tsv to results/bactmap/pseudogenomes_check
mv mapping_summary.tsv $outdir

# rename aligned_pseudogenomes.fas
mv $fasta_dir/aligned_pseudogenomes.fasta $fasta_dir/aligned_pseudogenomes.fas


## 05-mask_pseudogenome.sh
mamba activate remove_blocks

# directory with pseudogenome FASTA
fasta_dir="preprocessed/bactmap/pseudogenomes"

# output directory for results
outdir="results/bactmap/masked_alignment"

# path to bed file with masking co-ordinates
bed="resources/masking/MTBC0_Goigetal_regions_toDiscard.bed"

# create output directory
mkdir -p $outdir

# copy pseudogenome alignment to output directory
cp $fasta_dir/aligned_pseudogenomes.fas $outdir

# mask alignment with co-ordinates in bed file
remove_blocks_from_aln.py -a $outdir/aligned_pseudogenomes.fas -t $bed -o $outdir/aligned_pseudogenomes_masked.fas


## 06-run_iqtree.sh
mamba activate iqtree

# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# extract variable sites
snp-sites results/bactmap/masked_alignment/aligned_pseudogenomes_masked.fas > results/snp-sites/aligned_pseudogenomes_masked_snps.fas

# count invariant sites
snp-sites -C results/bactmap/masked_alignment/aligned_pseudogenomes_masked.fas > results/snp-sites/constant_sites.txt

# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s results/snp-sites/aligned_pseudogenomes_masked_snps.fas \
  --prefix results/iqtree/Nam_TB \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m GTR+F+I \
  -bb 1000


## Root tree
python scripts/root_tree.py -i preprocessed/iqtree/Nam_TB.treefile -g MTBC0 -o results/iqtree/Nam_TB_rooted.treefile


## 07-run_tb-profiler.sh
mamba activate tb-profiler

# directory with pseudogenome FASTA
fastq_dir="data/reads"

# output directory for results
outdir="results/tb-profiler"

# set prefix for collated results
prefix="Nam_TB"

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


## 08-run_treetime.sh
mamba activate treetime

# create output directory
mkdir -p results/treetime/

# Remove outgroup from alignment
seqkit grep -v -p MTBC0 preprocessed/bactmap/masked_alignment/aligned_pseudogenomes_masked.fas > results/treetime/aligned_pseudogenomes_masked_no_outgroups.fas 

# Remove outgroup from rooted tree
python scripts/remove_outgroup.py -i results/iqtree/Nam_TB_rooted.treefile -g MTBC0 -o results/treetime/Nam_TB_rooted_no_outgroup.treefile

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


## 09-run_pairsnp.sh
mamba activate pairsnp

# create output directory
mkdir -p results/transmission/

# masked variants file to extract pairwise SNP distances from
snp_file="preprocessed/snp-sites/aligned_pseudogenomes_masked_snps.fas"

# output file
outfile="results/transmission/aligned_pseudogenomes_masked_snps.csv"

# Run pairsnp
pairsnp $snp_file -c > $outfile
