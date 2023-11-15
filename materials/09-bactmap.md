---
title: "The nf-core/bactmap pipeline"
---

::: {.callout-tip}
## Learning Objectives

- Understand what the `nf-core/bactmap` pipeline can do
- Learn where the output files created by nf-core/bactmap are located.
- Understand the output files created by nf-core/bactmap.
- Learn how to interpret a MultiQC summary and make a decision whether to exclude poor quality samples.
- Use `nf-core/bactmap` to produce a multiple sequence alignment.

:::

## Pipeline Overview

nf-core/bactmap is a bioinformatics analysis pipeline for mapping short reads from bacterial WGS to a reference sequence, creating filtered VCF files, making pseudogenomes based on high quality positions in the VCF files and optionally creating a phylogeny from an alignment of the pseudogenomes.  

![nf-core/bactmap variant calling pipeline diagram from nf-core (https://nf-co.re/bactmap).](images/Bactmap_pipeline.png)

It runs the following tools:

- [`BWA index`](https://github.com/lh3/bwa) - indexes reference fasta file
- [`fastp`](https://github.com/OpenGene/fastp) - trims reads for quality and adapter sequences (Optional)
- [`mash sketch`](https://mash.readthedocs.io/en/latest/index.html) - estimates genome size if not provided
- [`Rasusa`](https://github.com/mbhall88/rasusa) - downsamples fastq files to 100X by default (Optional)
- [`BWA mem`](https://github.com/lh3/bwa) - maps reads to the reference
- [`SAMtools`](https://sourceforge.net/projects/samtools/files/samtools/) - sorts and indexes alignments 
- [`BCFtools`](http://samtools.github.io/bcftools/bcftools.html) - calls and filters variants
- [`vcf2pseudogenome.py`](https://github.com/nf-core/bactmap/blob/dev/bin/vcf2pseudogenome.py) - converts filtered bcf to pseudogenome FASTA
- [`calculate_fraction_of_non_GATC_bases.py`](https://github.com/nf-core/bactmap/blob/dev/bin/) - creates whole genome alignment from pseudogenomes by concatenating fasta files having first checked that the sample sequences are high quality
- [`Gubbins`](https://sanger-pathogens.github.io/gubbins/) - identifies recombinant regions (Optional)
- [`SNP-sites`](https://github.com/sanger-pathogens/snp-sites) - extracts variant sites from whole genome alignment
- [`RapidNJ`](https://birc.au.dk/software/rapidnj/), [`FastTree2`](http://www.microbesonline.org/fasttree/), [`IQ-TREE`](http://www.iqtree.org/), [`RAxML-NG`](https://github.com/amkozlov/raxml-ng) - construct phylogenetic tree (Optional)

See [Course Software](appendices/02-course_software.md) for a more detailed description of each tool.

Along with the outputs produced by the above tools, the pipeline produces the following summaries containing results for all samples run through the pipeline:

- `multiqc_report.html` - final summary of trimming and mapping statistics for input files in HTML format

## Running nf-core/bactmap

The bactmap pipeline requires a samplesheet CSV file in the same format as the one we used for bacQC so we can re-use that samplesheet CSV file. If you decided to remove any samples because they didn't pass the QC, then edit the samplesheet CSV file accordingly. There are [many options](https://github.com/nf-core/bactmap/blob/1.0.0/docs/usage.md) that can be used to customise the pipeline but a typical command is shown below:

```bash
nextflow run nf-core/bactmap \
  -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir results/bactmap \
  --reference REFERENCE \
  --genome_size 4.3M
```

:::{.callout-exercise}

#### Running nf-core/bactmap

Your next task is to run the **bactmap** pipeline on your data.  In the folder `scripts` (within your analysis directory) you will find a script named `02-run_bactmap.sh`. This script contains the code to run bactmap. Edit this script, adjusting it to fit your input files and the name and location of the reference you're going to map to (Hint: the reference sequence is located in `resources/reference`).

Now, run the script using `bash scripts/02-run_bactmap.sh`.
  
If the script is running successfully it should start printing the progress of each job in the bactmap pipeline. The pipeline will take a while to run so we'll have a look at the results after lunch.

:::{.callout-answer}

We ran the script as instructed using:

```bash
bash scripts/02-run_bactmap.sh
```

While it was running it printed a message on the screen: 

```bash
N E X T F L O W  ~  version 23.04.1
Launching `https://github.com/nf-core/bactmap` [cranky_swartz] DSL2 - revision: e83f8c5f0e [master]


------------------------------------------------------
                                        ,--./,-.
        ___     __   __   __   ___     /,-._.--~'
  |\ | |__  __ /  ` /  \ |__) |__         }  {
  | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                        `._,._,'
  nf-core/bactmap v1.0.0
------------------------------------------------------
```

:::
:::

## bactmap results

Before the tea break, we left `bactmap` running.  Now, we can look at the output directory (`results/bactmap`) to see the various directories containing output files created by `bactmap`:

| Directory | Description |
|:-- | :---------- |
| `bwa/index` | Contains the index of the reference sequence |
|`fastp` | Contains the results of the trimming and adapter removal performed by `fastp` |
|`fastqc` | Contains QC metrics for the fastq files generated with `fastQC` |
|`multiqc` | Contains a html file containing summaries of the various outputs |
|`pipeline_info` | Contains information about the pipeline run |
|`pseudogenomes` | Contains consensus fasta files for each sample which have the sample variants compared to the reference included.  The alignment we'll use for the next step can also be found in this directory (`aligned_pseudogenomes.fas`) |
|`rasusa` | Contains the subsampled post-trimmed fastq files |
|`samtools` | Contains the sorted bam files and indices created by `bwa` and `samtools` as part of the mapping process |
|`snpsites` | Contains a variant alignment file created from `aligned_pseudogenomes.fas` with `snp-sites `that can be used as input for tree inference tools |
|`variants` | Contains filtered `vcf` files which contain the variants for each sample |

### The MultiQC summary report

The first thing we'll check is the `html` report file created by `MultiQC`.  Go to `File Explorer`, navigate to results/bactmap/multiqc/ and double click on `multiqc_report.html`.  This will open the file in your web browser of choice:

![config](images/bactmap_multiqc.png)

#### General statistics

Let's go through each section starting with the `General Statistics`:

![nf-core/bactmap MultiQC General Statistics](images/bactmap_general_stats.png)

This is a compilation of statistics collected from the outputs of tools such as fastp, samtools and BCFtools.  Sequencing metrics such as the % of duplicated reads and GC content of the reads are shown alongside the results of the mapping (% reads mapped, num). This is a useful way of quickly identifying samples that are of lower quality or perhaps didn't map very well due to species contamination. 

#### fastp

There are a number of plots showing the results of the fastp step in the pipeline.  These plots are explained in [The bacQC pipeline](07-bacqc.md).

#### Samtools

The plots in this section are created from the results of running `samtool stats` on the sorted bam files produce during the mapping process.  The first shows the number or percentage of reads that mapped to the reference.

![nf-core/bactmap MultiQC samtools mapping](images/bactmap_samtools_mapping.png)

The second plot shows the overall alignment metrics for each sample.  Hover over each dot to see more detailed information.

![nf-core/bactmap MultiQC samtools alignment](images/bactmap_samtools_alignment.png)

#### BCFtools

The plots in this section provide information about the variants called using `bcftools`.  The first plot shows the numbers or percentage of each type of variant in each sample.

![nf-core/bactmap MultiQC bcftools variants](images/bactmap_bcftools_variants.png)

The second plot shows the quality of each variant called by `bcftools`. The majority of variants in each sample are high quality.

![nf-core/bactmap MultiQC bcftools variant quality](images/bactmap_bcftools_variant_quality.png)

The third plot shows the distribution of lengths of Indels (insertions are positive values and deletions are negative values).  This is useful information to have, but in practice we tend to exclude indels when building alignments for phylogenetic tree building.

![nf-core/bactmap MultiQC bcftools indel distribution](images/bactmap_bcftools_indel_distribution.png)

The final bcftools plot shows the distribution of the number of reads mapping to each variant position and is one of the metrics used to filter out low quality variants (the fewer the reads mapping to a variant position, the lower the confidence we have that the variant is in fact real).

![nf-core/bactmap MultiQC bcftools variant depth](images/bactmap_bcftools_variant_depth.png)

#### Software versions

This section of the report shows the software run as part of nf-core/bactmap and the versions used.  This is particularly important when reproducing the analysis on a different system or when writing the methods section of a paper.

![nf-core/bactmap MultiQC software versions](images/bactmap_software_versions.png)


## Check how much of the reference was mapped

It's good practice to do an additional check of our mapping results before proceeding to the next step of our analysis, phylogenetic tree inference.  We can do this by checking how much of the reference genome was mapped in each sample and use a tool called `seqtk` to do this.  If a position in the reference genome is not found in the sample it is marked as a `N` and any regions of the reference that were not mapped to sufficient quality are marked as `-`. So we use `seqtk` to count the number of A's, C's, G's and T's, sum the totals and then divide by the length of the reference sequence.  This gives us a proportion (we can convert to a % by multiplying by 100) of the reference sequence that was mapped in each sample.  Ideally, we would like to see more than 90% of the reference mapped but this will depend on the species and how close the reference is to the samples you're analysing. However, anything more than 75% should be sufficient for most applications.  The main impact of less mapping is fewer phylogenetically informative positions for constructing phylogenetic trees.

:::{.callout-exercise}
#### How much of the reference was mapped?

`conda activate seqtk`

`bash scripts/03-pseudogenome_check.sh`

:::{.callout-answer}

```bash
bash scripts/03-pseudogenome_check.sh
```

:::
:::

## Create final alignment

aligned pseudogenomes else cat

## Mask final alignment

```bash
conda activate remove_blocks

remove_blocks_from_aln.py -a aligned_pseudogenomes.fas -t ../../../resources/masking/MTBC0_Goigetal_regions_toDiscard.bed -o aligned_pseudogenomes_masked.fas

bash scripts/04-mask_pseudogenome.sh
```
## Summary

::: {.callout-tip}
## Key Points

:::