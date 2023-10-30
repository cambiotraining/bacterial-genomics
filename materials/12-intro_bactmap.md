---
title: "The nf-core/bactmap pipeline"
---

::: {.callout-tip}
## Learning Objectives

- Use `nf-core/bactmap` to produce a multiple sequence alignment.

:::

## nf-core/bactmap

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

Your next task is to run the **bactmap** pipeline on your data.  In the folder `scripts` (within your analysis directory) you will find a script named `02-run_bactmap.sh`. This script contains the code to run bactmap. Edit this script, adjusting it to fit your input files and the name and location of the reference you're going to map to.

Now, run the script using `bash scripts/02-run_bactmap.sh`.
  
If the script is running successfully it should start printing the progress of each job in the bactmap pipeline. The pipeline will take a while to run so we'll have a look at the results after lunch.

:::{.callout-answer}

We ran the script as instructed using:

```bash
bash scripts/02-run_bactmap.sh
```

While it was running it printed a message on the screen: 

```
NEXTFLOW OUTPUT - TODO
```

:::
:::



## Summary

::: {.callout-tip}
## Key Points

:::