---
title: "The bacQC pipeline"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what the bacQC pipeline does.

:::

## Pipeline Overview

![The bacQC pipeline](images/bacQC_metromap.png)

**bacQC** is a bioinformatics analysis pipeline written in Nextflow that automates the **Q**uality **C**ontrol of short read sequencing data.  It runs the following tools: 

- [`fastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) - assesses sequencing read quality
- [`fastq-scan`](https://github.com/rpetit3/fastq-scan) - calculates FASTQ summary statistics
- [`fastp`](https://github.com/OpenGene/fastp) - performs adapter/quality trimming on sequencing reads
- [`Kraken2`](https://ccb.jhu.edu/software/kraken2/) - assigns taxonomic labels to reads
- [`Bracken`](https://ccb.jhu.edu/software/bracken/) - refines `Kraken2` assignments
- [`MultiQC`](https://multiqc.info/) - summarises and creates visualizations for outputs from `fastQC`, `fastp` and `MultiQC`

See [Course Software](appendices/02-course_software.md) for a more detailed description of each tool.

Along with the outputs produced by the above tools, the pipeline produces the following summaries containing results for all samples run through the pipeline:

- `raw_fastq-scan_summary.tsv` - final summary of FASTQ summary statistics for input files in TSV format
- `trim_fastq-scan_summary.tsv` - final summary of FASTQ summary statistics for trimmed FASTQ files
- `read_stats_summary.tsv` - final summary of pre- and post-trimming sequence statistics in TSV format
- `species_composition.tsv` - final summary of taxonomic assignment in TSV format in TSV format

## Preparing Files

On our computers, for each of the three species we will be working with on the course, we have a directory in `~/Documents/bacterial_genomics` for each species where we will do all our analysis. 
We already included the following in each species directory: 
 
- `data` → contains the sequencing files we will be working with. 
- `resources` → where we include other files we will be using such as reference genomes, and some background datasets that will be used with some of the tools we will cover. 
- `scripts` → where we include some scripts that we will use during the course. You will also create several scripts during the course, which you will save here. 
- `sample_info.csv` → a table with some metadata for our samples.

:::{.callout-exercise}

Your first task is to **create two new directories** in each species folder called `report` and `results`. 
You can do this either using the file explorer <i class="fa-solid fa-folder"></i> or from the command line (using the `mkdir` command). 

:::

### Data

Your analysis starts with FASTQ files (if you need a reminder of what a FASTQ file is, look at the [Intro to NGS > FASTQ](02-intro_wgs.html#FASTQ_Files) section of the materials). The Illumina files come as compressed FASTQ files (`.fastq.gz` format) and there's two files per sample, corresponding to read 1 and read 2. 
This is indicated by the file name suffix: 

- `*_1.fastq.gz` for read 1
- `*_2.fastq.gz` for read 2

You can look at the files you have available in any of the species directories from the command line using: 

```bash
ls data/reads
```

### Metadata

A critical step in any analysis is to make sure that our samples have all the relevant metadata associated with them. This is important to make sense of our results and produce informative reports at the end. There are many types of information that can be collected from each sample and for effective genomic surveillance, we need at the very minimum three pieces of information:

- **When**: date when the sample was collected (not when it was sequenced!).
- **Where**: the location where the sample was collected (not where it was sequenced!).
- **Source**: the source of the the sample e.g. host, environment.

Of course, this is the `minimum` metadata we need for a useful analysis. 
However, the more information you collect about each sample, the more questions you can ask from your data -- so always remember to record as much information as possible for each sample. 

:::{.callout-warning}

**Dates in Spreadsheet Programs**

Note that programs such as _Excel_ often convert date columns to their own format, and this can cause problems when analysing data later on. 
For example, GISAID wants dates in the format YYYY-MM-DD, but by default _Excel_ displays dates as DD/MM/YYYY.  
You can change how _Excel_ displays dates by highlighting the date column, right-clicking and selecting <kbd>Format cells</kbd>, then select "Date" and pick the format that matches YYYY-MM-DD. 
However, every time you open the CSV file, _Excel_ annoyingly converts it back to its default format!

To make sure no date information is lost due to _Excel_'s behaviour, it's a good idea to store information about year, month and day in separate columns (stored just as regular numbers).

:::

## Prepare a samplesheet

Before we run **bacQC**, we need to prepare a CSV file with information about our sequencing files which will be used as an input to the **bacQC** pipeline (for this exercise we're going to QC the MTBC dataset described in Introduction to *Mycobacterium tuberculosis*).  The pipeline's documentation gives details about the format of this samplesheet: https://github.com/avantonder/bacQC/blob/main/docs/usage.md.

:::{.callout-exercise}

Prepare the input samplesheet for `bacQC`.  You can do this using `Excel`, making sure you save it as a CSV file (<kbd>File</kbd> → <kbd>Save As...</kbd> and choose "CSV" as the file format).  Alternatively, you can use the `fastq_dir_to_samplesheet.py` script that can be found in the `scripts` directory:

```bash
python scripts/fastq_dir_to_samplesheet.py data/reads \
    samplesheet.csv \
    -r1 _1.fastq.gz \
    -r2 _2.fastq.gz
```

Now, you can open this file in `Excel` and edit the path to the data (it's good practice to use the actual path rather than the relative path). 

:::

## Running bacQC

Now that we have the samplesheet, we can run the `bacQC` pipeline.  There are [many options](https://github.com/avantonder/bacQC/blob/main/docs/parameters.md) that can be used to customise the pipeline but a typical command is shown below:

```bash
nextflow run avantonder/bacQC \
  -r main \
  -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir results/bacqc \
  --kraken2db databases/minikraken2_v1_8GB \
  --brackendb databases/minikraken2_v1_8GB \
  --genome_size GENOME_SIZE 
```

:::{.callout-exercise}
#### Running bacQC

Your next task is to run the **bacQC** pipeline on your data.  In the folder `scripts` (within your analysis directory) you will find a script named `01-run_bacqc.sh`. This script contains the code to run bacQC. Edit this script, adjusting it to fit your input files and the estimated genome size of *M. tuberculosis*.

Now, run the script using `bash scripts/01-mash.sh`.
  
If the script is running successfully it should start printing the progress of each job in the bacQC pipeline. This will take a little while to finish. <i class="fa-solid fa-mug-hot"></i>

:::{.callout-answer}

We ran the script as instructed using:

```bash
bash scripts/01-run_bacQC.sh
```

While it was running it printed a message on the screen: 

```
NEXTFLOW OUTPUT - TODO
```

:::
:::

:::{.callout-warning}

**Maximum Memory and CPUs**

In our `Nextflow` command above we have set `--max_memory '15.GB' --max_cpus 8` to limit the resources used in the analysis. 
This is suitable for the computers we are using in this workshop. 
However, make sure to set these options to the maximum resources available on the computer where you process your data.

:::

## Summary

::: {.callout-tip}
## Key Points

- Quality Control of sequencing reads can be automated using a pipeline like bacQC

:::