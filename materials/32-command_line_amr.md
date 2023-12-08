---
title: "Command-line AMR prediction"
---

::: {.callout-tip}
## Learning Objectives

- Apply a standardised workflow to predict AMR.
- Interpret the summarised results from multiple AMR-detection tools.

:::

## _Funcscan_ workflow {#sec-funcscan}

Here, we introduce an automated workflow called [`nf-core/funcscan`](https://nf-co.re/funcscan/1.1.2) (@fig-funcscan), which uses `Nextflow` to manage all the software and analysis steps.

This pipeline uses five different AMR screening tools:

- [`ABRicate`](https://github.com/tseemann/abricate) 
- [`AMRFinderPlus`](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/)  (NCBI Antimicrobial Resistance Gene Finder)
- [`fARGene`](https://github.com/fannyhb/fargene) (Fragmented Antibiotic Resistance Gene idENntifiEr)
- [`RGI`](https://card.mcmaster.ca/analyze/rgi) (Resistance Gene Identifier)
- [`DeepARG`](https://readthedocs.org/projects/deeparg/)

See [Course Software](appendices/02-course_software.md) for a more detailed description of each tool.

Along with the outputs produced by the above tools, the pipeline produces a TSV file, which contains a summary of the results from all the AMR tools used:

- `hamronization_combined_report.tsv` - produced by a software called [_hAMRonization_](https://github.com/pha4ge/hAMRonization)

This is convenient, as we can obtain the results from multiple approaches in one step. 

## Running nf-core/funcscan

![Overview of the `nf-core/funcscan` workflow. In our case we will run the "Antimicrobial Resistance Genes (ARGs)" analysis, shown in yellow. Image source: https://nf-co.re/funcscan/1.1.2](https://raw.githubusercontent.com/nf-core/funcscan/1.1.2/docs/images/funcscan_metro_workflow.png){#fig-funcscan}

We are going to use the assemblies we generated for _S. pneumoniae_ using the `assembleBAC` pipeline as input for `funcscan` and these are located in `preprocessed/assemblebac/assemblies`

The `funcscan` pipeline requires us to prepare a samplesheet CSV file with information about the samples we want to analyse. 
Two columns are required: 

- `sample` --> a sample name of our choice (we will use the same name that we used for the assembly).
- `fasta` --> the path to the FASTA file corresponding to that sample.

You can create this file using a spreadsheet software such as _Excel_, making sure to save the file as a CSV. Here is an example of our samplesheet, which we saved in a file called `samplesheet_funcscan.csv`: 

```
sample,fasta
ERX1265396_ERR1192012_T1,preprocessed/assemblebac/assemblies/ERX1265396_ERR1192012_T1_contigs.fa
ERX1265488_ERR1192104_T1,preprocessed/assemblebac/assemblies/ERX1265488_ERR1192104_T1_contigs.fa
ERX1501202_ERR1430824_T1,preprocessed/assemblebac/assemblies/ERX1501202_ERR1430824_T1_contigs.fa
ERX1501203_ERR1430825_T1,preprocessed/assemblebac/assemblies/ERX1501203_ERR1430825_T1_contigs.fa
ERX1501204_ERR1430826_T1,preprocessed/assemblebac/assemblies/ERX1501204_ERR1430826_T1_contigs.fa
ERX1501205_ERR1430827_T1,preprocessed/assemblebac/assemblies/ERX1501205_ERR1430827_T1_contigs.fa
ERX1501206_ERR1430828_T1,preprocessed/assemblebac/assemblies/ERX1501206_ERR1430828_T1_contigs.fa
ERX1501207_ERR1430829_T1,preprocessed/assemblebac/assemblies/ERX1501207_ERR1430829_T1_contigs.fa
ERX1501208_ERR1430830_T1,preprocessed/assemblebac/assemblies/ERX1501208_ERR1430830_T1_contigs.fa
ERX1501212_ERR1430834_T1,preprocessed/assemblebac/assemblies/ERX1501212_ERR1430834_T1_contigs.fa
```
To save time, we're only going to run `funcscan` on **five** assemblies so you'll need to edit the `samplesheet_funcscan.csv` file. You can do this in _Excel_, deleting all samples except the first five or use `head` to extract the header and five samples on the command line (you'll need to save the output with a different filename and then overwrite the original samplesheet with `mv`):

```bash
head -n 6 samplesheet_funcscan.csv > samplesheet_funcscan.csv.1

mv samplesheet_funcscan.csv.1 samplesheet_funcscan.csv
```

Once we have the samplesheet ready, we can run the `nf-core/funcscan` workflow using the following commands:

```bash
# activate the environment
mamba activate nextflow

# create output directory
mkdir results/funcscan

# run the pipeline
nextflow run nf-core/funcscan \
  -profile singularity \
  --max_memory 16.GB --max_cpus 8 \
  --input SAMPLESHEET \
  --outdir OUTPUT_DIRECTORY \
  --run_arg_screening \
  --arg_skip_deeparg
```

The options we used are: 

- `-profile singularity` - indicates we want to use the _Singularity_ program to manage all the software required by the pipeline (another option is to use `docker`). See [Data & Setup](../setup.md) for details about their installation.
- `--max_memory` and `--max_cpus` - sets the available RAM memory and CPUs. You can check this with the commands `free -h` and `nproc --all`, respectively.
- `--input` - the samplesheet with the input files, as explained above.
- `--outdir` - the output directory for the results. 
- `--run_arg_screening` - indicates we want to run the "antimicrobial resistance gene screening tools". There are also options to run antimicrobial peptide and biosynthetic gene cluster screening ([see documentation](https://nf-co.re/funcscan/1.1.2/parameters#screening-type-activation)).
- `--arg_skip_deeparg` - this skips a step in the analysis which uses the software _DeepARG_. We did this simply because this software takes a very long time to run. But in a real analysis you may want to leave this option on. 

:::{.callout-exercise}
#### Running nf-core/funcscan

Your next task is to run the **funcscan** pipeline on your data.  In the folder `scripts` (within your analysis directory) you will find a script named `05-run_funcscan.sh`. This script contains the code to run `funcscan`. 

- Edit this script, adjusting it to fit your input files and the name of your output directory.

- Activate the `nextflow` software environment.

- Run the script using `bash scripts/05-run_funcscan.sh`.
  
While the pipeline runs, you will get a progress printed on the screen, and then a message once it finishes. 

:::{.callout-answer}

The fixed script is: 

```bash
#!/bin/bash

# create output directory
mkdir results/funcscan

# run the pipeline
nextflow run nf-core/funcscan \
  -profile singularity \
  --max_memory 16.GB --max_cpus 8 \
  --input samplesheet_funcscan.csv \
  --outdir results/funcscan \
  --run_arg_screening \
  --arg_skip_deeparg
```

We ran the script as instructed using:

```bash
bash scripts/05-run_funcscan.sh
```

While it was running it printed a message on the screen:

```bash
* Software dependencies
  https://github.com/nf-core/funcscan/blob/master/CITATIONS.md
------------------------------------------------------
executor >  slurm (1371)
[cf/4d7565] process > NFCORE_FUNCSCAN:FUNCSCAN:INPUT_CHECK:SAMPLESHEET_CHECK (samplesheet_funcscan.csv)   [100%] 1 of 1 ✔
[-        ] process > NFCORE_FUNCSCAN:FUNCSCAN:GUNZIP_FASTA_PREP                                          -
[f5/5767a9] process > NFCORE_FUNCSCAN:FUNCSCAN:BIOAWK (ERX1501218_ERR1430840_T1)                          [100%] 50 of 50 ✔
[a9/164c9c] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:AMRFINDERPLUS_UPDATE (update)                          [100%] 1 of 1, cached: 1 ✔
[8f/6d023e] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:AMRFINDERPLUS_RUN (ERX1501260_ERR1430882_T1)           [100%] 50 of 50 ✔
[6a/c9f0ce] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:HAMRONIZATION_AMRFINDERPLUS (ERX1501260_ERR1430882_T1) [100%] 50 of 50 ✔
[da/67f664] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:FARGENE (ERX1501226_ERR1430848_T1)                     [100%] 500 of 500 ✔
[79/73f7b3] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:HAMRONIZATION_FARGENE (ERX1501226_ERR1430848_T1)       [ 99%] 519 of 520
[0f/d47de8] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:RGI_MAIN (ERX1501263_ERR1430885_T1)                    [100%] 50 of 50 ✔
[21/06df72] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:HAMRONIZATION_RGI (ERX1501263_ERR1430885_T1)           [100%] 50 of 50 ✔
[eb/b67eca] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:ABRICATE_RUN (ERX1501218_ERR1430840_T1)                [100%] 50 of 50 ✔
[d6/e5fdd4] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:HAMRONIZATION_ABRICATE (ERX1501218_ERR1430840_T1)      [100%] 50 of 50 ✔
[-        ] process > NFCORE_FUNCSCAN:FUNCSCAN:ARG:HAMRONIZATION_SUMMARIZE                                -
[-        ] process > NFCORE_FUNCSCAN:FUNCSCAN:CUSTOM_DUMPSOFTWAREVERSIONS                                -
[-        ] process > NFCORE_FUNCSCAN:FUNCSCAN:MULTIQC                                                    -
```

:::
:::

### `funcscan` results

We can look at the output directory (`results/funscan`) to see the various directories containing output files created by `funcscan`:

| Directory | Description |
|:-- | :---------- |
|`arg` | Contains the results of running the ARG sub-workflow |
|`reports` | Contains the `hamronization_combined_report.tsv` file |
|`multiqc` | Contains a html file containing summaries of the various outputs |
|`pipeline_info` | Contains information about the pipeline run |

### The `hamronization_combined_report.tsv` report

The main output of interest from this pipeline is the `hamronization_combined_report.tsv` file, which contains a summary of the results from all the AMR tools used (make sure to use the version in `preprocessed/funcscan/reports`). 
You can open this file using any standard spreadsheet software such as _Excel_ (@fig-hamronization). 

This file is quite large, containing many columns and rows. 
You can find information about the column headers on the [nf-core/funscan "Output" documentation page](https://nf-co.re/funcscan/1.1.3/docs/output#hamronization).
The easiest way to query this table is to filter the table based on the column "antimicrobial_agent" to remove rows where no AMR gene was detected (@fig-hamronization). 
This way you are left with only the results which were positive for the AMR analysis. 

![To analyse the table output by _hAMRonization_ in _Excel_ you can go to "Data" --> "Auto-filter". Then, select the dropdown button on the "antimicrobial_agent" column and untick the box "(Blanks)". This will only show the genes associated with resistance to antimicrobial drugs.](images/amr_hamronization.png){#fig-hamronization}


### Results from other tools

You can also look at the detailed results of each individual tool, which can be found in the directory `preprocessed/funcscan/arg`. 
This directory contains sub-directories for each of the 5 AMR tools used (in our case only 4 folders, because we skipped the _DeepARG_ step):

```bash
ls results/funcscan/arg
```

```
abricate  amrfinderplus  fargene  hamronization  rgi
```

For each individual tool's output folder shown above, there is a report, which is associated with the predicted AMRs for each of our samples. 
In most cases, the report is in tab-delimited TSV format, which can be opened in a standard spreadsheet software such as _Excel_. 
For instance, the AMR report from `Abricate` for one of our samples looks like this: 

```bash
less -S preprocessed/funcscan/arg/abricate/ERX1501203_ERR1430825_T1/ERX1501203_ERR1430825_T1.txt
```

```
#FILE	SEQUENCE	START	END	STRAND	GENE	COVERAGE	COVERAGE_MAP	GAPS	%COVERAGE	%IDENTITY	DATABASE	ACCESSION	PRODUCT	RESISTANCE
ERX1501203_ERR1430825_T1_contigs.fa	contig00008	81930	83849	+	tet(M)	1-1920/1920	===============	0/0	100.00	100.00	ncbi	NG_048235.1	tetracycline resistance ribosomal protection protein Tet(M)	TETRACYCLINE

```

For this sample there was just one putative AMR gene detected by `Abricate`, associated with tetracycline resistance. 
These genes were identified based on their similarity with annotated sequences from the NCBI database.
For example, the gene _Tet(M)_ was detected in our sample, matching the NCBI accession [NG_048235.1](https://www.ncbi.nlm.nih.gov/nuccore/NG_048235.1/).
This is annotated as as a reference for antimicrobial resistance, in this case to the drug "TETRACYCLINE".

:::{.callout-note}
#### Command line trick <i class="fa-solid fa-wand-magic-sparkles"></i>

Here is a trick using standard commands to count how many times each drug was identified by `funcscan`:

```bash
cat preprocessed/funcscan/reports/hamronization_summarize/hamronization_combined_report.tsv | cut -f 10 | sort | uniq -c
```

- `cat` prints the content of the file
- `cut` extracts the 10th column from the file
- `sort` and `uniq -c` are used in combination to count unique output values

The result of the above command is: 

```
1 antimicrobial_agent
12 TETRACYCLINE
```
:::

## Summary

::: {.callout-tip}
#### Key Points

- The `nf-core/funcscan` workflow performs AMR analysis using several software tools. It requires as input a samplesheet with sample names and their respective FASTA files. 
- The results from the several AMR tools are summarised in a single report, which can be conveniently used to filter for putative resistance to antimicrobial agents. 
:::