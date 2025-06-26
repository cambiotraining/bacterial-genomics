---
title: "OUTBREAK ALERT! - Trainer solutions"
---

# Illumina data analysis

## QC

Run `avantonder/bacQC` ([link to section](09-bacqc.md)). 

Start by creating the samplesheet using the helper script: 

```bash
python scripts/fastq_dir_to_samplesheet.py data/reads/ --read1_extension "_1.fastq.gz" --read2_extension "_2.fastq.gz" samplesheet.csv
```

Then run bacQC, with command below.
Participants will need to "guess" a genome size, as they won't know what it is. 
The genome size is not critical for the analysis.

```bash
nextflow run avantonder/bacQC \
  -r "v1.2" \
  -resume -profile "singularity" \
  --input "samplesheet.csv" \
  --outdir "results/bacqc" \
  --kraken2db "databases/k2_standard_08gb_20240605" \
  --kronadb databases/krona/taxonomy.tab \
  --genome_size "3200000"
```

From the QC participants should notice: 

- Isolate02 has very few reads, which might lead to poor assemblies - they can choose whether to proceed with it or not
- The Kraken barplot reveals that we are dealing with a _Vibrio cholerae_ outbreak.
- However, isolate08 is _Vibrio parahaemolyticus_. The GC content was also slightly different for this isolate. 
  - again, they can choose to proceed with this sample or not - however proceeding is nice to use as an outgroup for phylogeny later on.

::: callout-tip
#### Shell scripts

Encourage participants to write their commands in a shell script for reproducibility and documentation. 
:::


## Assembly

Run `avantonder/assembleBAC` ([link to section](20-assemblebac.md)):

```bash
nextflow run avantonder/assembleBAC \
  -r "v1.2.1" \
  -resume -profile "singularity" \
  --input "samplesheet.csv" \
  --outdir "results/assemblebac" \
  --baktadb "databases/bakta_light_20240119" \
  --genome_size "3.2M" \
  --checkm2db "databases/checkm2_v2_20210323/uniref100.KO.1.dmnd"
```

:::{.callout-warning}
#### Preprocessed data

`assembleBAC` takes a long time to run (up to 1h). 
To avoid waiting for that long, there is a preprocessed folder in a shared drive on the training machines. 
Files can be copied from there, once they are running the pipeline successfully: 

```bash
cp -r ~/Course_Share/preprocessed-outbreak ~/Course_Materials/outbreak/preprocessed
```
:::

From the assemblies participants should notice: 

- MultiQC report: 
  - If they proceeded with isolate02, they will notice very poor assembly, essentially unusable. 
  - Other samples are all comparable in quality, some more fragmented than others, but not massively different
- The `checkm2_report.tsv` (in the `report` output folder):
  - Very high assembly completeness for all samples (except isolate02).
  - Isolate08 is again a bit different: slightly lower GC content (matches what was seen with bacQC) and higher predicted genome size at ~5Mb and higher number of predicted genes. 
  - As further QC they can compare these numbers with the ones on reference databases, for example on KEGG: [V. parahaemolyticus](https://www.genome.jp/kegg-bin/show_organism?org=T00120); [V. cholerae](https://www.genome.jp/entry/gn:T00034)


## Core genome alignemnt

Create a script to run Panaroo ([link to section](24-panaroo.md)).
This takes a while to run, but we provide preprocessed files if they want to proceed from there once their command is working and running.

```bash
mamba activate panaroo

# create output directory
mkdir results/panaroo

# ensure isolate02 is not being used - they might do this in a more "manual" way
gffs=$(ls results/assemblebac/annotation/*.gff3 | grep -v "isolate02")

# run panaroo
panaroo \
  --input $gffs \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
```

::: callout-tip
#### Discussing use of an outgroup

We're including _V. parahaemolyticus_ to use as an outgroup in our phylogeny.
However, it's worth noting that by doing so we may be reducing the number of core genes in the alignment, as these species may be sufficiently diverged to alter the Panaroo clustering. 
One possibility would be to lower the `--core_threshold` to include a few more genes. 

There is no clear "right" answer, but this could be a good discussion to have with the participants. 
:::


## Phylogeny

Once participants have the core alignment, they can build their trees by writing a script to run IQ-tree ([link to section](12-phylogenetics.md)).

```bash
# create output directory
mkdir -p results/snp-sites/
mkdir -p results/iqtree/

# extract variable sites
snp-sites results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/core_gene_alignment_snps.aln

# count invariant sites
snp-sites -C results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/constant_sites.txt

# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s results/snp-sites/core_gene_alignment_snps.aln \
  --prefix results/iqtree/vibrio_outbreak \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m MFP \
  -bb 1000
```

Participants can visualise the phylogeny in Microreact, FigTree or R/ggtree - their choice.
Encourage participants to include metadata from other analyses (e.g. MLST and AMR).


## MLST

Although `assembleBAC` runs MLST, participants may opt to run this separately as well ([link to section](22-strain_typing.md)). 

They can use the `mlst --list` command to see which schemes are available for _Vibrio_. 
There are actually two schemes available, named `vcholerae` and `vcholerae_2`. 
They can run both: 

```bash
mamba activate mlst

mkdir results/mlst

# exclude isolate02 and 08
samples=$(ls results/assemblebac/assemblies/*.fa | grep -v "isolate02\|isolate08")

mlst --scheme vcholerae $samples > results/mlst/mlst_typing_scheme1.tsv
mlst --scheme vcholerae_2 $samples > results/mlst/mlst_typing_scheme2.tsv
```

Participants should notice that most isolates fall under [profile 69](https://pubmlst.org/bigsdb?page=profileInfo&db=pubmlst_vcholerae_seqdef&scheme_id=1&profile_id=69), except isolate09 and isolate10.
This should match what they see in the phylogeny. 


## AMR

Participants can upload their FASTA assemblies to Pathogenwatch, which implements its own AMR analysis method ([link to section](31-pathogenwatch.md)). 

In addition, they can use the funcscan workflow ([link to section](34-command_line_amr.md)). 
First we need to create the funcscan samplesheet with two columns: "sample" and "fasta".

This can be done manually, but we provide some code here as a (slightly convoluted) way to do this with the command line. 
We do not expect you to share this with the participants, it's here for trainers' convenience, if you want to copy/paste to run the workflow quicker.

```bash
# get sample names into temporary file - excluding isolate02 and isolate08
basename -a results/assemblebac/assemblies/*.fa | sed 's/_T1_contigs.fa//' | grep -v "isolate02\|isolate08" > temp_samples
# get FASTA files into temporary file - excluding isolate02 and isolate08
ls results/assemblebac/assemblies/*.fa | grep -v "isolate02\|isolate08" > temp_fastas
# create samplesheet header
echo "sample,fasta" > samplesheet_funcscan.csv
# paste the temporary files and append to samplesheet
paste -d "," temp_samples temp_fastas >> samplesheet_funcscan.csv
# remove temporary files
rm temp_samples temp_fastas
```

The following can be used in a shell script to run the workflow: 

```bash
nextflow run nf-core/funcscan \
  -r "1.1.6" \
  -resume -profile "singularity" \
  --input "samplesheet_funcscan.csv" \
  --outdir "results/funcscan" \
  --run_arg_screening \
  --arg_skip_deeparg
```
# ONT data analysis

## QC

Run `avantonder/bacQC-ONT` ([link to section](37-plasmids.md)). 

Start by creating the samplesheet: 

```
sample,fastq
sample1,data/fastq_pass/barcode01/ERR10146532.fastq.gz
sample2,data/fastq_pass/barcode06/ERR10146521.fastq.gz
sample3,data/fastq_pass/barcode02/ERR10146551.fastq.gz
sample4,data/fastq_pass/barcode09/ERR10146531.fastq.gz
sample5,data/fastq_pass/barcode05/ERR10146520.fastq.gz
```

Then run bacQC-ONT, with command below.
Participants will need to "guess" a genome size, as they won't know what it is. 
The genome size is not critical for the analysis.

```bash
nextflow run avantonder/bacQC-ONT \
   -profile singularity \
   --input samplesheet.csv \
   --summary_file sequencing_summary.txt \
   --genome_size 4000000 \
   --kraken2db databases/k2_standard_08gb_20240605/ \
   --kronadb databases/krona/taxonomy.tab \
   --outdir results/bacqc-ont
```

## Assembly

Run `avantonder/assembleBAC-ONT` ([link to section](37-plasmids.md)):

```bash
nextflow run avantonder/assembleBAC-ONT \
    -profile singularity \
    --input samplesheet.csv \
    --genome_size 4M \
    --medaka_model r941_min_fast_g507 \
    --outdir results/assemblebac \
    --baktadb databases/bakta_light_20240119/ \
    --checkm2db databases/checkm2_v2_20210323/uniref100.KO.1.dmnd
```

:::{.callout-warning}
#### Preprocessed data

`assembleBAC` takes a long time to run (up to 2h). 
To avoid waiting for that long, there is a preprocessed folder in a shared drive on the training machines. 
Files can be copied from there, once they are running the pipeline successfully: 

```bash
cp -r ~/Course_Share/preprocessed-outbreak ~/Course_Materials/outbreak/preprocessed
```
:::

## Core genome alignemnt

Create a script to run Panaroo ([link to section](24-panaroo.md)).
This takes a while to run, but we provide preprocessed files if they want to proceed from there once their command is working and running.

```bash
mamba activate panaroo

# create output directory
mkdir results/panaroo

# run panaroo
panaroo \
  --input results/assemblebac/bakta/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
```