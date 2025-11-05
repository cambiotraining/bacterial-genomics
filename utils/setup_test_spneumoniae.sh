#!/bin/bash

set -euxo pipefail

eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh

#### S. pneumoniae ####

cd S_pneumoniae

## 01-run_bactmap.sh
mamba activate nextflow

# samplesheet
python scripts/fastq_dir_to_samplesheet.py data/reads \
    samplesheet.csv \
    -r1 _1.fastq.gz \
    -r2 _2.fastq.gz

# create output directory
mkdir -p results/bactmap

# run the pipeline
nextflow run nf-core/bactmap \
  -r 1.0.0 \
  -resume -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samplesheet.csv \
  --outdir results/bactmap \
  --reference resources/reference/GCF_000299015.1_ASM29901v1_genomic.fna \
  --genome_size 2.0M


## 02-pseudogenome_check.sh
mamba activate seqtk

# directory with pseudogenome FASTA
fasta_dir="results/bactmap/pseudogenomes"

# output directory for results
outdir="results/bactmap/pseudogenomes_check"

# path to seqtk_parser.py
parser="scripts/seqtk_parser.py"

# create output directory
mkdir -p $outdir/seqtk

# loop through each pseudogenome
for filepath in $(ls $fasta_dir/*.fas | grep -v "aligned_")
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


## 03-run_gubbins.sh
mamba activate gubbins

# create output directory
mkdir -p results/gubbins/

# reference genome gff
gff=resources/reference/GCF_000299015.1_ASM29901v1_genomic.gff

# masked variants file to extract pairwise SNP distances from
alignment="results/bactmap/pseudogenomes/aligned_pseudogenomes.fas"

# prefix for gubbins outputs
prefix="sero1"

# output directory for results
outdir="results/gubbins"

# name of masked alignment
outfile="results/gubbins/aligned_pseudogenomes_masked.fas"

# run gubbins
run_gubbins.py --prefix $prefix --tree-builder iqtree $alignment

# move gubbins outputs to results directory
mv ${prefix}.* $outdir

# mask original alignment with recombinant regions
mask_gubbins_aln.py --aln $alignment --gff $outdir/${prefix}.recombination_predictions.gff --out $outfile

# run plot_gubbins.R to create plot of recombinant regions
plot_gubbins.R -t $outdir/${prefix}.final_tree.tre -r $outdir/${prefix}.recombination_predictions.gff -a $gff -o $outdir/${prefix}.recombination.png


## 04-run_iqtree.sh
mamba activate iqtree

# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# extract variable sites
snp-sites preprocessed/gubbins/aligned_pseudogenomes_masked.fas > results/snp-sites/aligned_pseudogenomes_masked_snps.fas

# count invariant sites
snp-sites -C preprocessed/gubbins/aligned_pseudogenomes_masked.fas > results/snp-sites/constant_sites.txt

# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s results/snp-sites/aligned_pseudogenomes_masked_snps.fas \
  --prefix results/iqtree/sero1 \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m MFP \
  -bb 1000


## 05-run_poppunk.sh
mamba activate poppunk

# create assemblies.txt
cat << EOF > assemblies.txt
ERX1265396_ERR1192012_T1	preprocessed/assemblebac/assemblies/ERX1265396_ERR1192012_T1_contigs.fa
ERX1265488_ERR1192104_T1	preprocessed/assemblebac/assemblies/ERX1265488_ERR1192104_T1_contigs.fa
ERX1501202_ERR1430824_T1	preprocessed/assemblebac/assemblies/ERX1501202_ERR1430824_T1_contigs.fa
ERX1501203_ERR1430825_T1	preprocessed/assemblebac/assemblies/ERX1501203_ERR1430825_T1_contigs.fa
ERX1501204_ERR1430826_T1	preprocessed/assemblebac/assemblies/ERX1501204_ERR1430826_T1_contigs.fa
EOF

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


## 06-plot_phylogeny.R

Rscript scripts/06-plot_phylogeny.R


## 07-run_funcscan.sh
mamba activate nextflow

# samplesheet
cat << EOF > samplesheet_funcscan.csv
sample,fasta
ERX1265396_ERR1192012_T1,preprocessed/assemblebac/assemblies/ERX1265396_ERR1192012_T1_contigs.fa
ERX1265488_ERR1192104_T1,preprocessed/assemblebac/assemblies/ERX1265488_ERR1192104_T1_contigs.fa
ERX1501202_ERR1430824_T1,preprocessed/assemblebac/assemblies/ERX1501202_ERR1430824_T1_contigs.fa
ERX1501203_ERR1430825_T1,preprocessed/assemblebac/assemblies/ERX1501203_ERR1430825_T1_contigs.fa
ERX1501204_ERR1430826_T1,preprocessed/assemblebac/assemblies/ERX1501204_ERR1430826_T1_contigs.fa
EOF

# create output directory
mkdir -p results/funcscan

# run the pipeline
nextflow run nf-core/funcscan \
  -r 2.1.0 \
  -resume -profile singularity \
  --input samplesheet_funcscan.csv \
  --outdir results/funcscan \
  --run_arg_screening \
  --arg_rgi_db databases/card/ \
  --arg_skip_deeparg
