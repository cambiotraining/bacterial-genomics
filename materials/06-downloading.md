---
title: "Downloading sequence data"
---

::: {.callout-tip}
## Learning Objectives

- Download sequence data from a public database with the nf-core pipeline fetchngs.

:::

## Pipeline Overview

![The fetchngs pipeline](images/nf-core-fetchngs_metro_map_grey.png)

**fetchngs** is a bioinformatics analysis pipeline written in Nextflow to automatically download and process raw FASTQ files from public databases.  Identifiers can be provided in a file and any type of accession ID found in the SRA, ENA, DDBJ and GEO databases are supported. If run accessions (SRR/ERR/DRR) are provided, these will be resolved back to the sample accessions (SRX/ERX/DRX) to allow multiple runs for the same sample to be merged. As well as the FASTQ files, `fetchngs` will also produce a `samplesheet.csv` file containing the sample metadata obtained from the ENA.  This file can be used as input for other nf-core and Nextflow pipelines like the ones we'll be using this week. 

## Prepare a samples file

`fetchngs` requires a samples file with the accessions you would like to download. The file requires the suffix `.csv` but does not need to be in CSV format.  Each line needs to represent a database id:

```
ERR9907668
ERR9907669
ERR9907670
ERR9907671
ERR9907672
```

:::{.callout-exercise}
#### Preparing a samples file

Your first task is to create a `samples.csv` file to be used as input for `fetchngs`.  Use the following accessions:

```
ERR9907668
ERR9907669
ERR9907670
ERR9907671
ERR9907672
```

Make sure you save the file in the `~/Course_Materials/M_tuberculosis` directory.

:::{.callout-answer}

We opened a text editor (e.g. nano. vim), copied and pasted the accessions and saved the file as `samples.csv` in the `~/Course_Materials/M_tuberculosis` directory.

:::
:::

## Running fetchngs

Now that we have the `samples.csv` file, we can run the `fetchngs` pipeline.  First, let's activate the `nextflow` software environment:

```bash
mamba activate nextflow
```

There are [many options](https://nf-co.re/fetchngs/1.12.0/parameters) that can be used to customise the pipeline but a typical command is shown below:

```bash
nextflow run nf-core/fetchngs \
  -r "{{< var version.fetchngs >}}" \
  -profile singularity \
  --input SAMPLES \
  --outdir results/fetchngs \
  --nf_core_pipeline viralrecon \
  --download_method sratools \
  -resume
```

The options we used are: 

- `-profile singularity` - indicates we want to use the _Singularity_ program to manage all the software required by the pipeline (another option is to use `docker`). See [Data & Setup](../setup.md) for details about their installation.
- `--input` - the samples file with the accessions to be downloaded, as explained above.
- `--nf_core_pipeline` - Name of supported nf-core pipeline e.g. 'viralrecon'. A samplesheet for direct use with the pipeline will be created with the appropriate columns.
- `--download_method` - forces the pipeline to use `sratools` instead of a direct FTP download.
- `-resume` - all Nextflow pipelines can be resumed. It isn't necessary for the force run of the pipeline but it's good practice to include it in the command.


:::{.callout-exercise}
#### Running fetchngs

Your next task is to download sequence data with the `fetchngs`.  In the folder `scripts` (in the `M_tuberculosis` analysis directory) you will find a script named `01-run_fetchngs.sh`. This script contains the code to run `fetchngs`. 

- Edit this script, adjusting it to fit your input file.

- Run the script using `bash scripts/01-run_fetchngs.sh`.
  
- If the script is running successfully it should start printing the progress of each job in the `fetchngs` pipeline.

:::{.callout-answer}

- The fixed script is: 

```bash
#!/bin/bash

nextflow run nf-core/fetchngs \
  -r "{{< var version.fetchngs >}}" \
  -profile singularity \
  --input samples.csv \
  --outdir results/fetchngs \
  --nf_core_pipeline viralrecon \
  --download_method sratools \
  -resume
```

- We ran the script as instructed using:

```bash
bash scripts/01-run_fetchngs.sh
```

- While it was running it printed a message on the screen: 

```
executor >  local (20)
[5d/682f49] process > NFCORE_FETCHNGS:SRA:SRA_IDS_TO_RUNINFO (ERR9907668)                                                          [100%] 5 of 5 ✔
[9d/ab8a7b] process > NFCORE_FETCHNGS:SRA:SRA_RUNINFO_TO_FTP (5)                                                                   [100%] 5 of 5 ✔
[f9/39e27c] process > NFCORE_FETCHNGS:SRA:SRA_FASTQ_FTP (ERX9450498_ERR9907670)                                                    [ 80%] 4 of 5
[82/c5f847] process > NFCORE_FETCHNGS:SRA:FASTQ_DOWNLOAD_PREFETCH_FASTERQDUMP_SRATOOLS:CUSTOM_SRATOOLSNCBISETTINGS (ncbi-settings) [100%] 1 of 1 ✔
[-        ] process > NFCORE_FETCHNGS:SRA:FASTQ_DOWNLOAD_PREFETCH_FASTERQDUMP_SRATOOLS:SRATOOLS_PREFETCH                           -
[-        ] process > NFCORE_FETCHNGS:SRA:FASTQ_DOWNLOAD_PREFETCH_FASTERQDUMP_SRATOOLS:SRATOOLS_FASTERQDUMP                        -
[2e/4fd490] process > NFCORE_FETCHNGS:SRA:SRA_TO_SAMPLESHEET (ERX9450498_ERR9907670)                                               [100%] 4 of 4
[-        ] process > NFCORE_FETCHNGS:SRA:SRA_MERGE_SAMPLESHEET                                                                    -
[-        ] process > NFCORE_FETCHNGS:SRA:MULTIQC_MAPPINGS_CONFIG                                                                  -
```

:::
:::

## `fetchngs` results

Once `fetchngs` has run, we can look at the various directories it created in `results/fetchngs`:

| Directory | Description |
|:-- | :---------- |
|`custom` | Contains settings to help the pipeline run |
|`fastq` | Paired-end/single-end reads downloaded from the SRA/ENA/DDBJ/GEO for each accession in the `samples.csv` file |
|`metadata` | Contains the re-formatted ENA metadata for each sample |
|`samplesheet` | Contains the samplesheet with collated metadata and paths to downloaded FASTQ files |
|`pipeline_info` | Contains information about the pipeline run |

:::{.callout-warning}
#### The Nextflow work directory

Each step of the pipeline produces one or more files that are not saved to the results directory but are kept in the work directory.  This means that if, for whatever reason, the pipeline doesn't finish successfully you can resume it.  However, once the pipeline has completed successfully, you no longer need this directory (it can take up a lot of space) so you can delete it:

```bash
rm -rf work
```

:::

## Summary

::: {.callout-tip}
## Key Points

- The nf-core fetchngs pipeline can be used to quickly download sequence data from public databases such as the ENA and GEO.
- The pipeline also produces a `samplesheet.csv` file that can be used as input for other nf-core and Nextflow pipelines.
:::