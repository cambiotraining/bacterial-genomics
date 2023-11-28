---
title: "Command-line AMR prediction"
---

::: {.callout-tip}
## Learning Objectives

- Understand how to predict AMR on command line.

:::

## _Funcscan_ workflow {#sec-funcscan}

Here, we introduce an automated workflow called **[`nf-core/funcscan`](https://nf-co.re/funcscan/1.1.2)** (@fig-funcscan), which uses _Nextflow_ to manage all the software and analysis steps (see information box above).
This pipeline uses five different AMR screening tools: **[ABRicate](https://github.com/tseemann/abricate)**, **[AMRFinderPlus (NCBI Antimicrobial Resistance Gene Finder)](https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/)**, **[fARGene (Fragmented Antibiotic Resistance Gene idENntifiEr)](https://github.com/fannyhb/fargene)**, **[RGI (Resistance Gene Identifier)](https://card.mcmaster.ca/analyze/rgi)**, and **[DeepARG](https://readthedocs.org/projects/deeparg/)**.
This is convenient, as we can obtain the results from multiple approaches in one step. 

![Overview of the `nf-core/funcscan` workflow. In our case we will run the "Antimicrobial Resistance Genes (ARGs)" analysis, shown in yellow. Image source: https://nf-co.re/funcscan/1.1.2](https://raw.githubusercontent.com/nf-core/funcscan/1.1.2/docs/images/funcscan_metro_workflow.png){#fig-funcscan}

This pipeline requires us to prepare a samplesheet CSV file with information about the samples we want to analyse. 
Two columns are required: 

- `sample` --> a sample name of our choice (we will use the same name that we used for the assembly).
- `fasta` --> the path to the FASTA file corresponding to that sample.

You can create this file using a spreadsheet software such as _Excel_, making sure to save the file as a CSV.
Here is an example of our samplesheet, which we saved in a file called `samplesheet_funcscan.csv`: 

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

Once we have the samplesheet ready, we can run the `nf-core/funcscan` workflow using the following commands:

```bash
# activate the environment
mamba activate nextflow

# create output directory
mkdir results/funcscan

# run the pipeline
nextflow run nf-core/funcscan -profile singularity \
  --max_memory 16.GB --max_cpus 8 \
  --input samplesheet_funcscan.csv \
  --outdir results/funcscan \
  --run_arg_screening \
  --arg_skip_deeparg
```

The options we used are: 

- `-profile singularity` - indicates we want to use the _Singularity_ program to manage all the software required by the pipeline (another option is to use `docker`). See [Data & Setup](../../setup.md) for details about their installation.
- `--max_memory` and `--max_cpus` - sets the available RAM memory and CPUs. You can check this with the commands `free -h` and `nproc --all`, respectively.
- `--input` - the samplesheet with the input files, as explained above.
- `--outdir` - the output directory for the results. 
- `--run_arg_screening` - indicates we want to run the "antimicrobial resistance gene screening tools". There are also options to run antimicrobial peptide and biosynthetic gene cluster screening ([see documentation](https://nf-co.re/funcscan/1.1.2/parameters#screening-type-activation)).
- `--arg_skip_deeparg` - this skips a step in the analysis which uses the software _DeepARG_. We did this simply because this software takes a very long time to run. But in a real analysis you may want to leave this option on. 

While the pipeline runs, you will get a progress printed on the screen, and then a message once it finishes. 
Here is an example from our samples:  

```
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


### `funcscan` outputs

The main output of interest from this pipeline is a CSV file, which contains a summary of the results from all the AMR tools used 
This summary is produced by a software called [_hAMRonization_](https://github.com/pha4ge/hAMRonization) and the corresponding CSV file is saved in `results/funcscan/reports/hamronization_summarize/hamronization_combined_report.tsv`. 
You can open this file using any standard spreadsheet software such as _Excel_ (@fig-hamronization). 

This file is quite large, containing many columns and rows (we detail these columns in the information box below). 
The easiest way to query this table is to filter the table based on the column "antimicrobial_agent" to remove rows where no AMR gene was detected (@fig-hamronization). 
This way you are left with only the results which were positive for the AMR analysis. 

![To analyse the table output by _hAMRonization_ in _Excel_ you can go to "Data" --> "Filter". Then, select the dropdown button on the "antimicrobial_agent" column and untick the box "blank". This will only show the genes associated with resistance to antimicrobial drugs.](images/amr_hamronization.svg){#fig-hamronization}

:::{.callout-note collapse=true}
#### _hAMRonization_ report columns (click to expand)

TODO

:::


You can also look at the detailed results of each individual tool, which can be found in the directory `results/funcscan/arg`. 
This directory contains sub-directories for each of the 5 AMR tools used (in our case only 4 folders, because we skipped the _DeepARG_ step):

```bash
ls results/funcscan/arg
```

```
abricate  amrfinderplus  fargene  hamronization  rgi
```

For each individual tool's output folder shown above, there is a report, which is associated with the predicted AMRs for each of our samples. 
In most cases, the report is in tab-delimited TSV format, which can be opened in a standard spreadsheet software such as _Excel_. 
For instance, the AMR report from _Abricate_ for one of our samples looks like this: 

```bash
less -S results/funcscan/arg/abricate/isolate02/isolate02.txt
```

```
#FILE            SEQUENCE  START    END      STRAND  GENE      COVERAGE     COVERAGE_MAP     GAPS  %COVERAGE  %IDENTITY  DATABASE  ACCESSION    PRODUCT                                                         RESISTANCE
isolate02.fasta  contig_2  1696     2623     -       blaPER-7  1-927/927    ========/======  1/1   100.00     99.89      ncbi      NG_049966.1  class A extended-spectrum beta-lactamase PER-7                  CEPHALOSPORIN
isolate02.fasta  contig_2  4895     5738     -       sul1      1-840/840    ========/======  4/4   100.00     98.93      ncbi      NG_048091.1  sulfonamide-resistant dihydropteroate synthase Sul1             SULFONAMIDE
isolate02.fasta  contig_2  6243     7036     -       aadA2     1-792/792    ========/======  2/2   100.00     99.50      ncbi      NG_047343.1  ANT(3'')-Ia family aminoglycoside nucleotidyltransferase AadA2  STREPTOMYCIN
isolate02.fasta  contig_3  966452   967081   +       catB9     1-630/630    ===============  0/0   100.00     99.84      ncbi      NG_047621.1  type B-5 chloramphenicol O-acetyltransferase CatB9              CHLORAMPHENICOL
isolate02.fasta  contig_4  778899   780023   +       varG      1-1125/1125  ===============  0/0   100.00     100.00     ncbi      NG_057468.1  VarG family subclass B1-like metallo-beta-lactamase             CARBAPENEM
isolate02.fasta  contig_4  2573875  2574348  -       dfrA1     1-474/474    ===============  0/0   100.00     100.00     ncbi      NG_047676.1  trimethoprim-resistant dihydrofolate reductase DfrA1            TRIMETHOPRIM
isolate02.fasta  contig_7  4178     5099     -       mph(A)    1-921/921    ========/======  1/1   100.00     99.35      ncbi      NG_047986.1  Mph(A) family macrolide 2'-phosphotransferase                   MACROLIDE
isolate02.fasta  contig_7  6594     8069     +       msr(E)    1-1476/1476  ===============  0/0   100.00     100.00     ncbi      NG_048007.1  ABC-F type ribosomal protection protein Msr(E)                  MACROLIDE
isolate02.fasta  contig_7  8125     9009     +       mph(E)    1-885/885    ===============  0/0   100.00     100.00     ncbi      NG_064660.1  Mph(E) family macrolide 2'-phosphotransferase                   MACROLIDE
isolate02.fasta  contig_7  131405   132197   +       aadA2     1-792/792    ========/======  1/1   100.00     99.62      ncbi      NG_047343.1  ANT(3'')-Ia family aminoglycoside nucleotidyltransferase AadA2  STREPTOMYCIN
```

For this sample there were several putative AMR genes detected by _Abricate_, with their associated drugs. 
These genes were identified based on their similarity with annotated sequences from the NCBI database.
For example, the gene _varG_ was detected in our sample, matching the NCBI accession [NG_057468.1](https://www.ncbi.nlm.nih.gov/nuccore/NG_057468.1).
This is annotated as as a reference for antimicrobial resistance, in this case to the drug "CARBAPENEM".

:::{.callout-note}
#### Command line trick <i class="fa-solid fa-wand-magic-sparkles"></i>

Here is a trick using standard commands to count how many times each drug was identified by `funcscan`:

```bash
cat results/funcscan/reports/hamronization_summarize/hamronization_combined_report.tsv | cut -f 10 | sort | uniq -c
```

- `cat` prints the content of the file
- `cut` extracts the 10th column from the file
- `sort` and `uniq -c` are used in combination to count unique output values

The result of the above command is: 

```
 9 CARBAPENEM
 8 CEPHALOSPORIN
 8 CHLORAMPHENICOL
27 MACROLIDE
13 QUATERNARY AMMONIUM
10 STREPTOMYCIN
 1 SULFONAMIDE
10 TRIMETHOPRIM
```
:::

:::{.callout-exercise}
#### Funcscan workflow

Run the `nf-core/funcscan` workflow on the assembled genomes for your samples. 

- Using _Excel_, create a samplesheet CSV file for your samples, required as input for this pipeline. See @sec-funcscan if you need to revise the format of this samplesheet.
- Activate the software environment: `mamba activate nextflow`.
- Fix the script provided in `scripts/07-amr.sh`.
- Run the script using `bash scripts/07-amr.sh`.

Once the workflow is running it will print a progress message on the screen. 
This will take a while to run, so you can do the next exercise, and then continue with this one. 

Once the analysis finishes, open the output file `results/funcscan/reports/hamronization_summarize/hamronization_combined_report.tsv` in _Excel_. 
Answer the following questions: 

- Did this analysis find evidence for antimicrobial resistance to any drugs?
- Did all your samples show evidence for AMR?


:::{.callout-answer}

We created a samplesheet for our samples in _Excel_, making sure to "Save As..." CSV format. 
The raw file looks like this: 

```
sample,fasta
CTMA_1402,results/assemblies/CTMA_1402.fasta
CTMA_1421,results/assemblies/CTMA_1421.fasta
CTMA_1427,results/assemblies/CTMA_1427.fasta
CTMA_1432,results/assemblies/CTMA_1432.fasta
CTMA_1473,results/assemblies/CTMA_1473.fasta
```

The fixed script is: 

```bash
#!/bin/bash

# create output directory
mkdir results/funcscan

# run the pipeline
nextflow run nf-core/funcscan -profile singularity \
  --max_memory 16.GB --max_cpus 8 \
  --input samplesheet_funcscan.csv \
  --outdir results/funcscan \
  --run_arg_screening \
  --arg_skip_deeparg
```

While the script was running we got a progress of the analysis printed on the screen. 
Once it finished we got a message like this (yours will look slightly different): 

```
Completed at: 12-Aug-2023 12:24:03
Duration    : 44m 54s
CPU hours   : 3.0
Succeeded   : 277
```

We opened the _hAMRonization_ output report file in _Excel_ and filtered it for the column "antimicrobial_agent". 
We identified the following (only a few columns shown for simplicity):

```
input_file_name              gene_symbol  antimicrobial_agent
CTMA_1402.tsv.amrfinderplus  aph(6)-Id    STREPTOMYCIN
CTMA_1402.tsv.amrfinderplus  catB9        CHLORAMPHENICOL
CTMA_1402.tsv.amrfinderplus  dfrA1        TRIMETHOPRIM
CTMA_1402.tsv.amrfinderplus  floR         CHLORAMPHENICOL/FLORFENICOL
CTMA_1402.tsv.amrfinderplus  sul2         SULFONAMIDE
CTMA_1402.tsv.amrfinderplus  varG         CARBAPENEM
CTMA_1421.tsv.amrfinderplus  aph(3'')-Ib  STREPTOMYCIN
CTMA_1421.tsv.amrfinderplus  aph(6)-Id    STREPTOMYCIN
CTMA_1421.tsv.amrfinderplus  catB9        CHLORAMPHENICOL
CTMA_1421.tsv.amrfinderplus  dfrA1        TRIMETHOPRIM
CTMA_1421.tsv.amrfinderplus  floR         CHLORAMPHENICOL/FLORFENICOL
CTMA_1421.tsv.amrfinderplus  sul2         SULFONAMIDE
CTMA_1421.tsv.amrfinderplus  varG         CARBAPENEM
CTMA_1427.tsv.amrfinderplus  aph(3'')-Ib  STREPTOMYCIN
CTMA_1427.tsv.amrfinderplus  aph(6)-Id    STREPTOMYCIN
CTMA_1427.tsv.amrfinderplus  catB9        CHLORAMPHENICOL
CTMA_1427.tsv.amrfinderplus  dfrA1        TRIMETHOPRIM
CTMA_1427.tsv.amrfinderplus  floR         CHLORAMPHENICOL/FLORFENICOL
CTMA_1427.tsv.amrfinderplus  sul2         SULFONAMIDE
CTMA_1427.tsv.amrfinderplus  varG         CARBAPENEM
CTMA_1432.tsv.amrfinderplus  aph(3'')-Ib  STREPTOMYCIN
CTMA_1432.tsv.amrfinderplus  aph(6)-Id    STREPTOMYCIN
CTMA_1432.tsv.amrfinderplus  catB9        CHLORAMPHENICOL
CTMA_1432.tsv.amrfinderplus  dfrA1        TRIMETHOPRIM
CTMA_1432.tsv.amrfinderplus  floR         CHLORAMPHENICOL/FLORFENICOL
CTMA_1432.tsv.amrfinderplus  sul2         SULFONAMIDE
CTMA_1432.tsv.amrfinderplus  varG         CARBAPENEM
CTMA_1473.tsv.amrfinderplus  aph(3'')-Ib  STREPTOMYCIN
CTMA_1473.tsv.amrfinderplus  aph(6)-Id    STREPTOMYCIN
CTMA_1473.tsv.amrfinderplus  catB9        CHLORAMPHENICOL
CTMA_1473.tsv.amrfinderplus  dfrA1        TRIMETHOPRIM
CTMA_1473.tsv.amrfinderplus  floR         CHLORAMPHENICOL/FLORFENICOL
CTMA_1473.tsv.amrfinderplus  sul2         SULFONAMIDE
CTMA_1473.tsv.amrfinderplus  varG         CARBAPENEM
```

All 5 of our samples show evidence of AMR to different antimicrobial drugs. 
All of them are quite similar, with resistance to a similar set of drugs. 

:::
:::

## Summary

::: {.callout-tip}
## Key Points

:::